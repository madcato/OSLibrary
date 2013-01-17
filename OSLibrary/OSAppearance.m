//
//  OSAppearance.m
//  ListaCompra2
//
//  Created by Daniel Vela on 19/02/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

#import "OSAppearance.h"

@implementation OSAppearance

+(void)setShadowToNavigationBar:(UINavigationBar*)bar {
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
	CGFloat components[4] = {0, 0, 0, 1};
	CGColorRef almostBlack = CGColorCreate(space,components);
	bar.layer.shadowColor = almostBlack;
    bar.layer.shadowOffset = CGSizeMake(0,4);
    bar.layer.shadowOpacity = 0.3;
    bar.layer.shadowRadius = 4 ;
    bar.layer.masksToBounds = NO;
    bar.layer.shouldRasterize = YES;
    bar.layer.shadowPath = CGPathCreateWithRect(CGRectMake(-20, 0, 1020, 44),NULL);
}

+(void)setShadowToTabBar:(UITabBar*)bar {
    bar.layer.shadowOffset = CGSizeMake(0,-4);
    bar.layer.shadowOpacity = 0.8;
    bar.layer.shadowRadius = 4 ;
    bar.layer.masksToBounds = NO;
    bar.layer.shouldRasterize = YES;
    bar.layer.shadowPath = CGPathCreateWithRect(CGRectMake(-20, 0, 380, 49),NULL);
}

@end
