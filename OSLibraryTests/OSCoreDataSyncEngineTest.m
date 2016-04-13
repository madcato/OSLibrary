//
//  OSCoreDataSyncEngineTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 13/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OSDatabase.h"
#import "OSCoreDataSyncEngine.h"
#import "Person.h"
#import "PersonAPIClientMock.h"

@interface OSCoreDataSyncEngine () {
    
}
- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate toDeleteLocalRecords:(BOOL)toDelete;

@end
    
@interface OSCoreDataSyncEngineTest : XCTestCase {
    OSDatabase* database;
    OSDatabase* backgroundDatabase;
    PersonAPIClientMock* apiClient;
}


@end

@implementation OSCoreDataSyncEngineTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    database = [OSDatabase initWithModelName:@"OSDatabaseTest"
                                   storeName:@"OSDatabaseTest"
                                     testing:YES
                                    delegate:nil];
    
    [[OSCoreDataSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Person class]];
    apiClient = [PersonAPIClientMock sharedClient];
    [[OSCoreDataSyncEngine sharedEngine] registerHTTPAPIClient:apiClient];

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [database resetDatabaseFile];
    
    [super tearDown];    
}

- (void)testDownloadObjects {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSUInteger __block count = 0;
    XCTestExpectation* expectation = [self expectationWithDescription:@"download obejcts"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        apiClient.testResponseObject = [self loadFile:@"getAllObjects" extension:@"json"];
        backgroundDatabase = [OSDatabase backgroundDatabase];
        [[OSCoreDataSyncEngine sharedEngine] setBackgroundDatabase:backgroundDatabase];
        [[OSCoreDataSyncEngine sharedEngine] downloadDataForRegisteredObjects:YES toDeleteLocalRecords:NO];
        
        [NSThread sleepForTimeInterval:1];
        
        count = [backgroundDatabase count:@"Person"];
        
        [expectation fulfill];
        
        
    });

    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        
    }];
    
    XCTAssertEqual(count,2, @"OSSyncEngine ha fallado al devolver dos objetos de la consulta");
}

- (NSData*)loadFile:(NSString*)file extension:(NSString*)ext {
    NSURL *imgPath = [[NSBundle bundleForClass:[self class]] URLForResource:file withExtension:ext];
    NSString*stringPath = [imgPath absoluteString];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringPath]];
    return data;
}

@end
