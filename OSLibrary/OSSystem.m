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

+(double)radians:(double) degrees { return degrees * M_PI / 180; }

+(NSString*)getDateFormatForCurrentLocale:(NSString*)dateComponents {

    NSLocale *locale = [NSLocale currentLocale];  

    NSString *dateFormat;

    dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents options:0 locale:locale];
    
    
    return dateFormat;
}

+(void)disableIdleTimer {
    // Disable the idle timer
    [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
}

+(void)invokeMethod:(id)methodName forObject:(id)object {
    [object performSelector:@selector(methodName)];
}

+(NSMutableDictionary*)loadDictionaryFromResource:(NSString*)fileName {
    

    NSString *path = [[NSBundle mainBundle] pathForResource:@"fileName" ofType:@"plist"];
    
    if(path == nil) return nil;

    NSMutableDictionary* plist = [NSMutableDictionary dictionaryWithContentsOfFile:path];

    return plist;
}

+(NSMutableArray*)loadArrayFromResource:(NSString*)fileName {    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fileName" ofType:@"plist"];
    
    if(path == nil) return nil;
    
    NSMutableArray* plist = [NSMutableArray arrayWithContentsOfFile:path];
    
    return plist;
}

+(void)redrawView:(UIView*)view {
    [view setNeedsDisplay];
}

+(BOOL)existObjectInConfiguration:(NSString*)objectName {
    id hasActivated = [[NSUserDefaults standardUserDefaults] objectForKey:objectName];
	if (hasActivated == nil) return NO;
    
    return YES;
}

+(void)createObjectInConfiguration:(id)object forKey:(NSString*)objectName {
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:objectName];
}
@end
