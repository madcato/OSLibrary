//
//  OSCoreDataSyncEngine.h
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//
// Inspired in http://www.raywenderlich.com/15916/how-to-synchronize-core-data-with-a-web-service-part-1
// and http://www.raywenderlich.com/17927/how-to-synchronize-core-data-with-a-web-service-part-2

#import <Foundation/Foundation.h>

@protocol HTTPAPIClient <NSObject>

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className
                                       updatedAfterDate:(NSDate *)mostRecentUpdatedDate;

//enqueueBatchOfHTTPRequestOperations:operations progressBlock:^(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations) {
//
//} completionBlock:^(NSArray *operations) {
//    NSLog(@"All operations completed");
//    // 2
//    // Need to process JSON records into Core Data
//}
@end

@interface OSCoreDataSyncEngine : NSObject

+ (OSCoreDataSyncEngine *)sharedEngine;

- (void)registerNSManagedObjectClassToSync:(Class)aClass;

- (void)registerHTTPAPIClient:(id<HTTPAPIClient>)apiClient;

@end
