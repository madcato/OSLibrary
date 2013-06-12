//
//  OSCoreDataSyncEngine.m
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//

#import "OSCoreDataSyncEngine.h"
#import "OSDatabase.h"

@interface OSCoreDataSyncEngine ()

@property (nonatomic, strong) NSMutableArray *registeredClassesToSync;
@property (nonatomic, strong) id<HTTPAPIClient> registeredAPIClient;

@end

@implementation OSCoreDataSyncEngine

+ (OSCoreDataSyncEngine *)sharedEngine {
    static OSCoreDataSyncEngine *sharedEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEngine = [[OSCoreDataSyncEngine alloc] init];
    });
    return sharedEngine;
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
            abort();
        }
    } else {
        NSLog(@"Unable to register %@ as it is not a subclass of NSManagedObject", NSStringFromClass(aClass));
        abort();
    }
}

- (void)registerHTTPAPIClient:(id<HTTPAPIClient>)apiClient {
    if (self.registeredAPIClient) {
        NSLog(@"Already registered HTTPAPIClient");
        abort();
    }
    self.registeredAPIClient = apiClient;
}

- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName {
    __block NSDate *date = nil;
    //
    // Create a new fetch request for the specified entity
    //
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    //
    // Set the sort descriptors on the request to sort by updatedAt in descending order
    //
    [request setSortDescriptors:[NSArray arrayWithObject:
                                 [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:NO]]];
    //
    // You are only interested in 1 result so limit the request to 1
    //
    [request setFetchLimit:1];
    [[[OSDatabase backgroundDatabase] managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSArray *results = [[[OSDatabase backgroundDatabase] managedObjectContext]  executeFetchRequest:request error:&error];
        if ([results lastObject])   {
            //
            // Set date to the fetched result
            //
            date = [[results lastObject] valueForKey:@"updatedAt"];
        }
    }];

    return date;
}

- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate {
    NSMutableArray *operations = [NSMutableArray array];

    for (NSString *className in self.registeredClassesToSync) {
        NSDate *mostRecentUpdatedDate = nil;
        if (useUpdatedAtDate) {
            mostRecentUpdatedDate = [self mostRecentUpdatedAtDateForEntityWithName:className];
        }
        NSMutableURLRequest *request = [self.registeredAPIClient
                                        GETRequestForAllRecordsOfClass:className
                                        updatedAfterDate:mostRecentUpdatedDate];
        AFHTTPRequestOperation *operation = [[SDAFParseAPIClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"Response for %@: %@", className, responseObject);
                // 1
                // Need to write JSON files to disk

            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Request for class %@ failed with error: %@", className, error);
        }];

        [operations addObject:operation];
    }

    [self.registeredAPIClient enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {

    } completionBlock:^(NSArray *operations) {
        NSLog(@"All operations completed");
        // 2
        // Need to process JSON records into Core Data
    }];
}

@end
