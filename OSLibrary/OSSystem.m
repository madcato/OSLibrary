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
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)loadFromConfig:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString*)getPreferredLanguage {
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
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

//Unique string used to identify the keychain item:
static const UInt8 kKeychainItemIdentifier[]    = "org.veladan.app.uniqueid\0";

+ (NSMutableDictionary *)dictionaryToSecItemFormat:(NSString *)identifier
{
    // This method must be called with a properly populated dictionary
    // containing all the right key/value pairs for a keychain item search.

    // Create the return dictionary:
    NSMutableDictionary *returnDictionary =
    [NSMutableDictionary dictionary];

    // Add the keychain item class and the generic attribute:
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier
                                            length:strlen((const char *)kKeychainItemIdentifier)];
    [returnDictionary setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];

    // Convert the password NSString to NSData to fit the API paradigm:
    [returnDictionary setObject:[identifier dataUsingEncoding:NSUTF8StringEncoding]
                         forKey:(__bridge id)kSecValueData];
    return returnDictionary;
}

// Implement the secItemFormatToDictionary: method, which takes the attribute dictionary
//  obtained from the keychain item, acquires the password from the keychain, and
//  adds it to the attribute dictionary:
+ (NSString *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    // This method must be called with a properly populated dictionary
    // containing all the right key/value pairs for the keychain item.

    // Create a return dictionary populated with the attributes:
    NSMutableDictionary *returnDictionary = [NSMutableDictionary
                                             dictionaryWithDictionary:dictionaryToConvert];

    // To acquire the password data from the keychain item,
    // first add the search key and class attribute required to obtain the password:
    [returnDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    // Then call Keychain Services to get the password:
    CFDataRef passwordData = NULL;
    OSStatus keychainError = noErr; //
    keychainError = SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary,
                                        (CFTypeRef *)&passwordData);
    if (keychainError == noErr)
    {
        // Remove the kSecReturnData key; we don't need it anymore:
        [returnDictionary removeObjectForKey:(__bridge id)kSecReturnData];

        // Convert the password to an NSString and add it to the return dictionary:
        NSString *password = [[NSString alloc] initWithBytes:[(__bridge_transfer NSData *)passwordData bytes]
                                                      length:[(__bridge NSData *)passwordData length] encoding:NSUTF8StringEncoding];
        [returnDictionary setObject:password forKey:(__bridge id)kSecValueData];
    }
    // Don't do anything if nothing is found.
    else if (keychainError == errSecItemNotFound) {
        NSAssert(NO, @"Nothing was found in the keychain.\n");
        if (passwordData) CFRelease(passwordData);
    }
    // Any other error is unexpected.
    else
    {
        NSAssert(NO, @"Serious error.\n");
        if (passwordData) CFRelease(passwordData);
    }
    
    return returnDictionary[(__bridge id)kSecValueData];
}

+ (NSString*)getOrCreateAppUniqueIdentifier {

    NSMutableDictionary* genericPasswordQuery = [[NSMutableDictionary alloc] init];
    // This keychain item is a generic password.
    [genericPasswordQuery setObject:(__bridge id)kSecClassGenericPassword
                             forKey:(__bridge id)kSecClass];
    // The kSecAttrGeneric attribute is used to store a unique string that is used
    // to easily identify and find this keychain item. The string is first
    // converted to an NSData object:
    NSData *keychainItemID = [NSData dataWithBytes:kKeychainItemIdentifier
                                            length:strlen((const char *)kKeychainItemIdentifier)];
    [genericPasswordQuery setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    // Return the attributes of the first match only:
    [genericPasswordQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    // Return the attributes of the keychain item (the password is
    //  acquired in the secItemFormatToDictionary: method):
    [genericPasswordQuery setObject:(__bridge id)kCFBooleanTrue
                             forKey:(__bridge id)kSecReturnAttributes];

    OSStatus keychainErr = noErr;
    CFMutableDictionaryRef outDictionary = nil;
    // If the keychain item exists, return the attributes of the item:
    keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)genericPasswordQuery,
                                      (CFTypeRef *)&outDictionary);
    if (keychainErr == noErr) {
        // Convert the data dictionary into the format used by the view controller:
        return [self secItemFormatToDictionary:(__bridge_transfer NSMutableDictionary *)outDictionary];
    } else if (keychainErr == errSecItemNotFound) {
        // Put default values into the keychain if no matching
        // keychain item is found:
        if (outDictionary) CFRelease(outDictionary);
        NSUUID* uuid = [NSUUID UUID];
        NSString* uuidString = [uuid UUIDString];


        OSStatus errorcode = SecItemAdd(
                                        (__bridge CFDictionaryRef)[self dictionaryToSecItemFormat:uuidString],
                                        NULL);
        NSAssert(errorcode == noErr, @"Couldn't add the Keychain Item." );
        return uuidString;
    } else {
        // Any other error is unexpected.
        NSAssert(NO, @"Serious error.\n");
        if (outDictionary) CFRelease(outDictionary);
    }





    return @"";
}

@end
