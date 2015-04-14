//
//  OSCloudKitSyncEngine.m
//  OSLibrary
//
//  Created by Daniel Vela on 13/02/15.
//
//

#import "OSCloudKitSyncEngine.h"
#import "OSDatabase.h"
#import "OSCloudKitRequestOperation.h"
typedef enum {
    OSObjectSynced = 0,
    OSObjectCreated = 1,
    OSObjectDeleted = 2,
    OSObjectUpdated = 3
} OSObjectSyncStatus;


NSString * const kOSCloudSyncEngineSyncCompletedNotificationName = @"kOSCloudSyncEngineSyncCompletedNotificationName";
NSString * const kOSCloudKitSyncEngineInitialCompleteKey = @"OSCloudKitSyncEngineInitialCompleteKey";

@interface OSCloudKitSyncEngine ()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) CKContainer* ckContainer;
@property (nonatomic, strong) CKDatabase* ckPublicDB;
@property (nonatomic, assign) BOOL syncInProgress;
@property (nonatomic, strong) OSDatabase* backgroundDatabase;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation OSCloudKitSyncEngine
@synthesize syncInProgress = _syncInProgress;

+ (OSCloudKitSyncEngine *)sharedEngine {
    static OSCloudKitSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[OSCloudKitSyncEngine alloc] init];
        sharedEngine.ckContainer = [CKContainer defaultContainer];
        sharedEngine.ckPublicDB = [sharedEngine.ckContainer publicCloudDatabase];
        sharedEngine.operationQueue = [[NSOperationQueue alloc] init];
        [sharedEngine.operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];

    });
    return sharedEngine;
}

- (void)startSync:(id)observer selector:(SEL)selector {
    if (!self.syncInProgress) {
        [self willChangeValueForKey:@"syncInProgress"];
        _syncInProgress = YES;
        [self didChangeValueForKey:@"syncInProgress"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            self.backgroundDatabase = [OSDatabase backgroundDatabase];
            [self downloadDataForRegisteredObjects:YES toDeleteLocalRecords:NO];
            if(observer) {
                [[NSNotificationCenter defaultCenter] addObserver:observer
                                                         selector:selector
                                                             name:NSManagedObjectContextDidSaveNotification
                                                           object:[self.backgroundDatabase managedObjectContext]];
            }
        });
        
    }
}

- (void)setInitialSyncCompleted {
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:kOSCloudKitSyncEngineInitialCompleteKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)executeSyncCompletedOperations {
    [self setInitialSyncCompleted];
    [self.backgroundDatabase save];
    [self willChangeValueForKey:@"syncInProgress"];
    _syncInProgress = NO;
    [self didChangeValueForKey:@"syncInProgress"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kOSCloudSyncEngineSyncCompletedNotificationName
                                                        object:nil];
}

- (void)registerNSManagedObjectClassToSync:(Class)aClass {
    if (!self.registeredClassesToSync) {
        self.registeredClassesToSync = [NSMutableArray array];
    }
    
    if ([aClass isSubclassOfClass:[NSManagedObject class]]) {
        if (![self.registeredClassesToSync containsObject:NSStringFromClass(aClass)]) {
            [self.registeredClassesToSync addObject:NSStringFromClass(aClass)];
        } else {
            NSLog(@"Unable to register %@ as it is already registered", NSStringFromClass(aClass));
            NSAssert(false, @"Unable to register class in OSCoreDataSyncEngine");
        }
    } else {
        NSLog(@"Unable to register %@ as it is not a subclass of NSManagedObject", NSStringFromClass(aClass));
        
    }
}


- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate toDeleteLocalRecords:(BOOL)toDelete {
    NSMutableArray *operations = [NSMutableArray array];
    
    for (NSString *className in self.registeredClassesToSync) {
        NSDate *mostRecentUpdatedDate = nil;
        if (useUpdatedAtDate) {
            mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
        }
        
        // FIXME: create a query with date when mostRecentUpdatedDate != null
        // Download data
        for (NSString *className in self.registeredClassesToSync) {
            NSPredicate* predicate = [NSPredicate predicateWithValue:YES];
            if (mostRecentUpdatedDate != nil) {
                predicate = [NSPredicate predicateWithFormat:@"modificationDate > %@", mostRecentUpdatedDate];
            }
            CKQuery* query = [[CKQuery alloc] initWithRecordType:className predicate:predicate];
            OSCloudKitRequestOperation* operation = [OSCloudKitRequestOperation operationWithDatabase:self.ckPublicDB query:query completionHandler:^(NSArray* results, NSError* error) {
            // Insert downloaded objects into Core Data
                if (!toDelete) {
                    if ([results lastObject]) {
                        //
                        // Now you have a set of objects from the remote service and all of the matching objects
                        // (based on objectId) from your Core Data store. Iterate over all of the downloaded records
                        // from the remote service.
                        //
                        NSArray *storedRecords = [self managedObjectsForClass:className sortedByKey:@"objectId" usingArrayOfIds:[[results valueForKey:@"recordID"] valueForKey:@"recordName" ] inArrayOfIds:YES];
                        int currentIndex = 0;
                        //
                        // If the number of records in your Core Data store is less than the currentIndex, you know that
                        // you have a potential match between the downloaded records and stored records because you sorted
                        // both lists by objectId, this means that an update has come in from the remote service
                        //
                        for (CKRecord *record in results) {
                            NSManagedObject *storedManagedObject = nil;
                            
                            // Make sure we don't access an index that is out of bounds as we are iterating over both collections together
                            if ([storedRecords count] > currentIndex) {
                                storedManagedObject = storedRecords[currentIndex];
                            }
                            
                            if ([[storedManagedObject valueForKey:@"objectId"] isEqualToString:record.recordID.recordName]) {
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
                } else {
                    // Delete objects when toDelete == YES
                   
                    //
                    // If there are any records fetch all locally stored records that are NOT in the list of downloaded records
                    //
                    NSArray *storedRecords = [self
                                              managedObjectsForClass:className
                                              sortedByKey:@"objectId"
                                              usingArrayOfIds:[[results valueForKey:@"recordID"] valueForKey:@"recordName" ]
                                              inArrayOfIds:NO];
                    
                    //
                    // Schedule the NSManagedObject for deletion and save the context
                    //
                    NSManagedObjectContext *managedObjectContext = [self.backgroundDatabase managedObjectContext];
                    [managedObjectContext performBlockAndWait:^{
                        for (NSManagedObject *managedObject in storedRecords) {
                            [managedObjectContext deleteObject:managedObject];
                        }
                    }];
                }
            }];
            [operations addObject:operation];
        }
    }
    [self enqueueBatchOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
        
    } completionBlock:^(NSArray *operations) {
        if(useUpdatedAtDate == YES)
            [self downloadDataForRegisteredObjects:NO toDeleteLocalRecords:YES];
        else
            [self postLocalObjectsToServer:NO];
    }];
}

- (void)postLocalObjectsToServer:(BOOL)putUpdates {
    //
    // Iterate over all register classes to sync
    //
    for (NSString *className in self.registeredClassesToSync) {
        //
        // Fetch all objects from Core Data whose syncStatus is equal to SDObjectCreated
        //
        NSMutableArray *objectsToProcces;
        if (putUpdates == NO) {
            objectsToProcces = [NSMutableArray arrayWithArray:[self managedObjectsForClass:className withSyncStatus:OSObjectCreated]];
        } else {
            objectsToProcces = [NSMutableArray arrayWithArray:[self managedObjectsForClass:className withSyncStatus:OSObjectUpdated]];
        }

        NSManagedObject* object = nil;
        while ((object = [objectsToProcces lastObject]) != nil) {
            [objectsToProcces removeLastObject];
            
            if (putUpdates == NO) {
                //
                // Create and save CKRecords
                //
                CKRecord* record = [[CKRecord alloc] initWithRecordType:className];
                [self updateRecord:record withManagedObject:object];
                [self.ckPublicDB saveRecord:record completionHandler:^(CKRecord* record, NSError* error){
                    if (error != nil) {
                        NSLog(@"Unable to create record of class: %@ with error %@", className, error);
                    } else {
                        [self updateManagedObject:object withRecord:record];
                    }
                }];
            } else {
                CKRecordID* recordId = [[CKRecordID alloc] initWithRecordName:[object valueForKey:@"objectId"]];
                [self.ckPublicDB fetchRecordWithID:recordId completionHandler:^(CKRecord* record, NSError* error){
                    [self updateRecord:record withManagedObject:object];
                    //
                    // Save record to server
                    //
                    [self.ckPublicDB saveRecord:record completionHandler:^(CKRecord* record, NSError* error){
                        if (error != nil) {
                            NSLog(@"Unable to update record of class: %@ with error %@", className, error);
                        } else {
                            [self updateManagedObject:object withRecord:record];
                        }
                    }];
                }];
            }
        }
    }

    
    if (putUpdates == NO) {
        [self postLocalObjectsToServer:YES];
    } else {
        [self deleteObjectsOnServer];
    }
}

- (void)deleteObjectsOnServer {
    //
    // Iterate over all registered classes to sync
    //
    for (NSString *className in self.registeredClassesToSync) {
        //
        // Fetch all records from Core Data whose syncStatus is equal to SDObjectDeleted
        //
        NSArray *objectsToDelete = [self managedObjectsForClass:className withSyncStatus:OSObjectDeleted];
        //
        // Iterate over all fetched records from Core Data
        //
        for (NSManagedObject *objectToDelete in objectsToDelete) {
            //
            // Create a request for each record
            //
            CKRecordID* recordId = [[CKRecordID alloc] initWithRecordName:[objectToDelete valueForKey:@"objectId"]];
            [self.ckPublicDB deleteRecordWithID:recordId completionHandler:^(CKRecordID* recordId, NSError* error) {
                //
                // Deleted record to server
                //
                if (error != nil) {
                    NSLog(@"Unable to delete record of class: %@ with error %@", className, error);
                } else {
                    NSManagedObjectContext *managedObjectContext = [self.backgroundDatabase managedObjectContext];
                    [managedObjectContext performBlockAndWait:^{
                        [managedObjectContext deleteObject:objectToDelete];
                    }];
                }
            }];

        }
    }
    
    [self executeSyncCompletedOperations];
}

- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName {
    __block NSDate *date = [NSDate dateWithTimeIntervalSince1970:0];
    //
    // Create a new fetch request for the specified entity
    //
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    //
    // Set the sort descriptors on the request to sort by updated_at in descending order
    //
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updated_at" ascending:NO]]];
    //
    // You are only interested in 1 result so limit the request to 1
    //
    [request setFetchLimit:1];
    [[self.backgroundDatabase  managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[self.backgroundDatabase managedObjectContext]  executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            //
            // Set date to the fetched result
            //
            date = [[results lastObject] valueForKey:@"updated_at"];
        }
    }];
    
    return date;
}


- (void)updateManagedObject:(NSManagedObject *)managedObject withRecord:(CKRecord *)record {
    NSEntityDescription *attDesc = [managedObject entity];
    NSDictionary *attributesByName = [attDesc attributesByName];
    for (NSString* key in attributesByName.allKeys) {
        id obj = [record objectForKey:key];
        [managedObject setValue:obj forKey:key];
    }
    [managedObject setValue:@(OSObjectSynced) forKey:@"syncStatus"];
    [managedObject setValue:record.recordID.recordName forKey:@"objectId"];
    [managedObject setValue:record.modificationDate forKey:@"updated_at"];
    [managedObject setValue:record.creationDate forKey:@"created_at"];
}

- (void)updateRecord:(CKRecord *)record withManagedObject:(NSManagedObject *)managedObject {
    NSEntityDescription *attDesc = [managedObject entity];
    NSDictionary *attributesByName = [attDesc attributesByName];
    for (NSString* key in attributesByName.allKeys) {
        if ([key isEqualToString:@"syncStatus"] == NO) {
            id obj = [managedObject valueForKey:key];
            [record setObject:obj forKey:key];
        }
    }
}

- (void)newManagedObjectWithClassName:(NSString *)className
                            forRecord:(CKRecord *)record {
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:[self.backgroundDatabase managedObjectContext]];
    for (NSString* key in record.allKeys) {
        id obj = [record objectForKey:key];
        [newManagedObject setValue:obj forKey:key];
    }
    [newManagedObject setValue:@(OSObjectSynced) forKey:@"syncStatus"];
    [newManagedObject setValue:record.recordID.recordName forKey:@"objectId"];
    [newManagedObject setValue:record.modificationDate forKey:@"updated_at"];
    [newManagedObject setValue:record.creationDate forKey:@"created_at"];
}

- (NSArray *)managedObjectsForClass:(NSString *)className withSyncStatus:(OSObjectSyncStatus)syncStatus {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [self.backgroundDatabase managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"syncStatus = %d", syncStatus];
    [fetchRequest setPredicate:predicate];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

- (NSArray *)managedObjectsForClass:(NSString *)className sortedByKey:(NSString *)key usingArrayOfIds:(NSArray *)idArray inArrayOfIds:(BOOL)inIds {
    __block NSArray *results = nil;
    NSManagedObjectContext *managedObjectContext = [self.backgroundDatabase managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:className];
    NSPredicate *predicate;
    if (inIds) {
        predicate = [NSPredicate predicateWithFormat:@"objectId IN %@", idArray];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"NOT (objectId IN %@) AND syncStatus != %d", idArray, OSObjectCreated];
    }
    
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"objectId" ascending:YES]]];
    [managedObjectContext performBlockAndWait:^{
        NSError *error = nil;
        results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return results;
}

- (void)enqueueBatchOperations:(NSArray *)operations
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

-(void)fetchUserInfo {
    OSCloudKitSyncEngine* engine = (OSCloudKitSyncEngine *)[OSCloudKitSyncEngine sharedEngine];
    [engine.ckContainer fetchUserRecordIDWithCompletionHandler:^(CKRecordID* recordID, NSError* error) {
        NSString* recordid = recordID.recordName;
        [engine.ckContainer discoverUserInfoWithUserRecordID:recordID completionHandler:^(CKDiscoveredUserInfo* userInfo, NSError* error){
            int a = 0;
        }];
        [engine.ckContainer discoverAllContactUserInfosWithCompletionHandler:^(NSArray* userInfos, NSError* error){
            int a = 0;
        }];
    }];
}

#pragma mark - Date formatter

- (void)initializeDateFormatter {
    if (!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    }
}

- (NSDate *)dateUsingStringFromAPI:(NSString *)dateString {
    [self initializeDateFormatter];
    return [self.dateFormatter dateFromString:dateString];
}

- (NSString *)dateStringForAPIUsingDate:(NSDate *)date {
    [self initializeDateFormatter];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    return dateString;
}

@end
