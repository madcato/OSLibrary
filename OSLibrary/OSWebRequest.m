//
//  OSWebRequest.m
//  OSLibrary
//
//  Created by Dani Vela on 8/8/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSWebRequest.h"
#import "OSWebRequestAuth.h"

const NSTimeInterval defaultTimeout = 10.0; // default time out in seconds

@interface OSWebRequest () {
  OSRequestHandler requestHandler;
  NSURLConnection* m_connection;
  NSStringEncoding encoding;
  NSMutableData* responseData;
  NSHTTPURLResponse* httpResponse;
  NSTimeInterval timeout;
};

@end

@implementation OSWebRequest

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

- (id)init {
  self = [super init];
  if (self) {
    // Initialization code here.
    encoding = NSUTF8StringEncoding;
    timeout = defaultTimeout;
  }
  return self;
}

+(OSWebRequest*)webRequest {
  return [[OSWebRequest alloc] init];
}

+(OSWebRequest*)webRequestWithAuth:(NSString*)login
            withPassword:(NSString*)password {
  return [[OSWebRequestAuth alloc] initWithCredentials:login withPassword:password];
}

- (void)useEncoding:(NSStringEncoding)enc {
  encoding = enc;
}

- (void)setTimeout:(NSTimeInterval)to
{
  timeout = to;
}

-(void)cancelRequest {
	[m_connection cancel];
}

-(void)download:(NSString*)url withHandler:(OSRequestHandler)handler {
	NSString *scaped_url = [url
              stringByAddingPercentEscapesUsingEncoding:encoding];
	requestHandler = handler;
	responseData = [NSMutableData data];
	NSURLRequest *request = [NSURLRequest requestWithURL:
               [NSURL URLWithString:scaped_url]
                       cachePolicy:
               NSURLRequestUseProtocolCachePolicy
                     timeoutInterval:timeout];
 	m_connection = [[NSURLConnection alloc] initWithRequest:request
                           delegate:self];
}

-(void)get:(NSString*)url
       headers:(NSDictionary*)headers
   withHandler:(OSRequestHandler)handler {
	NSString *scaped_url = [url
                            stringByAddingPercentEscapesUsingEncoding:encoding];
	requestHandler = handler;
	responseData = [NSMutableData data];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                             [NSURL URLWithString:scaped_url]
                                             cachePolicy:
                             NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:timeout];
    [request setHTTPMethod:@"GET"];
    for (NSString* key in [headers allKeys]) {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }

 	m_connection = [[NSURLConnection alloc] initWithRequest:request
                                                   delegate:self];
}

-(void)post:(NSString*)data
    toURL:(NSString*)u
withHandler:(OSRequestHandler)handler {
  NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
  requestHandler = handler;
  NSURL *url = [[NSURL alloc] initWithString:scaped_url];
  responseData = [NSMutableData data];
  NSData* buffer;
  buffer = [data dataUsingEncoding:encoding];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                  initWithURL:url
                  cachePolicy:
                  NSURLRequestReloadIgnoringCacheData
                timeoutInterval:timeout];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:buffer];
  [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[buffer length]]
   forHTTPHeaderField:@"Content-Length"];
  m_connection = [[NSURLConnection alloc] initWithRequest:request
                           delegate:self];
}

-(void)post2:(NSDictionary*)object
     toURL:(NSString*)u
 withHandler:(OSRequestHandler)handler {
  NSString* data = @"";
  for(NSString* key in [object allKeys]) {
    NSString* value = [object valueForKey:key];
    data = [NSString stringWithFormat:@"%@=%@&%@",
        [key stringByAddingPercentEscapesUsingEncoding:encoding],
        [value stringByAddingPercentEscapesUsingEncoding:encoding],
        data];
  }
  NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
  requestHandler = handler;
  NSURL *url = [[NSURL alloc] initWithString:scaped_url];
  responseData = [NSMutableData data];
  NSData* buffer;
  buffer = [data dataUsingEncoding:encoding];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                  initWithURL:url
                  cachePolicy:
                  NSURLRequestReloadIgnoringCacheData
                timeoutInterval:timeout];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:buffer];
  [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[buffer length]]
   forHTTPHeaderField:@"Content-Length"];
  m_connection = [[NSURLConnection alloc] initWithRequest:request
                           delegate:self];
}

-(void)post3:(NSDictionary*)object
       toURL:(NSString*)u
     headers:(NSDictionary*)headers
 withHandler:(OSRequestHandler)handler {
    NSString* data = @"";
    for(NSString* key in [object allKeys]) {
        NSString* value = [object valueForKey:key];
        data = [NSString stringWithFormat:@"%@=%@&%@",
                [key stringByAddingPercentEscapesUsingEncoding:encoding],
                [value stringByAddingPercentEscapesUsingEncoding:encoding],
                data];
    }
    NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
    requestHandler = handler;
    NSURL *url = [[NSURL alloc] initWithString:scaped_url];
    responseData = [NSMutableData data];
    NSData* buffer;
    buffer = [data dataUsingEncoding:encoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:url
                                    cachePolicy:
                                    NSURLRequestReloadIgnoringCacheData
                                    timeoutInterval:timeout];
    for (NSString* key in [headers allKeys]) {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:buffer];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[buffer length]]
   forHTTPHeaderField:@"Content-Length"];
    m_connection = [[NSURLConnection alloc] initWithRequest:request
                                                   delegate:self];
}

-(void)postJson:(NSString*)data
      toURL:(NSString*)u
  withHandler:(OSRequestHandler)handler {
  NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
  requestHandler = handler;
  NSURL *url = [[NSURL alloc] initWithString:scaped_url];
  responseData = [NSMutableData data];
  NSData* buffer;
  buffer = [data dataUsingEncoding:encoding];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                  initWithURL:url
                  cachePolicy:
                  NSURLRequestReloadIgnoringCacheData
                timeoutInterval:timeout];
  [request setHTTPMethod:@"POST"];
  [request setHTTPBody:buffer];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
  [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[buffer length]]
   forHTTPHeaderField:@"Content-Length"];
  m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

-(void)putJson:(NSString*)data
     toURL:(NSString*)u
   withHandler:(OSRequestHandler)handler {
NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
  requestHandler = handler;
  NSURL *url = [[NSURL alloc] initWithString:scaped_url];
  responseData = [NSMutableData data];
  NSData* buffer;
  buffer = [data dataUsingEncoding:encoding];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                  initWithURL:url
                  cachePolicy:
                  NSURLRequestReloadIgnoringCacheData
                timeoutInterval:timeout];
  [request setHTTPMethod:@"PUT"];
  [request setHTTPBody:buffer];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
  [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[buffer length]]
   forHTTPHeaderField:@"Content-Length"];
  m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

- (void)postFile:(NSData*)fileData
    withName:(NSString*)fileName
    withParams:(NSDictionary *)requestData
       toURL:(NSString*)u
   withHandler:(OSRequestHandler)handler {
  NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
  requestHandler = handler;
  responseData = [NSMutableData data];
	NSURL *theURL = [NSURL URLWithString:scaped_url];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL 
                               cachePolicy:
                  NSURLRequestReloadIgnoringCacheData
                             timeoutInterval:timeout];
	[request setHTTPMethod:@"POST"];
	// define post boundary...
	NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
	NSString *boundaryString = [NSString stringWithFormat:
                @"multipart/form-data; boundary=%@",
                boundary];
	[request addValue:boundaryString forHTTPHeaderField:@"Content-Type"];
	// define boundary separator...
	NSString *boundarySeparator = [NSString stringWithFormat:@"--%@\r\n",
                   boundary];
	//adding the body...
	NSMutableData *postBody = [NSMutableData data];
	// adding params...
	for (id key in requestData) {
		NSString *formDataName = [NSString stringWithFormat:
             @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                  key];
		NSString *formDataValue = [NSString stringWithFormat:@"%@\r\n",
                   requestData[key]];
		[postBody appendData:[boundarySeparator
                dataUsingEncoding:encoding]];
		[postBody appendData:[formDataName
                dataUsingEncoding:encoding]];
		[postBody appendData:[formDataValue
                dataUsingEncoding:encoding]];
	}
	// if file is defined, upload it...
	[postBody appendData:[boundarySeparator dataUsingEncoding:encoding]];
	[postBody appendData:[[NSString stringWithFormat:
  @"Content-Disposition: form-data; name=\"audioBody\"; filename=\"%@\"\r\n",
               fileName]
                   dataUsingEncoding:encoding]];
	[postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n"
                dataUsingEncoding:encoding]];
	[postBody appendData:fileData];
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",
               boundary]
                   dataUsingEncoding:encoding]];
	[request setHTTPBody:postBody];
	 m_connection = [[NSURLConnection alloc] initWithRequest:request
                          delegate:self];
}

#pragma mark - Web delegate

-(BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	NSString* authMethod = [protectionSpace authenticationMethod];
	if(authMethod == NSURLAuthenticationMethodHTTPDigest) {
		return YES;
	}
    if(authMethod == NSURLAuthenticationMethodServerTrust) {
		return YES;
	}
	return NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {

    [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];

    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
  [responseData setLength:0];
	httpResponse = (NSHTTPURLResponse*)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
  requestHandler(nil,nil,error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	requestHandler(responseData,httpResponse,nil);  
}

- (NSString*)formatURLWith:(NSString*)baseUrl andParams:(NSDictionary*)params {
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
          [self URLEncodedStringValueWithEncoding:paramName],
          [self URLEncodedStringValueWithEncoding:paramValue]];
  }
  finalUrl = [finalUrl stringByTrimmingCharactersInSet:
        [NSCharacterSet characterSetWithCharactersInString:@"&"]];
  return finalUrl;
}

- (NSString *)URLEncodedStringValueWithEncoding:(NSString*)value {
  return AFPercentEscapedQueryStringPairMemberFromStringWithEncoding(value,
                                     encoding);
}

- (NSString*)formatPostParams:(NSDictionary*)params {
  if([params count] == 0) return @"";
  NSString* finalString = @"";
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
    finalString = [finalString stringByAppendingFormat:@"%@=%@&",
          [self URLEncodedStringValueWithEncoding:paramName],
          [self URLEncodedStringValueWithEncoding:paramValue]];
  }
  finalString = [finalString stringByTrimmingCharactersInSet:
        [NSCharacterSet characterSetWithCharactersInString:@"&"]];
  return finalString;
}

-(void)doSyncRequest:(NSURLRequest *)urlRequest
     withHandler:(OSRequestHandler)handler {
    requestHandler = handler;
    NSHTTPURLResponse* urlResponse;
    NSError *error;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&urlResponse error:&error];
    requestHandler(data,urlResponse,error);
}
@end