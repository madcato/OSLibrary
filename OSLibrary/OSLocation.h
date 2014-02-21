//
//  OSLocation.h
//  OSLibrary
//
//  Created by Dani Vela on 8/6/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OSLocation : NSObject

/*! 
 @method locationServiceEnabled 
 @abstract Return the state of the authorization status of the location service for the app.
 @discussion This method blocks the execution if the user has not decided yet if th app has authorization for use the location services of the phone.
 @return YES if the app has auth, NO otherwise.
*/
+ (BOOL)locationServiceEnabled;

@end
