//
//  OSWebRequest.m
//  OSLibrary
//
//  Created by Dani Vela on 8/8/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSWebRequest.h"

@implementation OSWebRequest

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        encoding = NSUTF8StringEncoding;
    }
    
    return self;
}

-(void) useEncoding:(NSStringEncoding)enc {
    encoding = enc;
}

-(void)useCredentials:(NSString*)user withPassword:(NSString*)password {
    _user = user;
    _password = password;
}

-(void)dealloc {
    [self cancelRequest];
}

-(void)cancelRequest {
	[m_connection cancel];
}

-(void)get:(NSString*)url withHandler:(OSRequestHandler)handler
{
	NSString *scaped_url = [url stringByAddingPercentEscapesUsingEncoding:encoding];

	requestHandler = handler;
	
	responseData = [NSMutableData data];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:scaped_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
 	m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)post:(NSString*)data toURL:(NSString*)u withHandler:(OSRequestHandler)handler
{
    NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
    
    requestHandler = handler;
    
    NSURL *url = [[NSURL alloc] initWithString:scaped_url];
    
    responseData = [NSMutableData data];
    
    NSData* buffer;
    buffer = [data dataUsingEncoding:encoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:buffer];
    
    [request setValue:[NSString stringWithFormat:@"%d", [buffer length]] forHTTPHeaderField:@"Content-Length"];
    
    m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

-(void)post2:(NSDictionary*)object toURL:(NSString*)u withHandler:(OSRequestHandler)handler
{
    
    NSString* data = @"";
    
    for(NSString* key in [object allKeys]) {
        NSString* value = [object valueForKey:key];
        
        data = [NSString stringWithFormat:@"%@=%@&%@",[key stringByAddingPercentEscapesUsingEncoding:encoding],[value stringByAddingPercentEscapesUsingEncoding:encoding],data];
    }
    
    
    NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
    
    requestHandler = handler;
    
    NSURL *url = [[NSURL alloc] initWithString:scaped_url];
    
    responseData = [NSMutableData data];
    
    NSData* buffer;
    buffer = [data dataUsingEncoding:encoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:buffer];
    
    [request setValue:[NSString stringWithFormat:@"%d", [buffer length]] forHTTPHeaderField:@"Content-Length"];
    
    m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

-(void)postJson:(NSString*)data toURL:(NSString*)u withHandler:(OSRequestHandler)handler
{
    NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
    
    requestHandler = handler;

    NSURL *url = [[NSURL alloc] initWithString:scaped_url];
    
    responseData = [NSMutableData data];
    
    NSData* buffer;
    buffer = [data dataUsingEncoding:encoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:buffer];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [buffer length]] forHTTPHeaderField:@"Content-Length"];
    
    m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

-(void)putJson:(NSString*)data toURL:(NSString*)u withHandler:(OSRequestHandler)handler 
{
    NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
    
    requestHandler = handler;

    NSURL *url = [[NSURL alloc] initWithString:scaped_url];
    
    responseData = [NSMutableData data];

    NSData* buffer;
    buffer = [data dataUsingEncoding:encoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:buffer];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [buffer length]] forHTTPHeaderField:@"Content-Length"];
    
    m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

- (void)postFile:(NSData*)fileData withName:(NSString*)fileName withParams:(NSDictionary *)requestData toURL:(NSString*)u withHandler:(OSRequestHandler)handler
{
    NSString *scaped_url = [u stringByAddingPercentEscapesUsingEncoding:encoding];
    
    requestHandler = handler;
    responseData = [NSMutableData data];
    
	NSURL *theURL = [NSURL URLWithString:scaped_url];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL 
                                                              cachePolicy:NSURLRequestReloadIgnoringCacheData 
                                                          timeoutInterval:20.0f];
	[request setHTTPMethod:@"POST"];
	
	// define post boundary...
	NSString *boundary = [[NSProcessInfo processInfo] globallyUniqueString];
	NSString *boundaryString = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
	[request addValue:boundaryString forHTTPHeaderField:@"Content-Type"];
	
	// define boundary separator...
	NSString *boundarySeparator = [NSString stringWithFormat:@"--%@\r\n", boundary];
	
	//adding the body...
	NSMutableData *postBody = [NSMutableData data];
	
	// adding params...
	for (id key in requestData) {
		NSString *formDataName = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
		NSString *formDataValue = [NSString stringWithFormat:@"%@\r\n", [requestData objectForKey:key]];
		[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[formDataName dataUsingEncoding:NSUTF8StringEncoding]];
		[postBody appendData:[formDataValue dataUsingEncoding:NSUTF8StringEncoding]];
	}
	// if file is defined, upload it...
	[postBody appendData:[boundarySeparator dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"audioBody\"; filename=\"%@\"\r\n", fileName] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:[@"Content-Type: application/octet-stream\r\n\r\n"
                              dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:fileData];
	
	[postBody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r \n",boundary]
                          dataUsingEncoding:NSUTF8StringEncoding]];
	[request setHTTPBody:postBody];	

	 m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

#pragma mark - Web delegate

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace 
{
	NSString* authMethod = [protectionSpace authenticationMethod];
	
	if(authMethod == NSURLAuthenticationMethodHTTPDigest) {
		return YES;
	}
	
	return NO;
}



- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	
	if([challenge previousFailureCount] > 0){
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
    
    NSString *user = _user;
    NSString *pass = _password;
    
    NSURLCredential *creds = [NSURLCredential credentialWithUser:user password:pass persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:creds forAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
	httpResponse = (NSHTTPURLResponse*)response;   
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
    requestHandler(nil,nil,error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	requestHandler(responseData,httpResponse,nil);    
}

+(NSString*)formatURLWith:(NSString*)baseUrl andParams:(NSDictionary*)params {
    NSString* finalUrl = [baseUrl copy];
    
    if([params count] == 0) return finalUrl;
    
    finalUrl = [finalUrl stringByAppendingString:@"?"];
    
    for(NSString* paramName in [params allKeys]) {
        NSString* paramValue = @"";
        id paramValueObj = [params valueForKey:paramName];
        if([paramValueObj isKindOfClass:[NSString class]]) {
            paramValue = [(NSString*)paramValueObj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }

        if([paramValueObj isKindOfClass:[NSNumber class]]) {
            paramValue = [(NSNumber*)paramValueObj stringValue];
        }
        
        finalUrl = [finalUrl stringByAppendingFormat:@"%@=%@&",paramName,paramValue];
    }
    
    finalUrl = [finalUrl stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"&"]];

    return finalUrl;
}

@end