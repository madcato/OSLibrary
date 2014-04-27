//
//  OSJSONRequestOperation.m
//  OSLibrary
//
//  Created by Daniel Vela on 26/04/14.
//
//

#import "OSJSONRequestOperation.h"

@interface OSJSONRequestOperation ()

@property (nonatomic, strong) OSWebRequest* webRequest;

@end

@implementation OSJSONRequestOperation

- (void)main {
    @try {
        [self doRequest];
        [self completeOperation];
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}

- (void)doRequest {
    self.webRequest = [OSWebRequest webRequest];
    [self.webRequest doSyncRequest:self.request withHandler:
     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
         if (error) {
             self.error = error;
         } else {
             NSError *error2;
             self.responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:nil error:&error2];
             if (error2) {
                 self.error = error2;
             }
         }
         [self completionBlock];
     }];
}

@end
