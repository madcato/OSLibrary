//
//  OSModalManager.h
//  EasyTablet
//
//  Created by Daniel Vela on 14/05/12.
//  Copyright (c) 2012 Inycom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OSModalManagerProtocol <NSObject>

-(void)controllerDidDisappear;

@end

@protocol OSModalControllerProtocol <NSObject>

-(void)setModalDelegate:(id<OSModalManagerProtocol>) dele;

@end

enum modal_mode {
    MODAL_ACTIVE = 1,
    MODAL_INACTIVE = 0
};



@interface OSModalManager : NSObject<OSModalManagerProtocol>

@property (nonatomic, assign) enum modal_mode mode;

@property (atomic, strong) NSMutableArray* controllerArray;

@property (nonatomic, weak) UIViewController* rootViewController;

+ (OSModalManager*)sharedInstance;

+(void)pushModalController:(id<OSModalControllerProtocol>)controller;

@end
