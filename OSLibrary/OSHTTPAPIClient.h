//
//  OSHTTPAPIClient.h
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//
//
// Sample implementation

#import <Foundation/Foundation.h>
#import "HTTPAPIClient.h"

@interface OSHTTPAPIClient : AFHTTPClient <HTTPAPIClient>

- (NSMutableURLRequest *)POSTRequestForClass:(NSString *)className parameters:(NSDictionary *)parameters;

@end
