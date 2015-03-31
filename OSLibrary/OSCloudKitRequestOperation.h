//
//  OSCloudKitRequestOperation.h
//  OSLibrary
//
//  Created by Daniel Vela on 13/02/15.
//
//

#import "OSOperation.h"


@interface OSCloudKitRequestOperation : OSOperation

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) OSCompletionBlock completionBlock;
@property (nonatomic, strong) NSURLRequest* request;
@property (nonatomic, assign) dispatch_queue_t successCallbackQueue;

- (void)setCompletionBlocksForSuccess:(void ( ^ ) ( OSCloudKitRequestOperation *operation , id responseObject ))success failure:(void ( ^ ) ( OSCloudKitRequestOperation *operation , NSError *error ))failure;

+(OSCloudKitRequestOperation*)requestOperationOfClass:(NSString*)className
                                              success:(void (^)(OSCloudKitRequestOperation *operation, id responseObject)) success
                                              failure:(void (^)(OSCloudKitRequestOperation *operation, NSError *error)) failure;

@end




