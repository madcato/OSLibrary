//
//  OSWebRequest.m
//  OSLibrary
//
//  Created by Dani Vela on 8/8/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSWebRequest.h"

@implementation OSWebRequest

@synthesize m_connection;
@synthesize silent = _silent;
@synthesize headers;
@synthesize responseData;
@synthesize statusCode = _statusCode;


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        
        encoding = NSUTF8StringEncoding;
        _silent = NO;
        _statusCode = 0;
    }
    
    return self;
}

-(void) useEncoding:(NSStringEncoding)enc {
    encoding = enc;
}

-(void)download:(NSString*)url withDelegate:(id<OSWebRequestDelegate>)delegate;
{
	NSString *scaped_url = [url stringByAddingPercentEscapesUsingEncoding:encoding];
    //NSLog(@"Escaped URL %@",scaped_url);	
	receiver = delegate;
	
	self.responseData = [NSMutableData data];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:scaped_url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
 	m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)dealloc {
    [self cancelRequest];
    [super dealloc];
}
-(void)cancelRequest {
	[m_connection cancel];
}


-(void)postData:(NSString*)data toURL:(NSString*)u withDelegate:(id<OSWebRequestDelegate>)delegate {
    
    receiver = delegate;
    
    
    
    NSURL *url = [[NSURL alloc] initWithString:u];
    
    self.responseData = [NSMutableData data];
    
    
    
    
    
    NSData* buffer;
    buffer = [data dataUsingEncoding:encoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:buffer];
    
    [request setValue:[NSString stringWithFormat:@"%d", [buffer length]] forHTTPHeaderField:@"Content-Length"];
    
    
    m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

-(void)postJson:(NSString*)data toURL:(NSString*)u withDelegate:(id<OSWebRequestDelegate>)delegate {
    
    receiver = delegate;
    
    
    
    NSURL *url = [[NSURL alloc] initWithString:u];
    
    self.responseData = [NSMutableData data];
    
    
    
    
    
    NSData* buffer;
    buffer = [data dataUsingEncoding:encoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:buffer];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [buffer length]] forHTTPHeaderField:@"Content-Length"];
    
    
    m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

-(void)putJson:(NSString*)data toURL:(NSString*)u withDelegate:(id<OSWebRequestDelegate>)delegate {
    
    receiver = delegate;

    NSURL *url = [[NSURL alloc] initWithString:u];
    
    self.responseData = [NSMutableData data];

    NSData* buffer;
    buffer = [data dataUsingEncoding:encoding];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:buffer];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setValue:[NSString stringWithFormat:@"%d", [buffer length]] forHTTPHeaderField:@"Content-Length"];
    
    
    m_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self] ;
}

- (void)postFile:(NSData*)fileData withName:(NSString*)fileName withParams:(NSDictionary *)requestData toURL:(NSString*)u withDelegate:(id<OSWebRequestDelegate>)delegate
{
    receiver = delegate;
    self.responseData = [NSMutableData data];
    
	NSURL *theURL = [NSURL URLWithString:u];
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

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	NSString* authMethod = [protectionSpace authenticationMethod];
	
	if(authMethod == NSURLAuthenticationMethodHTTPDigest) {
		return YES;
	}
	
	return NO;
}

-(void)useCredentials:(NSString*)user withPassword:(NSString*)password {
    _user = user;
    _password = password;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
	if([challenge previousFailureCount] > 0){
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
    
    NSString *user = _user;
    NSString *pass = _password;
    
	
    NSURLCredential *creds = [NSURLCredential credentialWithUser:user password:pass persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:creds forAuthenticationChallenge:challenge];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    

    [self.responseData setLength:0];
	NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
	if ([response respondsToSelector:@selector(allHeaderFields)]) {
		self.headers = [httpResponse allHeaderFields];
		
	}
    
    _statusCode = httpResponse.statusCode;
    
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//	signText.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
	errorDescription = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
	[self handleError:error];
	
	[receiver requestDidFinishWithError:error];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:encoding];
    
	
    if(receiver != nil) {
        if([(id)receiver respondsToSelector:@selector(requestDidFinishWithString:)]) {
            [receiver requestDidFinishWithString:responseString];
        } else {
            [receiver requestDidFinishWithData:responseData];
        }
        
    }
    
    responseString = nil;
	self.responseData = nil;
    // if responseString == nil check the encoding of the response it can be UT8 instead Latin1.
    //NSLog(@"Response:%@--",responseString );
    
    
}


// -------------------------------------------------------------------------------
//	handleError:error
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error
{
    
    if(!_silent) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSString *errorMessage = [error localizedDescription];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Web"
                                                             message:errorMessage
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [alertView show];
    }
}

@end
