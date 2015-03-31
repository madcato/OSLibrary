//
//  OSCoreDataCloudKitSyncEngine.m
//  OSLibrary
//
//  Created by Daniel Vela on 13/02/15.
//
//

#import "OSCoreDataCloudKitSyncEngine.h"
#import "OSDatabase.h"
#import "OSCloudKitRequestOperation.h"

@interface OSCoreDataCloudKitSyncEngine ()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;
@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation OSCoreDataCloudKitSyncEngine
@synthesize syncInProgress = _syncInProgress;

+ (OSCoreDataSyncEngine *)sharedEngine {
    static OSCoreDataSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[OSCoreDataCloudKitSyncEngine alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedEngine
                                                 selector:@selector(updateBackgroundContext:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:[[OSDatabase defaultDatabase] managedObjectContext]];
    });
    return sharedEngine;
}

- (void)startSync {
    if (!self.syncInProgress) {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self downloadDataForRegisteredObjects:YES toDeleteLocalRecords:NO];
        });
    }
}

- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate toDeleteLocalRecords:(BOOL)toDelete {
    NSMutableArray *operations = [NSMutableArray array];
    
    for (NSString *className in self.registeredClassesToSync) {
        NSDate *mostRecentUpdatedDate = nil;
        if (useUpdatedAtDate) {
            mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
        }
        

        // Download data store in a temporal place
        OSCloudKitRequestOperation *operation =
        [OSCloudKitRequestOperation requestOperationOfClass:className
                                                    success:^(OSCloudKitRequestOperation *operation, id responseObject)
                                                    {
                                                        if ([responseObject isKindOfClass:[NSArray class]]) {
                                                            NSLog(@"Response for %@: %@", className, responseObject);
                                                            // Need to write JSON files to disk
                                                            [self writeJSONResponse:responseObject toDiskForClassWithName:className];
                                                        }
                                                    }
                                                    failure:^(OSCloudKitRequestOperation *operation, NSError *error)
                                                    {
                                                        NSLog(@"Request for class %@ failed with error: %@", className, error);
                                                    }];
        [operations addObject:operation];
    }
    
    [self enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        //        NSLog(@"All operations completed");
        // Need to process JSON records into Core Data
        if (!toDelete) {
            [self processJSONDataRecordsIntoCoreData];
        } else {
            [self processJSONDataRecordsForDeletion];
        }
    }];
}

- (void)processJSONDataRecordsIntoCoreData {
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    //
    // Iterate over all registered classes to sync
    //
    for (NSString *className in self.registeredClassesToSync) {
        if (![self initialSyncComplete]) { // import all downloaded data to Core Data for initial sync
            //
            // If this is the initial sync then the logic is pretty simple, you will fetch the JSON data from disk
            // for the class of the current iteration and create new NSManagedObjects for each record
            //
            NSArray *JSONArray = [self JSONArrayForClassWithName:className];
            NSArray *records = JSONArray;
            for (NSDictionary *record in records) {
                [self newManagedObjectWithClassName:className forRecord:record];
            }
        } else {
            //
            // Otherwise you need to do some more logic to determine if the record is new or has been updated.
            // First get the downloaded records from the JSON response, verify there is at least one object in
            // the data, and then fetch all records stored in Core Data whose objectId matches those from the JSON response.
            //
            NSArray *downloadedRecords = [self JSONDataRecordsForClass:className sortedByKey:@"objectId"];
            if ([downloadedRecords lastObject]) {
                //
                // Now you have a set of objects from the remote service and all of the matching objects
                // (based on objectId) from your Core Data store. Iterate over all of the downloaded records
                // from the remote service.
                //
                NSArray *storedRecords = [self managedObjectsForClass:className sortedByKey:@"objectId" usingArrayOfIds:[downloadedRecords valueForKey:@"objectId"] inArrayOfIds:YES];
                int currentIndex = 0;
                //
                // If the number of records in your Core Data store is less than the currentIndex, you know that
                // you have a potential match between the downloaded records and stored records because you sorted
                // both lists by objectId, this means that an update has come in from the remote service
                //
                for (NSDictionary *record in downloadedRecords) {
                    NSManagedObject *storedManagedObject = nil;
                    
                    // Make sure we don't access an index that is out of bounds as we are iterating over both collections together
                    if ([storedRecords count] > currentIndex) {
                        storedManagedObject = storedRecords[currentIndex];
                    }
                    
                    if ([[storedManagedObject valueForKey:@"objectId"] isEqualToString:[record valueForKey:@"objectId"]]) {
                        //
                        // Do a quick spot check to validate the objectIds in fact do match, if they do update the stored
                        // object with the values received from the remote service
                        //
                        [self updateManagedObject:storedRecords[currentIndex] withRecord:record];
                    } else {
                        //
                        // Otherwise you have a new object coming in from your remote service so create a new
                        // NSManagedObject to represent this remote object locally
                        //
                        [self newManagedObjectWithClassName:className forRecord:record];
                    }
                    currentIndex++;
                }
            }
        }
        //
        // Once all NSManagedObjects are created in your context you can save the context to persist the objects
        // to your persistent store. In this case though you used an NSManagedObjectContext who has a parent context
        // so all changes will be pushed to the parent context
        //
        [managedObjectContext performBlockAndWait:^{
            NSError *error = nil;
            if (![managedObjectContext save:&error]) {
                NSLog(@"Unable to save context for class %@", className);
            }
        }];
        
        //
        // You are now done with the downloaded JSON responses so you can delete them to clean up after yourself,
        // then call your -executeSyncCompletedOperations to save off your master context and set the
        // syncInProgress flag to NO
        //
        [self deleteJSONDataRecordsForClassWithName:className];
    }
    [self downloadDataForRegisteredObjects:NO toDeleteLocalRecords:YES];
}

- (void)processJSONDataRecordsForDeletion {
    NSManagedObjectContext *managedObjectContext = [[OSDatabase backgroundDatabase] managedObjectContext];
    //
    // Iterate over all registered classes to sync
    //
    for (NSString *className in self.registeredClassesToSync) {
        //
        // Retrieve the JSON response records from disk
        //
        NSArray *JSONRecords = [self JSONDataRecordsForClass:className sortedByKey:@"objectId"];
        if ([JSONRecords count] > 0) {
            //
            // If there are any records fetch all locally stored records that are NOT in the list of downloaded records
            //
            NSArray *storedRecords = [self
                                      managedObjectsForClass:className
                                      sortedByKey:@"objectId"
                                      usingArrayOfIds:[JSONRecords valueForKey:@"objectId"]
                                      inArrayOfIds:NO];
            
            //
            // Schedule the NSManagedObject for deletion and save the context
            //
            [managedObjectContext performBlockAndWait:^{
                for (NSManagedObject *managedObject in storedRecords) {
                    [managedObjectContext deleteObject:managedObject];
                }
                NSError *error = nil;
                BOOL saved = [managedObjectContext save:&error];
                if (!saved) {
                    NSLog(@"Unable to save context after deleting records for class %@ because %@", className, error);
                }
            }];
        }
        //
        // Delete all JSON Record response files to clean up after yourself
        //
        [self deleteJSONDataRecordsForClassWithName:className];
    }
    
    //
    // Execute the sync completion operations as this is now the final step of the sync process
    //
    [self executeSyncCompletedOperations];
}

- (void)enqueueBatchOfHTTPRequestOperations:(NSArray *)operations
                              progressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                            completionBlock:(void (^)(NSArray *operations))completionBlock
{
    __block dispatch_group_t dispatchGroup = dispatch_group_create();
    NSBlockOperation *batchedOperation = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(operations);
            }
        });
#if !OS_OBJECT_USE_OBJC
        dispatch_release(dispatchGroup);
#endif
    }];
    
    for (OSCloudKitRequestOperation *operation in operations) {
        OSCompletionBlock originalCompletionBlock = [operation.completionBlock copy];
        __weak __typeof(&*operation)weakOperation = operation;
        operation.completionBlock = ^{
            __strong __typeof(&*weakOperation)strongOperation = weakOperation;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_queue_t queue = strongOperation.successCallbackQueue ?: dispatch_get_main_queue();
#pragma clang diagnostic pop
            dispatch_group_async(dispatchGroup, queue, ^{
                if (originalCompletionBlock) {
                    originalCompletionBlock();
                }
                
                NSUInteger numberOfFinishedOperations = [[operations indexesOfObjectsPassingTest:^BOOL(id op, NSUInteger __unused idx,  BOOL __unused *stop) {
                    return [op isFinished];
                }] count];
                
                if (progressBlock) {
                    progressBlock(numberOfFinishedOperations, [operations count]);
                }
                
                dispatch_group_leave(dispatchGroup);
            });
        };
        
        dispatch_group_enter(dispatchGroup);
        [batchedOperation addDependency:operation];
    }
    
    [self.operationQueue addOperations:operations waitUntilFinished:NO];
    [self.operationQueue addOperation:batchedOperation];
}

@end
