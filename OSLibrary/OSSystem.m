//
//  OSSystem.m
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSSystem.h"


@implementation OSSystem

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
  }
  return self;
}

+ (double)radians:(double) degrees {
  return degrees * M_PI / 180;
}

+ (NSString*)getDateFormatForCurrentLocale:(NSString*)dateComponents {
  NSLocale *locale = [NSLocale currentLocale];
  NSString *dateFormat;
  dateFormat = [NSDateFormatter dateFormatFromTemplate:dateComponents
                         options:0
                          locale:locale];
  return dateFormat;
}

+ (void)disableIdleTimer {
  // Disable the idle timer
  [[UIApplication sharedApplication] setIdleTimerDisabled: YES];
}

+ (void)invokeMethod:(id)methodName forObject:(id)object {
  [object performSelector:@selector(methodName)];
}

+ (NSMutableDictionary*)loadDictionaryFromResource:(NSString*)fileName {
  NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                           ofType:@"plist"];
  if(path == nil) return nil;
  NSMutableDictionary* plist = [NSMutableDictionary
                  dictionaryWithContentsOfFile:path];
  return plist;
}

+ (NSMutableArray*)loadArrayFromResource:(NSString*)fileName {
  NSString *path = [[NSBundle mainBundle] pathForResource:fileName
                           ofType:@"plist"];
  if(path == nil) return nil;
  NSMutableArray* plist = [NSMutableArray arrayWithContentsOfFile:path];
  return plist;
}

+ (void)redrawView:(UIView*)view {
  [view setNeedsDisplay];
}

+ (BOOL)existObjectInConfiguration:(NSString*)objectName {
  id hasActivated = [[NSUserDefaults standardUserDefaults] objectForKey:objectName];
	if (hasActivated == nil) return NO;
  return YES;
}

+ (void)createObjectInConfiguration:(id)object forKey:(NSString*)objectName {
  [[NSUserDefaults standardUserDefaults] setObject:object forKey:objectName];
}

+ (NSString*)getPreferredLanguage {
  return [NSLocale preferredLanguages][0];
}


+ (float)batteryLevel {
  UIDevice* device = [UIDevice currentDevice];
  device.batteryMonitoringEnabled = YES;
  float level = device.batteryLevel;
  device.batteryMonitoringEnabled = NO;
  return level;
}


+ (float)screenBright {
  UIScreen* screen = [UIScreen mainScreen];
  return screen.brightness;
}

+ (void)setScreenBright:(float)bright {
  UIScreen* screen = [UIScreen mainScreen];
  screen.brightness = bright;
}

+ (void)registerUserDefaults {
  NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings"
                                 ofType:@"bundle"];
  if(!settingsBundle) {
    NSLog(@"Could not find Settings.bundle");
    return;
  }
  NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:
                [settingsBundle
                  stringByAppendingPathComponent:
                    @"Root.plist"]];
  NSArray *preferences = settings[@"PreferenceSpecifiers"];
  NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc]
                        initWithCapacity:
                          [preferences count]];
  for(NSDictionary *prefSpecification in preferences) {
    NSString *key = prefSpecification[@"Key"];
    if(key) {
      if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
        defaultsToRegister[key] = prefSpecification[@"DefaultValue"];
      }
    }
  }
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}

+ (NSString*)appName {
  return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

+ (NSString*)appVersion {
  return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

+ (NSString*)appBuildVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

+ (void)updateAppVersionInSettings {
    NSString *appVersionText = [NSString stringWithFormat:@"%@ (%@)",
                                [OSSystem appVersion], [OSSystem appBuildVersion]];
    
    [[NSUserDefaults standardUserDefaults] setObject:appVersionText
                                              forKey:@"preference_app_version"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
