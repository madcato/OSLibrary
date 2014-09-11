//
//  OSSystemTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 11/09/14.
//
//

#import <XCTest/XCTest.h>
#import "OSSystem.h"
@interface OSSystemTest : XCTestCase

@end

@implementation OSSystemTest

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUniqueIdentifier
{
    NSString* str = [OSSystem getOrCreateAppUniqueIdentifier];
    XCTAssertNotNil(str, @"[OSSystem getOrCreateAppUniqueIdentifier] has failed to create a UUID");

    NSString* str2 = [OSSystem getOrCreateAppUniqueIdentifier];
    XCTAssertNotNil(str, @"[OSSystem getOrCreateAppUniqueIdentifier] has failed to access stored UUID");

    XCTAssert([str isEqualToString:str2], @"[OSSystem getOrCreateAppUniqueIdentifier] has failed to access to create or store UUID");
}

@end
