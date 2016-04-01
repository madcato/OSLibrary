//
//  OSWebInterface.m
//  OSLibrary
//
//  Created by Daniel Vela on 02/08/15.
//  Copyright (c) 2015 veladan. All rights reserved.
//

#import "OSWebInterface.h"
#import "OSTopBarActivityIndicatorManager.h"

static NSString * AFPercentEscapedQueryStringPairMemberFromStringWithEncoding
(NSString *string, NSStringEncoding encoding) {
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    return (__bridge_transfer  NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (__bridge CFStringRef)string,
                                            (__bridge CFStringRef)kAFCharactersToLeaveUnescaped,
                                            (__bridge CFStringRef)kAFCharactersToBeEscaped,
                                            CFStringConvertNSStringEncodingToEncoding(encoding));
}

@implementation OSWebInterface

- (id)initWithProtocol:(NSString*)proto server:(NSString*)serv basePath:(NSString*)baseP {
    if (self = [super init]) {
        self.protocol = proto;
        self.server = serv;
        self.basePath = baseP;
        self.encoding = NSUTF8StringEncoding;
    }
    return self;
}

+ (NSString*)percentScape:(NSString*)cadena encoding:(NSStringEncoding)encoding {
    return AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(cadena, encoding);
}

+ (NSString*)URLqueryEscape:(NSString*)cadena {
    return [cadena stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)get:(OSWebInterfaceHandler)handler {
    [OSTopBarActivityIndicatorManager startActivity];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session =
    [NSURLSession sessionWithConfiguration:sessionConfiguration
                                  delegate:self
                             delegateQueue:nil];
    NSURL* url = [NSURL URLWithString:[self URLStringForGetMethod]];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    
    [self addHeaders:request];
    
    [request setHTTPMethod:@"GET"];

    NSURLSessionDataTask* task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData* data, NSURLResponse* response, NSError* error) {\
                                      [OSTopBarActivityIndicatorManager stopActivity];
                                      NSInteger status = -1;
                                      
                                      if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                          NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                          status = httpResponse.statusCode;
                                      }
                                      NSAssert(handler != nil, @"Callback block needed");
                                      handler(status, data, error);
                                  }];
    [task resume];
}


- (void)addHeaders:(NSMutableURLRequest*)request {
    [self.headers enumerateKeysAndObjectsUsingBlock:
     ^(id key, id obj, BOOL *stop) {
         [request addValue:obj forHTTPHeaderField:key];
     }];
}
- (NSString*)baseURLString {
    NSString* urlString;
    
    NSAssert(self.protocol != nil, @"Protocol not specified");
    NSAssert(self.server != nil, @"Server not specified");
    NSAssert(self.basePath != nil, @"BasePath not specified");
    
    urlString = [NSString stringWithFormat:@"%@://%@/%@",
                 self.protocol,
                 self.server,
                 self.basePath];
    
    return urlString;
}

- (NSString*)URLStringForGetMethod {
    NSString* urlString = [self baseURLString];
    
    NSAssert(self.encoding != 0, @"encoding not specified");
    
    urlString = [self formatURLWith:urlString
                         parameters:self.parameters
                           encoding:self.encoding];
    
    return urlString;
}

- (NSString*)formatURLWith:(NSString*)baseUrl
                parameters:(NSDictionary*)params
                  encoding:(NSStringEncoding)encoding{
    NSString* finalUrl = [baseUrl copy];
    if([params count] == 0) return finalUrl;
    finalUrl = [finalUrl stringByAppendingString:@"?"];
    for(NSString* paramName in [params allKeys]) {
        NSString* paramValue = @"";
        id paramValueObj = [params valueForKey:paramName];
        if([paramValueObj isKindOfClass:[NSString class]]) {
            paramValue = [(NSString*)paramValueObj
                          stringByAddingPercentEscapesUsingEncoding:
                          encoding];
        }
        if([paramValueObj isKindOfClass:[NSNumber class]]) {
            paramValue = [(NSNumber*)paramValueObj stringValue];
        }
        finalUrl = [finalUrl stringByAppendingFormat:@"%@=%@&",
                    [self URLEncodedStringValueWithEncoding:paramName
                                                   encoding:encoding],
                    [self URLEncodedStringValueWithEncoding:paramValue
                                                   encoding:encoding]];
    }
    finalUrl = [finalUrl stringByTrimmingCharactersInSet:
                [NSCharacterSet characterSetWithCharactersInString:@"&"]];
    return finalUrl;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSString*)value
                                       encoding:(NSStringEncoding)encoding{
    return AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(value,
                                                                       encoding);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]){
        if(self.bypassServerSSLAuthentication){
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
        }
    }
}

@end
