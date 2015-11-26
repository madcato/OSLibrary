//
//  OSCloudKitRequestOperation.h
//  OSLibrary
//
//  Created by Daniel Vela on 11/04/15.
//
//

#import "OSOperation.h"

typedef void (^OSCKCompletionBlock)(NSArray /* CKRecord */ *results, NSError *error);

@interface OSCloudKitRequestOperation : OSOperation

@property (nonatomic, assign) dispatch_queue_t successCallbackQueue;

+(OSCloudKitRequestOperation*)operationWithDatabase:(CKDatabase*)database query:(CKQuery*)query completionHandler:(OSCKCompletionBlock)completionOperation;

@end
