//
//  OSTopBarActivityIndicatorManagerTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 01/04/16.
//  Copyright © 2016 veladan. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OSTopBarActivityIndicator.h"
#import "OSTopBarActivityIndicatorManager.h"

@interface OSInspectableTopBarAcivityIndicator : OSTopBarActivityIndicator {
    
}

@property (nonatomic, assign) NSUInteger startCalled;
@property (nonatomic, assign) NSUInteger stopCalled;

@end

@implementation OSInspectableTopBarAcivityIndicator

- (void)startActivity {
    _startCalled += 1;
}

- (void)stopActivity {
    _stopCalled += 1;
}

@end

@interface OSTopBarActivityIndicatorManagerTest : XCTestCase

@property (nonatomic, strong) OSInspectableTopBarAcivityIndicator* activity;
@property (nonatomic, strong) OSTopBarActivityIndicatorManager* manager;

@end

@implementation OSTopBarActivityIndicatorManagerTest

- (void)setUp {
    [super setUp];
   
    _activity = [OSInspectableTopBarAcivityIndicator new];
    _manager = [[OSTopBarActivityIndicatorManager alloc] initWithActivityIndicator:_activity];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testActivitySequence1 {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    
    XCTAssertEqual(_activity.startCalled, 1);
    XCTAssertEqual(_activity.stopCalled, 0);
    
}

- (void)testActivitySequence2 {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    
    XCTAssertEqual(_activity.startCalled, 5);
    XCTAssertEqual(_activity.stopCalled, 5);
    
}

- (void)testActivitySequence3 {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager startActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    
    [OSTopBarActivityIndicatorManager stopActivity];
    [OSTopBarActivityIndicatorManager stopActivity];
    
    [OSTopBarActivityIndicatorManager startActivity];
    
    XCTAssertEqual(_activity.startCalled, 2);
    XCTAssertEqual(_activity.stopCalled, 1);
    
}

@end
