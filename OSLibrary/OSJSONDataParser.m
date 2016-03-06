//
//  OSJSONDataParser.m
//  OSLibrary
//
//  Created by Daniel Vela on 02/08/15.
//  Copyright (c) 2015 veladan. All rights reserved.
//

#import "OSJSONDataParser.h"

@implementation OSJSONDataParser

- (id)parse:(NSData*)data {
    NSError* error;
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

    if (error) {
        NSLog(@"Error JSON: %@", [error localizedDescription]);
        return nil;
    }
    return result;
}

@end
