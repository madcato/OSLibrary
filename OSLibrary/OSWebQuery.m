//
//  OSWebQuery.m
//  OSLibrary
//
//  Created by Daniel Vela on 02/08/15.
//  Copyright (c) 2015 veladan. All rights reserved.
//

#import "OSWebQuery.h"

@implementation OSWebQuery

- (instancetype)initWithInterface:(OSWebInterface*)interface
                       dataParser:(OSDataParser*)dataParser {

    if (self = [super init]) {
        self.interface = interface;
        self.dataParser = dataParser;
    }
    return self;
}

- (void)resume:(OSWebQueryHandler)handler {
    NSAssert(self.interface != nil, @"Web interface not set");
    [self.interface get:^(NSInteger statusCode, NSData *responseData, NSError *error) {
        if (error) {
            NSLog(@"Error AperturaSesion: %@", [error localizedDescription]);
            if (handler) {
                handler(nil,error);
            }
            return;
        }
        
        if (statusCode == 200) {
            NSAssert(self.dataParser != nil, @"Data parser not set");
            id result = [self.dataParser parse:responseData];
            if (handler) {
                handler(result,error);
            }
        } else {
            NSLog(@"Error AperturaSesion: statusCode=%ld", (long)statusCode);
            if (handler) {
                handler(nil,nil);
            }
            
        }
    }];
}

@end
