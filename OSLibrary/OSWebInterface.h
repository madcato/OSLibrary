//
//  OSWebInterface.h
//  OSLibrary
//
//  Created by Daniel Vela on 02/08/15.
//  Copyright (c) 2015 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OSWebInterfaceHandler)(NSInteger statusCode, NSData *responseData, NSError *error);

@interface OSWebInterface : NSObject <NSURLSessionDelegate>

@property (nonatomic, strong) NSString* protocol;
@property (nonatomic, strong) NSString* server;
@property (nonatomic, strong) NSString* basePath;
@property (nonatomic, strong) NSDictionary* parameters;
@property (nonatomic, strong) NSDictionary* headers;
@property (nonatomic, assign) NSStringEncoding encoding;

@property (nonatomic, assign) BOOL bypassServerSSLAuthentication;

- (void)get:(OSWebInterfaceHandler)handler;

- (NSString*)URLStringForGetMethod;
- (NSString*)baseURLString;

+ (NSString*)percentScape:(NSString*)cadena encoding:(NSStringEncoding)encoding;

@end
