//
//  HTTPAPIClient.h
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//

#import <Foundation/Foundation.h>
#import "OSHTTPRequestOperation.h"

@protocol HTTPAPIClient <NSObject>

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className
                                       updatedAfterDate:(NSDate *)mostRecentUpdatedDate;


- (OSHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSMutableURLRequest *)request
                                                    success:(void (^)(OSHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(OSHTTPRequestOperation *operation, NSError *error))failure;

- (void)enqueueBatchOfHTTPRequestOperations:(NSMutableArray *)operations
                              progressBlock:(void (^)(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations))progressBlock
                            completionBlock:(void (^)(NSArray *operations))completionBlock;

- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;

- (NSMutableURLRequest *)PUTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters objectId:(NSString*)objectId;

- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId;

@end
