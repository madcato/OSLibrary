//
//  PersonAPIClientMock.m
//  OSLibrary
//
//  Created by Daniel Vela on 13/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import "PersonAPIClientMock.h"
#import "OSMockRequestOperation.h"

@interface PersonAPIClientMock () {
    Class operationClass;
}

@property (nonatomic, strong) NSOperationQueue *operationQueue;

@end

@implementation PersonAPIClientMock

+ (PersonAPIClientMock *)sharedClient {
    static PersonAPIClientMock *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [[PersonAPIClientMock alloc] init];
        [sharedClient registerHTTPOperationClass:[OSMockRequestOperation class]];
        sharedClient.operationQueue = [[NSOperationQueue alloc] init];
        [sharedClient.operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
    });
    
    return sharedClient;
}

- (NSMutableURLRequest *)GETRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    return request;
}

- (NSMutableURLRequest *)GETRequestForAllRecordsOfClass:(NSString *)className updatedAfterDate:(NSDate *)updatedDate onlyIds:(BOOL)onlyIds {
    NSMutableURLRequest *request = nil;
    return request;
}

- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = nil;
    return request;
}

- (NSMutableURLRequest *)DELETERequestForClass:(NSString *)className forObjectWithId:(NSString *)objectId {
    NSMutableURLRequest *request = nil;
    return request;
}

- (NSMutableURLRequest *)PUTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters objectId:(NSString*)objectId {
    NSMutableURLRequest *request = nil;
    return request;
}

- (OSHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)
urlRequest success:(void ( ^ ) ( OSHTTPRequestOperation *operation , id responseObject ))success failure:(void ( ^ ) ( OSHTTPRequestOperation *operation , NSError *error ))failure {
    OSMockRequestOperation *requestOperation = [[OSMockRequestOperation alloc] init];
    requestOperation.testError = self.testError;
    requestOperation.testResponseObject = self.testResponseObject;
    [requestOperation setCompletionBlocksForSuccess:success failure:failure];
    return requestOperation;
}

- (BOOL)registerHTTPOperationClass:(Class)opClass {
    operationClass = opClass;
    return YES;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    return nil;
}

- (void)configureRequestForGET:(NSMutableURLRequest *)request parameters:(NSDictionary *)parameters {
}

- (void)configureRequestForPOST:(NSMutableURLRequest *)request parameters:(NSDictionary *)parameters {
}

- (void)configureRequestForDELETE:(NSMutableURLRequest *)request parameters:(NSDictionary *)parameters {
}

- (void)setDefaultHeader:(NSString *)headerKey value:(NSString *)headerValue {
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
    
    for (OSHTTPRequestOperation *operation in operations) {
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
