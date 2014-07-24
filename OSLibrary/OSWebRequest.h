//
//  OSWebRequest.h
//  OSLibrary
//
//  Created by Dani Vela on 8/8/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^OSRequestHandler)(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error);

/*!
 @class OSWebRequest
 @abstract Web requests class
 */
@interface OSWebRequest : NSObject 

+(OSWebRequest*)webRequest;

+(OSWebRequest*)webRequestWithAuth:(NSString*)login
            withPassword:(NSString*)password;

/*!
 @method useEncoding
 @abstract sets the text encoding for this http communication
 @discussion Default encoding is UTF8.
 @param enc Encoding. Examples: NSISOLatin1StringEncoding or 
  NSUTF8StringEncoding or NSASCIIStringEncoding.
 */
-(void) useEncoding:(NSStringEncoding)enc;


/*!
 @method cancelRequest
 @abstract Cancel the current request.
 @discussion It's important to call this method before destroying 
  the WebRequest object. This is the way to avoid that the delegate 
  object receive method invocations when not expected.
 */
-(void)cancelRequest;

/*!
 @method download:withHandler:
 @abstract Send a GET petition to a web server.
 @discussion Use this method to download any page or file in a HTTP server.
 @param url URL to download
 @param handler this method will be called at the end of request.
 */
-(void)download:(NSString*)url withHandler:(OSRequestHandler)handler;

-(void)get:(NSString*)url headers:(NSDictionary*)headers withHandler:(OSRequestHandler)handler;

/*!
 @method post:toURL:withHandler:
 @abstract Make a POST to an URL
 @discussion Use this method to send data using POST http verb to a server. 
  Sample:
    Name: Jonathan Doe
    Age: 23
    Formula: a + b == 13%!
  are encoded as
  Name=Jonathan+Doe&Age=23&Formula=a+%2B+b+%3D%3D+13%25%21
 @param data Data to send
 @param url Destination URL
 @param handler this method will be called at the end of request.
 */
-(void)post:(NSString*)data
    toURL:(NSString*)url
withHandler:(OSRequestHandler)handler;

/*!
 @method post2:toURL:withHandler:
 @abstract Make a POST to an URL
 @discussion Use this method to send data using POST http verb to a server.
 @param data NSDictionary object with the ky/value pairs to send as the http body.
 @param url Destination URL
 @param handler this method will be called at the end of request.
 */
-(void)post2:(NSDictionary*)object
     toURL:(NSString*)u
 withHandler:(OSRequestHandler)handler;

-(void)post3:(NSDictionary*)object
       toURL:(NSString*)u
     headers:(NSDictionary*)headers
 withHandler:(OSRequestHandler)handler;


/*!
 @method postJson:toURL:withHandler:
 @abstract Make a POST to an URL using JSON content-type.
 @discussion Use this method to send data using POST http verb to a server. 
  Only when Content-type must be Json data.
 @param data Data to send
 @param url Destination URL
 @param handler this method will be called at the end of request.
 */
-(void)postJson:(NSString*)data
      toURL:(NSString*)u
  withHandler:(OSRequestHandler)handler;

/*!
 @method puJson:toURL:withHandler:
 @abstract Make a PUT to an URL using JSON content-type.
 @discussion Use this method to send data using POST http verb to a server. 
  Only when Content-type must be Json data.
 @param data Data to send
 @param url Destination URL
 @param handler this method will be called at the end of request.
 */
-(void)putJson:(NSString*)data
     toURL:(NSString*)u
   withHandler:(OSRequestHandler)handler;

/*! 
 @method postFile:withName::withParams:toURL:withHandler:
 @abstract Send a file to a server using multipart/form-data
 */
- (void)postFile:(NSData*)fileData
    withName:(NSString*)fileName
    withParams:(NSDictionary *)requestData
       toURL:(NSString*)u
   withHandler:(OSRequestHandler)handler;

/*!
 @method formatURLWith:andParams:
 @abstract format an URL
 @discussion Construct an URL using first parameter as de base URL and 
  concatenating the params at the end of the URL. The params are formated 
  using the method 
  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding, 
  but only if they ares NSString type. If the type is NSNumber,
  no further format is done.
 @param baseUrl The base URL to use.
 @param params The params to put into the URL
 @return The full final URL
 */
- (NSString*)formatURLWith:(NSString*)baseUrl andParams:(NSDictionary*)params;

- (NSString*)formatPostParams:(NSDictionary*)params;

/*!
 @method doRequest:withHandler:
 @abstract Make a request previously created and configured.
 @discussion Use this method to send a generic request to a server.
 Only when Content-type must be Json data.
 @param handler this method will be called at the end of request.
 */
-(void)doSyncRequest:(NSURLRequest *)urlRequest
    withHandler:(OSRequestHandler)handler;

@end