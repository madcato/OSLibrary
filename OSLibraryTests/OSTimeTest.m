//
//  OSTimeTest.m
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSTimeTest.h"
#import "OSTime.h"

@implementation OSTimeTest

#if USE_APPLICATION_UNIT_TEST   // all code under test is in the iPhone Application

- (void)testAppDelegate {
  
  id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
  STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
  
}

#else               // all code under test must be linked into the Unit Test bundle

- (void)testMath {
  
  XCTAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
  
}

- (void)testNotNil {
  NSLog(@"Time now: %@", [OSTime now]);
  XCTAssertNotNil([OSTime now], @"[OSTime now] no ha devuelto nada");
}

#endif

@end
