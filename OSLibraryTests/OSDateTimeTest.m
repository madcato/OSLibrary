//
//  OSDateTimeTest.m
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OSDateTimeTest.h"
#import "OSDateTime.h"

@implementation OSDateTimeTest

#if USE_APPLICATION_UNIT_TEST     // all code under test is in the iPhone Application

- (void)testAppDelegate {
    
    id yourApplicationDelegate = [[UIApplication sharedApplication] delegate];
    STAssertNotNil(yourApplicationDelegate, @"UIApplication failed to find the AppDelegate");
    
}

#else                           // all code under test must be linked into the Unit Test bundle

- (void)testMath {
    
    STAssertTrue((1+1)==2, @"Compiler isn't feeling well today :-(" );
    
}

- (void)testNotNil {
    NSLog(@"DateTime now: %@", [OSDateTime now]);
    STAssertNotNil([OSDateTime now], @"[OSDateTime now] no ha devuelto nada");
}

#endif

@end
