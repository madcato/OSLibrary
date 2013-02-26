//
//  OSSystem.h
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>


#define IOS_VERSION_EQUAL_TO(v)          ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v)        ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v)         ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)   ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define INTERFACE_IS_PAD             ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) 
#define INTERFACE_IS_PHONE             ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) 

/*!
 @class OSDate
 @abstract System related functions: device info, system configuration, etc
 @namespace OSLibrary
 @updated 2011-07-30
 */
@interface OSSystem : NSObject

/*!
 @method radians
 @abstract Transforms degrees to radians
*/
+ (double)radians:(double) degrees;

/*!
 @method getDateFormatForCurrentLocale
 @result NSString*
 @param dateComponents A string containing date format patterns 
  (such as “MM” or “h”). For full details, 
  see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
 @abstract This method return the current locale format for the components 
  specified.
 */
+ (NSString*)getDateFormatForCurrentLocale:(NSString*)dateComponents;

/*!
 @method disableIdleTimer
 @abstract Disable the idle timer of the app
 @discussion This method is used to avoid the screen to autolock when the
  application is been idle for a time. Use this only for debugging.
*/
+ (void)disableIdleTimer;

/*!
 @method invokeMethod:forObject:
 @abstract Invoke a mothod of an object
 @discussion This method is used to invoke a selector of an object.
 @param methodName Name of the mehtod
 @param object Object to be invoked
*/
+ (void)invokeMethod:(id)methodName forObject:(id)object;

/*!
 @method loadDictionaryFromResource
 @abstract Load a dictionary structure stored in a plist file inside the main bundle.
 @discussion If the file doesn't exists, this method return nil. 
 @param fileName The path to the file without the .plist extension
 @return a mutable dictionary object.
*/
+ (NSMutableDictionary*)loadDictionaryFromResource:(NSString*)fileName;

/*!
 @method loadArrayFromResource
 @abstract Load an array structure stored in a plist file inside the main bundle.
 @discussion If the file doesn't exists, this method return nil. 
 @param fileName The path to the file without the .plist extension
 @return a mutable array object.
 */
+ (NSMutableArray*)loadArrayFromResource:(NSString*)fileName;

/*!
 @method redrawView
 @abstract Redraw a view
*/
+ (void)redrawView:(UIView*)view;

/*!
 @method existObjectInConfiguration
 @abstract Check if an object is created in NSUserDefaults
 @return YES if exists
*/
+ (BOOL)existObjectInConfiguration:(NSString*)objectName;

/*!
 @method createObjectInConfiguration
 @abstract Create and stores an object in configuration
 @param object Object to store.
 @param objectName Name for the key assigned to this new entry
*/
+ (void)createObjectInConfiguration:(id)object forKey:(NSString*)objectName;

/*!
 @method getPreferredLanguage
 @abstract Return the user selected preferred language identificator.
 @return An string with the language id, like canonicalized IETF BCP 47 
  language identifier such as “en” or “fr”
 */
+ (NSString*)getPreferredLanguage;

/*! 
 @method batteryLevel
 @abstract Retrive battery level
 @return A value form 0.0 to 1.0
 */
+ (float)batteryLevel;

/*!
 @method screenBright
 @abstract Screen brightness
 @return A value from0.0 to 1.0
*/
+ (float)screenBright;
  
/*!
 @method setScreenBright
 @abstract Sets a new screen bright
 @param Value from 0.0 to 1.0
 */
+ (void)setScreenBright:(float)bright;

/*! 
 @method registerUserDefaults
 @abstract Register the default values in Settings.bundle
 @discussion iOS load the Settings bundle automatically. But it doesn't register
  de default values. This method can do it. Call this method only once in
  first load, because it overwrite any previous value user entered.
 */
+ (void)registerUserDefaults;

/*!
 @method appName
 @abstract Get the app name
 @return the app name
*/
+ (NSString*)appName;

/*!
 @method appVersion
 @abstract Get the app version
 @return the app version
 */
+ (NSString*)appVersion;

@end


/*
 http://iphone-dev-kitchan.blogspot.com.es/2010/08/text-to-speech-using.html
 
 #import  <foundation/foundation.h>
 
 @interface VSSpeechSynthesizer : NSObject 
 { 
 } 
 
 + (id)availableLanguageCodes; 
 + (BOOL)isSystemSpeaking; 
 - (id)startSpeakingString:(id)string; 
 - (id)startSpeakingString:(id)string toURL:(id)url; 
 - (id)startSpeakingString:(id)string toURL:(id)url withLanguageCode:(id)code; 
 - (float)rate;       // default rate: 1 
 - (id)setRate:(float)rate; 
 - (float)pitch;       // default pitch: 0.5
 - (id)setPitch:(float)pitch; 
 - (float)volume;     // default volume: 0.8
 - (id)setVolume:(float)volume; 
 @end
*/