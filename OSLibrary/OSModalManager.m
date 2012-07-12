//
//  OSModalManager.m
//  EasyTablet
//
//  Created by Daniel Vela on 14/05/12.
//  Copyright (c) 2012 Inycom. All rights reserved.
//

#import "OSModalManager.h"

@implementation OSModalManager

@synthesize controllerArray;
@synthesize  mode;
@synthesize rootViewController;

+(void)pushModalController:(id<OSModalControllerProtocol>)controller {
    
    OSModalManager* manager = [OSModalManager sharedInstance];
    
    [controller setModalDelegate:manager];
    
    [manager.controllerArray addObject:controller];
    
    
    [manager pushModalControllerNow];
    
}

-(void)pushModalControllerNow {
    
    if([controllerArray count] == 0) return;
    
    if(self.mode == MODAL_ACTIVE) return;
    self.mode = MODAL_ACTIVE;
    
    UIViewController* controller = [controllerArray objectAtIndex:0];
    [controllerArray removeObjectAtIndex:0];
    
    if(self.rootViewController != nil)
        [self.rootViewController presentModalViewController:controller animated:YES];
}

#pragma mark - Delegate

-(void)controllerDidDisappear {
    self.mode = MODAL_INACTIVE;
    
    [self pushModalControllerNow];
}

#pragma mark - Singleton 

static OSModalManager* sharedManager = nil;
+ (OSModalManager*)sharedInstance
{    
    if (sharedManager == nil) {
        sharedManager = [[super allocWithZone:NULL] init];
        
        sharedManager.controllerArray = [NSMutableArray array];
        sharedManager.mode = MODAL_INACTIVE;
    }
    return sharedManager;
}


+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
