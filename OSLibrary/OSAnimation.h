//
//  OSAnimation.h
//  OSLibrary
//
//  Created by Dani Vela on 8/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class OSAnimation
 @abstract Animation related utilities
*/
@interface OSAnimation : NSObject

/*!
 @method blinkObject:duringSeconds:
 @abstract blink an object
 @discussion This method makes an UIView object to change its opacity from 1 to 0 repeatidly for a duration.
 @param object the UIView to blink
 @param seconds Number of seconds of the blink effect.
*/
+(void)blinkObject:(UIView*)object duringSeconds:(double)seconds;

@end
