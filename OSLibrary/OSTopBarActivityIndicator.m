//
//  OSTopBarActivityIndicator.m
//  OSLibrary
//
//  Created by Daniel Vela on 01/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import "OSTopBarActivityIndicator.h"

@implementation OSTopBarActivityIndicator

- (void)startActivity {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)stopActivity {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end
