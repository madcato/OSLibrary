//
//  OSDateTime.m
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSDateTime.h"
#import "OSSystem.h"


static NSDateFormatter* dateFormatter = nil;

@implementation OSDateTime

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}

+(NSString*)now {
  NSString* format = [OSSystem getDateFormatForCurrentLocale:@"HmyMd"];
  NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
  [fmt setDateFormat:format];
  return [fmt stringFromDate:[NSDate new]];
}

+(void)initDateFormatter{
  dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateStyle = kCFDateFormatterNoStyle;
  dateFormatter.timeStyle = kCFDateFormatterNoStyle;
  dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";
  NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
  dateFormatter.timeZone = timeZone;
}

+(NSDate*)dateFromString:(NSString*)str {
  if(dateFormatter == nil) [OSDateTime initDateFormatter];
  return [dateFormatter dateFromString:str];
}

+(NSString*)stringFromDate:(NSDate*)date {
  if(dateFormatter == nil) [OSDateTime initDateFormatter];
  return [dateFormatter stringFromDate:date];
}

+(NSDate*)dateByAddingToDate:(NSDate*)fromDate
             years:(NSInteger)numYears
            months:(NSInteger)numMonths
            days:(NSInteger)numDays
             hours:(NSInteger)numHours
           minutes:(NSInteger)numMinutes
           seconds:(NSInteger)numSeconds {
  NSDateComponents* components = [[NSDateComponents alloc] init];
  components.year = numYears;
  components.month = numMonths;
  components.day = numDays;
  components.hour = numHours;
  components.minute = numMinutes;
  components.second = numSeconds;
  NSCalendar* calendar = [NSCalendar currentCalendar];
  return [calendar dateByAddingComponents:components
                   toDate:fromDate
                  options:0];
}

@end
