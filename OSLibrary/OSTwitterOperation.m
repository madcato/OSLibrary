//
//  OSTwitterOperation.m
//  OSLibrary
//
//  Created by Daniel Vela on 16/08/12.
//
//

#import "OSTwitterOperation.h"

@implementation OSTwitterOperation

-(id)initWithRequest:(TWRequest*)request withCompletionBlock:(OSRequestHandler)block {
    self = [super init];
    if (self) {
        twitterRequest = request;
        twitterBlock = block;
    }
    return self;
}

- (void)main {
    @try {
        // Do the main work of the operation here.
        [twitterRequest performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
            twitterBlock(responseData,urlResponse,error);
            [super completeOperation];
        }];
    }
    @catch(NSException* exception) {
        // Do not rethrow exceptions.
        NSLog(@"Exception captured: %@, reason: %@",[exception name], [exception reason]);
    }
}
@end
