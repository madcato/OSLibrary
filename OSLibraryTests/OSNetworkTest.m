//
//  OSNetworkTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 14/02/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

#import "OSNetworkTest.h"

@implementation OSNetworkTest

-(void)networkStatusChanged:(OSNetwork*)net {
  
  XCTAssertTrue([net isNetworkReachable] == NO, @"Network must not be reachable");
  
}

// All code under test must be linked into the Unit Test bundle
- (void)testMath
{
  XCTAssertTrue((1 + 1) == 2, @"Compiler isn't feeling well today :-(");
}

-(void)testNetworkNotReachable
{
  network = [OSNetwork reachabilityWithHostName:@"www.aafasfasfasfasfpple.com" andDelegate:self];
  [network startNotifier];
  
  //  [NSThread sleepForTimeInterval:5];
}

@end
