//
//  OSWebInterfaceTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 08/03/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OSWebInterface.h"

@interface OSWebInterfaceTest : XCTestCase

@end

@implementation OSWebInterfaceTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()~";
//static NSString * const kAFCharactersToLeaveUnescaped = @"[].";

- (void)testScape1 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa[hola]" encoding:NSUTF8StringEncoding], @"ocupa[hola]",@"Falla el escape de []");
}

- (void)testScape2 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa=hola" encoding:NSUTF8StringEncoding], @"ocupa%3Dhola",@"Falla el escape de =");
}

- (void)testScape3 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa%%hola" encoding:NSUTF8StringEncoding], @"ocupa%25%25hola",@"Falla el escape de %%");
}

- (void)testScape4 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa/hola" encoding:NSUTF8StringEncoding], @"ocupa%2Fhola",@"Falla el escape de /");
}

- (void)testScape5 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa?hola" encoding:NSUTF8StringEncoding], @"ocupa%3Fhola",@"Falla el escape de ?");
}

- (void)testScape6 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa.hola" encoding:NSUTF8StringEncoding], @"ocupa.hola",@"Falla el escape de .");
}

- (void)testScape7 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa:hola" encoding:NSUTF8StringEncoding], @"ocupa%3Ahola",@"Falla el escape de :");
}

- (void)testScape8 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa&hola" encoding:NSUTF8StringEncoding], @"ocupa%26hola",@"Falla el escape de &");
}

- (void)testScape9 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa;hola" encoding:NSUTF8StringEncoding], @"ocupa%3Bhola",@"Falla el escape de ;");
}

- (void)testScape10 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa+hola" encoding:NSUTF8StringEncoding], @"ocupa%2Bhola",@"Falla el escape de +");
}

- (void)testScape11 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa!hola" encoding:NSUTF8StringEncoding], @"ocupa%21hola",@"Falla el escape de !");
}

- (void)testScape12 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa@hola" encoding:NSUTF8StringEncoding], @"ocupa%40hola",@"Falla el escape de @");
}

- (void)testScape13 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa#hola" encoding:NSUTF8StringEncoding], @"ocupa%23hola",@"Falla el escape de #");
}

- (void)testScape14 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa$hola" encoding:NSUTF8StringEncoding], @"ocupa%24hola",@"Falla el escape de $");
}

- (void)testScape15 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa(hola)" encoding:NSUTF8StringEncoding], @"ocupa%28hola%29",@"Falla el escape de ()");
}

- (void)testScape16 {
    XCTAssertEqualObjects([OSWebInterface percentScape:@"ocupa~hola" encoding:NSUTF8StringEncoding], @"ocupa%7Ehola",@"Falla el escape de ~");
}

- (void)testScape17 {
    XCTAssertEqualObjects([OSWebInterface URLqueryEscape:@":/?&=;+!@#$()~[]."], @":/?&=;+!@%23$()~%5B%5D.",@"Falla el escape de los parametros URL");
}


@end
