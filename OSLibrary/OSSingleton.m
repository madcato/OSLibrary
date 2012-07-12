//
//  OSSingleton.m
//  testsingleton
//
//  Created by Daniel Vela on 20/06/12.
//  Copyright (c) 2012 Inycom. All rights reserved.
//

#import "OSSingleton.h"

@implementation OSSingleton


+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id)init {
    if (self = [super init]) {
        // Init code here
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedManager] retain];
}
 
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
 
- (id)retain
{
    return self;
}
 
- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}
 
- (void)release
{
    //do nothing
}
 
- (id)autorelease
{
    return self;
}

@end
