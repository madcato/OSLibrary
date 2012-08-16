//
//  OSTwitterOperation.h
//  OSLibrary
//
//  Created by Daniel Vela on 16/08/12.
//
//

#import "OSOperation.h"

@interface OSTwitterOperation : OSOperation {
    OSRequestHandler twitterBlock;
    NSString* twitterUrl;
    NSDictionary* twitterParams;
    NSString* twitterAccountID;
}

-(id)initWithUrl:(NSString*)url params:(NSDictionary*)params account:(NSString*)accountID withCompletionBlock:(OSRequestHandler)block;
@end
