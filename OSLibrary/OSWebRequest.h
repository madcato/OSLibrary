//
//  OSWebRequest.h
//  OSLibrary
//
//  Created by Dani Vela on 8/8/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSWebRequestDelegate.h"

/*!
 @class OSWebRequest
 @abstract Web requests class
 */
@interface OSWebRequest : NSObject {
    

	NSString *errorDescription;
	id<OSWebRequestDelegate> receiver;
    
    NSURLConnection* m_connection;
    
    NSStringEncoding encoding;
    
    NSString* _user;
    NSString* _password;
};

@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection* m_connection;

@property (nonatomic, retain) NSDictionary* headers;

@property (nonatomic, assign) BOOL silent;

@property (nonatomic, assign) NSInteger statusCode;
/*!
 @method cancelRequest
 @abstract Cancel the current request.
 @discussion It's important to call this method before destroying the WebRequest object. This is the way to avoid that the delegate object receive method invocations when not expected.
 */
-(void)cancelRequest;

/*!
 @method download:withDelegate:
 @abstract Send a GET petition to a web server.
 @discussion Use this method to download any page or file in a HTTP server.
 @param url URL to download
 @param delegate Delegate object that will receive notification. This object must implement the OSWebRequestDelegate protocol.
 */
-(void)download:(NSString*)url withDelegate:(id<OSWebRequestDelegate>)delegate;

/*!
 @method postData:toURL:withDelegate:
 @abstract Make a POST to an URL
 @discussion Use this method to send data using POST http verb to a server.
 @param data Data to send
 @param url Destination URL
 @param delegate Delegate object that will receive notification. This object must implement the OSWebRequestDelegate protocol.
 */
-(void)postData:(NSString*)data toURL:(NSString*)url withDelegate:(id<OSWebRequestDelegate>)delegate;

-(void)handleError:(NSError *)error;

/*!
 @method postJson:toURL:withDelegate:
 @abstract Make a POST to an URL using JSON content-type.
 @discussion Use this method to send data using POST http verb to a server. Only when Content-type must be Json data.
 @param data Data to send
 @param url Destination URL
 @param delegate Delegate object that will receive notification. This object must implement the OSWebRequestDelegate protocol.
 */
-(void)postJson:(NSString*)data toURL:(NSString*)u withDelegate:(id<OSWebRequestDelegate>)delegate;

/*!
 @method puJson:toURL:withDelegate:
 @abstract Make a PUT to an URL using JSON content-type.
 @discussion Use this method to send data using POST http verb to a server. Only when Content-type must be Json data.
 @param data Data to send
 @param url Destination URL
 @param delegate Delegate object that will receive notification. This object must implement the OSWebRequestDelegate protocol.
 */
-(void)putJson:(NSString*)data toURL:(NSString*)u withDelegate:(id<OSWebRequestDelegate>)delegate;


/*! 
 @method postFile:withName::withParams:toURL:withDelegate:
 @abstract Send a file to a server using multipart/form-data
*/
- (void)postFile:(NSData*)fileData withName:(NSString*)fileName withParams:(NSDictionary *)requestData toURL:(NSString*)u withDelegate:(id<OSWebRequestDelegate>)delegate;

/*!
 @method useEncoding
 @abstract sets the text encoding for this http communication
 @discussion Default encoding is UTF8.
 @param enc Encoding. Examples: NSISOLatin1StringEncoding or NSUTF8StringEncoding or NSASCIIStringEncoding.
 */
-(void) useEncoding:(NSStringEncoding)enc;


/*!
 @method useCredentials:withPassword
 @abstract set the credentials for a http digest authentication
 */
-(void)useCredentials:(NSString*)user withPassword:(NSString*)password;

@end
