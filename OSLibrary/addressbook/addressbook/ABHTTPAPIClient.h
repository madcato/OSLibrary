//
//  ABHTTPAPIClient.h
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//
//
// Sample implementation

#import <Foundation/Foundation.h>


@interface ABHTTPAPIClient : AFHTTPClient <HTTPAPIClient>

+ (ABHTTPAPIClient *)sharedClient;

@end
