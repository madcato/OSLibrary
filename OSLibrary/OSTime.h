//
//  OSTime.h
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 @class OSTime
 @abstract Time manipulation functions
 @namespace OSLibrary
 @updated 2011-07-30
 @dependency OSSystem
 */
@interface OSTime : NSObject

/*!
 @method now
 @result NSString*
 @abstract This method return the current time with the system locale format
 */
+(NSString*)now;

@end
