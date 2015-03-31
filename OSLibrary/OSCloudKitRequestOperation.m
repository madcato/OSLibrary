//
//  OSCloudKitRequestOperation.m
//  OSLibrary
//
//  Created by Daniel Vela on 13/02/15.
//
//

#import "OSCloudKitRequestOperation.h"

@implementation OSCloudKitRequestOperation

- (void)setCompletionBlocksForSuccess:(void ( ^ ) ( OSCloudKitRequestOperation *operation , id responseObject ))success failure:(void ( ^ ) ( OSCloudKitRequestOperation *operation , NSError *error ))failure {
    __weak OSCloudKitRequestOperation *weakSelf = self;
    self.completionBlock = ^{
        if(weakSelf.error) {
            failure(weakSelf,weakSelf.error);
        } else {
            success(weakSelf,weakSelf.responseObject);
        }
    };
}

+(OSCloudKitRequestOperation*)requestOperationOfClass:(NSString*)className
                                              success:(void (^)(OSCloudKitRequestOperation *operation, id responseObject)) success
                                              failure:(void (^)(OSCloudKitRequestOperation *operation, NSError *error)) failure {
    return nil;
}


@end
