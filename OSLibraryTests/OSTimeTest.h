//
//  OSTimeTest.h
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 veladan. All rights reserved.
//
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

//  Application unit tests contain unit test code that must be injected into an application to run correctly.
//  Define USE_APPLICATION_UNIT_TEST to 0 if the unit test code is designed to be linked into an independent test executable.

#define USE_APPLICATION_UNIT_TEST 0

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
//#import "application_headers" as required

@interface OSTimeTest : XCTestCase

#if USE_APPLICATION_UNIT_TEST
- (void)testAppDelegate;     // simple test on application
#else
- (void)testMath;        // simple standalone test
- (void)testNotNil;
#endif

@end
