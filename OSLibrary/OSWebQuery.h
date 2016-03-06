//
//  OSWebQuery.h
//  OSLibrary
//
//  Created by Daniel Vela on 02/08/15.
//  Copyright (c) 2015 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSWebInterface.h"
#import "OSDataParser.h"

// Callback method for the queries
// param id is a NSDictionary with the results of the parse operation
// 
typedef void(^OSWebQueryHandler)(id result, NSError *error);

@interface OSWebQuery : NSObject

- (instancetype)initWithInterface:(OSWebInterface*)interface
                       dataParser:(OSDataParser*)dataParser;

- (void)resume:(OSWebQueryHandler)handler;

@property (nonatomic, strong) OSWebInterface* interface;
@property (nonatomic, strong) OSDataParser* dataParser;

@end
