//
//  OSTime.m
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSTime.h"
#import "OSSystem.h"

@implementation OSTime

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}

+(NSString*)now {
  NSString* format = [OSSystem getDateFormatForCurrentLocale:@"Hm"];
  NSDateFormatter* fmt = [[NSDateFormatter alloc] init];
  [fmt setDateFormat:format];
  return [fmt stringFromDate:[NSDate new]];
}

@end
