//
//  OSDateTime.h
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class OSDateTime
 @abstract Date and time manipulation functions
 @namespace OSLibrary
 @updated 2011-07-30
 @dependency OSSystem
 */
@interface OSDateTime : NSObject

/*!
 @function now
 @result NSString*
 @abstract This method return the current date and time with the system locale format
 */
+(NSString*)now;

@end
