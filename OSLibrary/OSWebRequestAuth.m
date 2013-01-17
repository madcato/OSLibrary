//
//  OSWebRequestAuth.m
//  OSLibrary
//
//  Created by Daniel Vela on 14/12/12.
//
//

#import "OSWebRequestAuth.h"

@implementation OSWebRequestAuth


-(id)initWithCredentials:(NSString*)user withPassword:(NSString*)password
{
    self = [super init];
    if(self) {
        _user = user;
        _password = password;
    }
    
    return self;
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

@end
