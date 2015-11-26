//
//  OSHTTPRequestOperation.m
//  OSLibrary
//
//  Created by Daniel Vela on 26/04/14.
//
//

#import "OSHTTPRequestOperation.h"

@interface OSHTTPRequestOperation ()


@end

@implementation OSHTTPRequestOperation

- (void)setCompletionBlocksForSuccess:(void ( ^ ) ( OSHTTPRequestOperation *operation , id responseObject ))success failure:(void ( ^ ) ( OSHTTPRequestOperation *operation , NSError *error ))failure {
    __weak OSHTTPRequestOperation *weakSelf = self;
    self.completionBlock = ^{
            if(weakSelf.error) {
                failure(weakSelf,weakSelf.error);
            } else {
                success(weakSelf,weakSelf.responseObject);
            }
    };
}
@end

