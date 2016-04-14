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
#import "NSManagedObject+JSON.h"

@interface OSCoreDataSyncEngine () {
    
}
- (void)downloadDataForRegisteredObjects:(BOOL)useUpdatedAtDate toDeleteLocalRecords:(BOOL)toDelete;
- (void)postLocalObjectsToServer:(BOOL)putUpdates;

@end
    
@interface OSCoreDataSyncEngineTest : XCTestCase {
    OSDatabase* database;
    OSDatabase* backgroundDatabase;
    PersonAPIClientMock* apiClient;
    OSCoreDataSyncEngine* engine;
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
    
    engine = [[OSCoreDataSyncEngine alloc] init];
    [engine registerNSManagedObjectClassToSync:[Person class]];
    apiClient = [PersonAPIClientMock sharedClient];
    [engine registerHTTPAPIClient:apiClient];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [database deleteAllEntities:@"Person"];
    [backgroundDatabase deleteAllEntities:@"Person"];
    
    [super tearDown];    
}

- (void)testDownloadObjects {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSUInteger __block count = 0;
    XCTestExpectation* expectation = [self expectationWithDescription:@"download obejcts"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        apiClient.testError = nil;
        apiClient.testResponseObject = [self loadFile:@"getAllObjects" extension:@"json"];
        backgroundDatabase = [OSDatabase backgroundDatabase];
        [engine setBackgroundDatabase:backgroundDatabase];
        [engine downloadDataForRegisteredObjects:YES toDeleteLocalRecords:NO];
        
        [NSThread sleepForTimeInterval:1];
        
        count = [backgroundDatabase count:@"Person"];
        
        [expectation fulfill];
        
        
    });

    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        
    }];
    
    XCTAssertEqual(count,2, @"OSSyncEngine ha fallado al devolver dos objetos de la consulta");
}

- (void)testDeleteObjects {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSUInteger __block count = 0;
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"download obejcts"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        apiClient.testError = nil;
        apiClient.testResponseObject = [self loadFile:@"getEmptyList" extension:@"json"];
        backgroundDatabase = [OSDatabase backgroundDatabase];
        [engine setBackgroundDatabase:backgroundDatabase];
        
        // Create an object to Delete
        [self createPepe1];
        count = [backgroundDatabase count:@"Person"];
        XCTAssertEqual(count,1, @"Test ha fallado al crear objeto");

        
        
        [engine downloadDataForRegisteredObjects:NO toDeleteLocalRecords:YES];
        
        [NSThread sleepForTimeInterval:1];
        
        count = [backgroundDatabase count:@"Person"];
        
        [expectation fulfill];
        
        
    });
    
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        
    }];
    
    XCTAssertEqual(count,0, @"OSSyncEngine ha fallado al borrar los objetos");
}

- (void)testPostObjects {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSUInteger __block count = 0;
    
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"download obejcts"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        backgroundDatabase = [OSDatabase backgroundDatabase];
        [engine setBackgroundDatabase:backgroundDatabase];
        
        // Create an object to Delete
        [self createPepe2];
        [self createPepe3];
        count = [backgroundDatabase count:@"Person"];
        XCTAssertEqual(count,2, @"Test ha fallado al crear objetos");
        
        apiClient.testError = nil;
        apiClient.testResponseObject = nil;
        
        
        
        [engine postLocalObjectsToServer:NO];
        
        [NSThread sleepForTimeInterval:1];
        
        count = [backgroundDatabase count:@"Person"];
        
        [expectation fulfill];
        
        
    });
    
    
    [self waitForExpectationsWithTimeout:3 handler:^(NSError * _Nullable error) {
        
    }];
    
    XCTAssertEqual(count,2, @"OSSyncEngine ha fallado al borrar los objetos");
}

- (id)createPepe1 {
    id object = [backgroundDatabase insertObject:@"Person" values:@{@"name": @"pepe1",
                                                          @"programmer": @NO,
                                                          @"height": @1.3f,
                                                          @"salary": @500,
                                                          @"updated_at": [NSDate date],
                                                          @"created_at": [NSDate date],
                                                          @"syncStatus": @(OSObjectSynced),
                                                          @"objectId": @"0"}];
    XCTAssertNotNil(object, @"OSDatabase doesn't create Person object");
    return object;
}

- (id)createPepe2 {
    id object = [backgroundDatabase insertObject:@"Person" values:@{@"name": @"pepe2",
                                                                    @"programmer": @NO,
                                                                    @"height": @1.3f,
                                                                    @"salary": @500,
                                                                    @"updated_at": [NSDate date],
                                                                    @"created_at": [NSDate date],
                                                                    @"syncStatus": @(OSObjectCreated),
                                                                    @"objectId": @"0"}];
    XCTAssertNotNil(object, @"OSDatabase doesn't create Person object");
    return object;
}

- (id)createPepe3 {
    id object = [backgroundDatabase insertObject:@"Person" values:@{@"name": @"pepe3",
                                                                    @"programmer": @NO,
                                                                    @"height": @1.3f,
                                                                    @"salary": @500,
                                                                    @"updated_at": [NSDate date],
                                                                    @"created_at": [NSDate date],
                                                                    @"syncStatus": @(OSObjectCreated),
                                                                    @"objectId": @"0"}];
    XCTAssertNotNil(object, @"OSDatabase doesn't create Person object");
    return object;
}

- (NSData*)loadFile:(NSString*)file extension:(NSString*)ext {
    NSURL *imgPath = [[NSBundle bundleForClass:[self class]] URLForResource:file withExtension:ext];
    NSString*stringPath = [imgPath absoluteString];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringPath]];
    return data;
}

@end
