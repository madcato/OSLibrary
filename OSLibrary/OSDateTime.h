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
 @abstract This method return the current date and time with the system locale 
    format
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

/*!
 @method dateByAddingToDate:years:months:days:hours:minutes:seconds:
 @param fromDate Base date to add date components.
 @param years Number of years
 @param months Number of months
 @param days Number of days
 @param hours Number of hours
 @param minutes Number of minutes
 @param seconds Number of seconds
 @result NSDate*
 @abstract This method generates a new NSDate object by adding the date 
    components to fromDate param.
 @discussion Use this method to add periods of time to a given date. 
    Example: to add one year to today use: [
 [OSDateTime dateByAddingToDate:[NsDate date] years:1 
                                             months:0 
                                               days:0
                                              hours:0 
                                            minutes:0 
                                            seconds:0];
 */
+(NSDate*)dateByAddingToDate:(NSDate*)fromDate
                       years:(NSInteger)numYears
                      months:(NSInteger)numMonths
                        days:(NSInteger)numDays
                       hours:(NSInteger)numHours
                     minutes:(NSInteger)numMinutes
                     seconds:(NSInteger)numSeconds;

@end
