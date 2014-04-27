//
//  OSHTTPRequestOperation.h
//  OSLibrary
//
//  Created by Daniel Vela on 26/04/14.
//
//

#import <Foundation/Foundation.h>
#import "OSOperation.h"

typedef void (^OSCompletionBlock) (void);

@interface OSHTTPRequestOperation : OSOperation

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id responseObject;
@property (nonatomic, strong) OSCompletionBlock completionBlock;
@property (nonatomic, strong) NSURLRequest* request;
@property (nonatomic, assign) dispatch_queue_t successCallbackQueue;

- (void)setCompletionBlocksForSuccess:(void ( ^ ) ( OSHTTPRequestOperation *operation , id responseObject ))success failure:(void ( ^ ) ( OSHTTPRequestOperation *operation , NSError *error ))failure;

@end
