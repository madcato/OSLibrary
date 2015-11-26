//
//  OSDateTimeTest.m
//  OSLibrary
//
//  Created by Dani Vela on 7/30/11.
//  Copyright 2011 veladan. All rights reserved.
//

#import "OSDateTimeTest.h"
#import "OSDateTime.h"

@implementation OSDateTimeTest

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
  XCTAssertNotNil([OSDateTime now], @"[OSDateTime now] no ha devuelto nada");
}

-(void)testFormatFromDateToString {
  NSString* str = @"1976-04-22T12:46:22.000+0000";
  NSDate* date = [OSDateTime dateFromString:str];
  XCTAssertNotNil(date, @"[OSDateTime dateFromString] doesn't return anything");
  XCTAssertTrue([[date description] isEqualToString:@"1976-04-22 12:46:22 +0000"], @"[OSDateTime dateFromString] failed");
}

-(void)testFormatFromStringToDate {
  NSDate* date = [[NSDate alloc] initWithTimeIntervalSince1970:21022002];
  NSString* str = [OSDateTime stringFromDate:date];
  XCTAssertNotNil(str, @"[OSDateTime stringFromDate] doesn't return anything");
  XCTAssertTrue([str isEqualToString:@"1970-09-01T07:26:42.000+0000"], @"[OSDateTime stringFromDate] failed");
}

#endif

@end
