//
//  HTTPAPIClient.h
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//

#import <Foundation/Foundation.h>

@protocol HTTPAPIClient <NSObject>

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className
                                       updatedAfterDate:(NSDate *)mostRecentUpdatedDate;


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSMutableURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)enqueueBatchOfHTTPRequestOperations:(NSMutableArray *)operations
                              progressBlock:(void (^)(NSUInteger numberOfCompletedOperations, NSUInteger totalNumberOfOperations))progressBlock
                            completionBlock:(void (^)(NSArray *operations))completionBlock;

- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;

- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId;

@end
