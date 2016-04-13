//
//  PersonAPIClientMock.h
//  OSLibrary
//
//  Created by Daniel Vela on 13/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPAPIClient.h"
#import "OSHTTPClient.h"

@interface PersonAPIClientMock : OSHTTPClient<HTTPAPIClient>

+ (PersonAPIClientMock *)sharedClient;

@property (nonatomic, strong) NSError* testError;
@property (nonatomic, strong) NSData* testResponseObject;

@end
