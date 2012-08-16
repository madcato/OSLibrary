//
//  OSTwitterOperation.m
//  OSLibrary
//
//  Created by Daniel Vela on 16/08/12.
//
//

#import "OSTwitterOperation.h"

@implementation OSTwitterOperation

-(id)initWithUrl:(NSString*)url params:(NSDictionary*)params account:(NSString*)accountID withCompletionBlock:(OSRequestHandler)block {
    self = [super init];
    if (self) {
        twitterUrl = url;
        twitterParams = params;
        twitterAccountID = accountID;
        twitterBlock = block;
    }
    return self;
}

- (void)main {
    @try {
        // Do the main work of the operation here.
        ACAccountStore* store = [[ACAccountStore alloc]init];
        [store requestAccessToAccountsWithType:[store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter] withCompletionHandler:
         ^(BOOL granted, NSError* error){
             if (!granted) {
                 // The user rejected your request
                 NSLog(@"User rejected access to the account.");
                 [super completeOperation];
             } else {
                 ACAccount* account = [store accountWithIdentifier:twitterAccountID];
                 TWRequest* request = [[TWRequest alloc] initWithURL:[NSURL URLWithString:twitterUrl] parameters:twitterParams requestMethod:TWRequestMethodGET];
                 request.account = account;
                 [request performRequestWithHandler:^(NSData* responseData, NSHTTPURLResponse* urlResponse, NSError* error) {
                    twitterBlock(responseData,urlResponse,error);
                     [super completeOperation];
                 }];
             }
        }];
    }
    @catch(NSException* exception) {
        // Do not rethrow exceptions.
        NSLog(@"Exception captured: %@, reason: %@",[exception name], [exception reason]);
    }
}
@end
