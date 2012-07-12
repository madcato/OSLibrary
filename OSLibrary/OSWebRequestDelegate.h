//
//  OSWebRequestDelegate.h
//  Farmacia
//
//  Created by Daniel Vela on 30/05/12.
//  Copyright (c) 2012 Inycom. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @protocol OSWebRequestDelegate 
 @abstract This protocol must be implemented by the object that will receive the notification of a web request.
 @discussion This protocol has two methods. requestDidFinishWithString is called when a saccesful http operation is completed. requestDidFinishWithError is called when some error ocurred.
 */
@protocol OSWebRequestDelegate <NSObject>
@optional -(void)requestDidFinishWithString:(NSString*)result;
@optional -(void)requestDidFinishWithData:(NSData*)data;
-(void)requestDidFinishWithError:(NSError*)error;
@end
