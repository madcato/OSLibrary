//
//  OSSystem.h
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

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
+(double)radians:(double) degrees;

/*!
 @method getDateFormatForCurrentLocale
 @result NSString*
 @param dateComponents A string containing date format patterns (such as “MM” or “h”). For full details, see http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns
 @abstract This method return the current locale format for the components specified.
 */
+(NSString*)getDateFormatForCurrentLocale:(NSString*)dateComponents;

/*!
 @method disableIdleTimer
 @abstract Disable the idle timer of the app
 @discussion This method is used to avoid the screen to autolock when the application is been idle for a time. Use this only for debugging.
*/
+(void)disableIdleTimer;

/*!
 @method invokeMethod:forObject:
 @abstract Invoke a mothod of an object
 @discussion This method is used to invoke a selector of an object.
 @param methodName Name of the mehtod
 @param object Object to be invoked
*/
+(void)invokeMethod:(id)methodName forObject:(id)object;

/*!
 @method loadDictionaryFromResource
 @abstract Load a dictionary structure stored in a plist file inside the main bundle.
 @discussion If the file doesn't exists, this method return nil. 
 @param fileName The path to the file without the .plist extension
 @return a mutable dictionary object.
*/
+(NSMutableDictionary*)loadDictionaryFromResource:(NSString*)fileName;

/*!
 @method loadArrayFromResource
 @abstract Load an array structure stored in a plist file inside the main bundle.
 @discussion If the file doesn't exists, this method return nil. 
 @param fileName The path to the file without the .plist extension
 @return a mutable array object.
 */
+(NSMutableArray*)loadArrayFromResource:(NSString*)fileName;

/*!
 @method redrawView
 @abstract Redraw a view
*/
+(void)redrawView:(UIView*)view;

/*!
 @method existObjectInConfiguration
 @abstract Check if an object is created in NSUserDefaults
 @return YES if exists
*/
+(BOOL)existObjectInConfiguration:(NSString*)objectName;

/*!
 @method createObjectInConfiguration
 @abstract Create and stores an object in configuration
 @param object Object to store.
 @param objectName Name for the key assigned to this new entry
*/
+(void)createObjectInConfiguration:(id)object forKey:(NSString*)objectName;
@end
