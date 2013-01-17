//
//  OSWebRequestAuth.h
//  OSLibrary
//
//  Created by Daniel Vela on 14/12/12.
//
//

#import "OSWebRequest.h"

@interface OSWebRequestAuth : OSWebRequest {
    NSString* _user;
    NSString* _password;
}

-(id)initWithCredentials:(NSString*)user withPassword:(NSString*)password;

@end
