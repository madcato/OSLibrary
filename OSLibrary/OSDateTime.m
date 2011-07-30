//
//  OSDateTime.m
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OSDateTime.h"
#import "OSSystem.h"

@implementation OSDateTime

- (id)init
{
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

@end
