//
//  OSMockRequestOperation.m
//  OSLibrary
//
//  Created by Daniel Vela on 13/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import "OSMockRequestOperation.h"

@interface OSMockRequestOperation ()

@end

@implementation OSMockRequestOperation

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
    if (self.testError) {
        self.error = self.testError;
    } else {
        NSError *error2;
        self.responseObject = [NSJSONSerialization JSONObjectWithData:self.testResponseObject options:nil error:&error2];
        if (error2) {
            self.error = error2;
        }
    }
    [self completionBlock];
}


@end

