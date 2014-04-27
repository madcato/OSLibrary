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
    
    self.completionBlock = ^{
            if(self.error) {
                failure(self,self.error);
            } else {
                success(self,self.responseObject);
            }
    };
}
@end

