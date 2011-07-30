//
//  OSSystem.h
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class OSDate
 @abstract System related functions: device info, system configuration, etc
 @namespace OSLibrary
 @updated 2011-07-30
 */
@interface OSSystem : NSObject

/*!
 @function getDateFormatForCurrentLocale
 @result NSString*
 @param dateComponents A string containing date format patterns (such as “MM” or “h”). For full details, see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
 @abstract This method return the current locale format for the components specified.
 */
+(NSString*)getDateFormatForCurrentLocale:(NSString*)dateComponents;

@end
