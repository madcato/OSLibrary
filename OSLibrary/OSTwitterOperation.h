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
    TWRequest* twitterRequest;
}

-(id)initWithRequest:(TWRequest*)request withCompletionBlock:(OSRequestHandler)block;
@end
