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
    database = [OSDatabase initWithModelName:@"OSDatabaseTest" storeName:@"OSDatabaseTest" testing:YES];
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
    STAssertNotNil(object, @"OSDatabase doesn't find Person object");
}

-(void)testFetchArray {
    [self createPepe1];
    [self createPepe2];
    [database save];
    NSArray* result = [database getResultsFrom:@"Person"
                                     sortArray:nil
                                 withPredicate:@"programmer = NO"
                                  andArguments:nil];

    STAssertTrue([result count] == 2, @"OSDatabase ha fallado al devolver dos objetos de la consulta");
}


-(void)testDeleteObject {
    [self createPepe1];
    [self createPepe2];

    [database deleteObjects:@"Person" withPredicate:@"name = 'pepe1'" andArguments:nil];
    NSArray* result = [database getResultsFrom:@"Person"
                                     sortArray:nil
                                 withPredicate:@"programmer = NO"
                                  andArguments:nil];
    
    STAssertTrue([result count] == 1, @"OSDatabase ha fallado al devolver el objeto que queda.");
}

- (id)createPepe1 {
    id object = [database insertObject:@"Person" values:@{@"name": @"pepe1",
                 @"programmer": @NO,
                 @"height": @1.3f}];
    STAssertNotNil(object, @"OSDatabase doesn't create Person object");
    return object;
}

- (id)createPepe2 {
    id object = [database insertObject:@"Person" values:@{@"name": @"pepe2",
                 @"programmer": @NO,
                 @"height": @1.3f}];
    STAssertNotNil(object, @"OSDatabase doesn't create Person object");
    return object;
}

@end
