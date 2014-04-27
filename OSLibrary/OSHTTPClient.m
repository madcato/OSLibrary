//
//  OSHTTPClient.m
//  OSLibrary
//
//  Created by Daniel Vela on 26/04/14.
//
//

#import "OSHTTPClient.h"
#import "OSWebRequest.h"

extern const NSTimeInterval defaultTimeout; // default time out in seconds


@interface OSHTTPClient () {
    NSURL *baseURL;
    Class operationClass;
}

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSMutableDictionary *defaultHeaders;
@end

@implementation OSHTTPClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super init];
    if (self) {
        baseURL = url;
        self.operationQueue = [[NSOperationQueue alloc] init];
        [self.operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
        self.defaultHeaders = [NSMutableDictionary dictionary];
    }
    return self;
}

- (OSHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)
urlRequest success:(void ( ^ ) ( OSHTTPRequestOperation *operation , id responseObject ))success failure:(void ( ^ ) ( OSHTTPRequestOperation *operation , NSError *error ))failure {
    OSHTTPRequestOperation *requestOperation = [[operationClass alloc] init];
    requestOperation.request = urlRequest;
    [requestOperation setCompletionBlocksForSuccess:success failure:failure];
    return requestOperation;
}

- (BOOL)registerHTTPOperationClass:(Class)opClass {
    operationClass = opClass;
    return YES;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSURL *url = [baseURL URLByAppendingPathComponent:path];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:url
                                    cachePolicy:
                                    NSURLRequestReloadIgnoringCacheData
                                    timeoutInterval:defaultTimeout];
    [request setHTTPMethod:method];
    if ([method isEqualToString:@"GET"]) {
        [self configureRequestForGET:request parameters:parameters];
    } else if ([method isEqualToString:@"POST"]) {
        [self configureRequestForPOST:request parameters:parameters];
    } else if ([method isEqualToString:@"DELETE"]) {
        [self configureRequestForGET:request parameters:parameters];
    }
    for (NSString *key in [self.defaultHeaders allKeys]) {
        [request setValue:self.defaultHeaders[key] forHTTPHeaderField:key];
    }
    return request;
}

- (void)configureRequestForGET:(NSMutableURLRequest *)request parameters:(NSDictionary *)parameters {
    OSWebRequest *osrequest = [OSWebRequest webRequest];
    NSString *urlWithParams = [osrequest formatURLWith:[request.URL absoluteString]
                   andParams:parameters];
    request.URL = [NSURL URLWithString:urlWithParams];
}

- (void)configureRequestForPOST:(NSMutableURLRequest *)request parameters:(NSDictionary *)parameters {
    
    switch (self.parameterEncoding) {
        case OSFormURLParameterEncoding: {
            OSWebRequest *osrequest = [OSWebRequest init];
            NSString *paramString = [osrequest formatPostParams:parameters];
            NSData* buffer;
            buffer = [paramString dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:buffer];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[buffer length]]
           forHTTPHeaderField:@"Content-Length"];
        }
        break;
        
        case OSJSONParameterEncoding: {
            NSError *error;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:nil error:&error];
            [request setHTTPBody:jsonData];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
            [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]]
           forHTTPHeaderField:@"Content-Length"];
        }
        break;
        default:
            break;
    }
}

- (void)configureRequestForDELETE:(NSMutableURLRequest *)request parameters:(NSDictionary *)parameters {
    
}

- (void)setDefaultHeader:(NSString *)headerKey value:(NSString *)headerValue {
    self.defaultHeaders[headerKey] = headerValue;
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
