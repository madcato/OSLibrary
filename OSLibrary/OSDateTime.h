//
//  OSDateTime.h
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 veladan. All rights reserved.
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
 @method now
 @result NSString*
 @abstract This method return the current date and time with the system locale format
 */
+(NSString*)now;

/*!
 @method dateFromString
 @param str input string
 @result NSDate*
 @abstract This method parses the input string and generates the NSDate object.
 @discussion The string date format is "yyyy-MM-dd'T'HH:mm:ss.SSSZ" UTC
 */
+(NSDate*)dateFromString:(NSString*)str;

/*!
 @method stringFromDate
 @param date NSDate object
 @result NSString*
 @abstract This method generates an string representation from an NSDate.
 @discussion The string date format is "yyyy-MM-dd'T'HH:mm:ss.SSSZ" UTC
 */
+(NSString*)stringFromDate:(NSDate*)date;
@end
