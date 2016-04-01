//
//  OSTopBarActivityIndicatorManager.m
//  OSLibrary
//
//  Created by Daniel Vela on 01/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import "OSTopBarActivityIndicatorManager.h"
#import "OSTopBarActivityIndicator.h"

static OSTopBarActivityIndicatorManager* gManager = nil;

@interface OSTopBarActivityIndicatorManager () {
    NSUInteger activations;
}

@property (nonatomic, strong) OSTopBarActivityIndicator* indicator;

@end

@implementation OSTopBarActivityIndicatorManager

- (instancetype)initWithActivityIndicator:(OSTopBarActivityIndicator*)indicator {
    self = [OSTopBarActivityIndicatorManager new];
    if (self) {
        self.indicator = indicator;
        gManager = self;
    }
    return self;
}

- (void)startActivityInternal {
    if (activations == 0) {
        [self.indicator startActivity];
    }
    activations += 1;
}

- (void)stopActivityInternal {
    if (activations == 1) {
        [self.indicator stopActivity];
    }
    if (activations > 0) {
        activations -= 1;
    }
}

+ (void)startActivity {
    [gManager startActivityInternal];
}

+ (void)stopActivity {
    [gManager stopActivityInternal];
}

@end
