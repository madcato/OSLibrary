//
//  OSMockRequestOperation.h
//  OSLibrary
//
//  Created by Daniel Vela on 13/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import "OSHTTPRequestOperation.h"

@interface OSMockRequestOperation : OSHTTPRequestOperation

@property (nonatomic, strong) NSError* testError;
@property (nonatomic, strong) NSData* testResponseObject;

@end
