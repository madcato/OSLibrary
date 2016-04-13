//
//  OSDatabaseTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 6/17/13.
//
//

#import "OSDatabaseTest.h"
#import "OSDatabase.h"

@interface OSDatabaseTest () {
    OSDatabase* database;
}

@end

@implementation OSDatabaseTest

-(void)setUp
{
    database = [OSDatabase initWithModelName:@"OSDatabaseTest"
                                   storeName:@"OSDatabaseTest"
                                     testing:YES
                                    delegate:nil];
}

-(void)tearDown
{
    [database resetDatabaseFile];
}

-(void)testCreation {
    [self createPepe1];
    [database save];
}

-(void)testLoadObject {
    [self createPepe1];
    id object = [database selectObject:@"Person"
                         withPredicate:@"name = 'pepe1'"
                          andArguments:nil];
    XCTAssertNotNil(object, @"OSDatabase doesn't find Person object");
}

-(void)testFetchArray {
    [self createPepe1];
    [self createPepe2];
    [database save];
    NSArray* result = [database getResultsFrom:@"Person"
                                     sortArray:nil
                                 withPredicate:@"programmer = NO"
                                  andArguments:nil];

    XCTAssertTrue([result count] == 2, @"OSDatabase ha fallado al devolver dos objetos de la consulta");
}


-(void)testDeleteObject {
    [self createPepe1];
    [self createPepe2];

    [database deleteObjects:@"Person" withPredicate:@"name = 'pepe1'" andArguments:nil];
    NSArray* result = [database getResultsFrom:@"Person"
                                     sortArray:nil
                                 withPredicate:@"programmer = NO"
                                  andArguments:nil];
    
    XCTAssertTrue([result count] == 1, @"OSDatabase ha fallado al devolver el objeto que queda.");
}

-(void)testCalculateSum {
    [self createPepe1];
    [self createPepe2];
    [self createPepe3];
    [database save];
//    NSNumber* result = [database calculate:@"Person"
//                             withPredicate:@"programmer = NO"
//                                 arguments:nil keyPath:@"salary"
//                                  function:@"sum:"
//                                      type:NSDecimalAttributeType];
//    NSLog(@"object: %@", result);
//    XCTAssertTrue([result isEqualToNumber:@2500], @"OSDatabase ha fallado al devolver dos objetos de la consulta");

// This test fail because a bug in Memory Core Data model and NSDictionaryResultType.
}

- (id)createPepe1 {
    id object = [database insertObject:@"Person" values:@{@"name": @"pepe1",
                 @"programmer": @NO,
                 @"height": @1.3f,
                 @"salary": @500}];
    XCTAssertNotNil(object, @"OSDatabase doesn't create Person object");
    return object;
}

- (id)createPepe2 {
    id object = [database insertObject:@"Person" values:@{@"name": @"pepe2",
                 @"programmer": @NO,
                 @"height": @1.3f,
                 @"salary": @500}];
    XCTAssertNotNil(object, @"OSDatabase doesn't create Person object");
    return object;
}

- (id)createPepe3 {
    id object = [database insertObject:@"Person" values:@{@"name": @"pepe3",
                                                          @"programmer": @NO,
                                                          @"height": @1.3f,
                                                          @"salary": @1500}];
    XCTAssertNotNil(object, @"OSDatabase doesn't create Person object");
    return object;
}


@end
