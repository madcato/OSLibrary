//
//  OSSystem.m
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OSSystem.h"

@implementation OSSystem

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

+(NSString*)getDateFormatForCurrentLocale:(NSString*)dateComponents {

    NSLocale *locale = [NSLocale currentLocale];  

    NSString *dateFormat;

    dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:locale];
    
    
    return dateFormat;
}

@end
