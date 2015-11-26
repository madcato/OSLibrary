//
//  OSHTTPClient.h
//  OSLibrary
//
//  Created by Daniel Vela on 26/04/14.
//
//

#import <Foundation/Foundation.h>
#import "OSHTTPRequestOperation.h"

typedef NS_ENUM(NSUInteger, OSHTTPClientParameterEncoding ) {
    OSFormURLParameterEncoding,
    OSJSONParameterEncoding,
    OSPropertyListParameterEncoding,
};



@interface OSHTTPClient : NSObject

- (OSHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)
urlRequest success:(void ( ^ ) ( OSHTTPRequestOperation *operation , id responseObject ))success failure:(void ( ^ ) ( OSHTTPRequestOperation *operation , NSError *error ))failure;

- (id)initWithBaseURL:(NSURL *)url;

- (BOOL)registerHTTPOperationClass:(Class)operationClass;

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters;

- (void)setDefaultHeader:(NSString *)headerKey value:(NSString *)headerValue;

@property (nonatomic, assign) OSHTTPClientParameterEncoding parameterEncoding;

- (void)enqueueBatchOfHTTPRequestOperations:(NSArray *)operations
                              progressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock
                            completionBlock:(void (^)(NSArray *operations))completionBlock;

@end
