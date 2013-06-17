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
    database = [OSDatabase initWithModelName:@"OSDatabaseTest" testing:YES];
}

-(void)tearDown
{
//    [database resetDatabaseFile];
}

-(void)testCreation {
    id object = [database insertObject:@"Person" values:@{@"name": @"pepe",
                                             @"programmer": @NO,
                                             @"height": @1.3f}];
    STAssertNotNil(object, @"OSDatabase doesn't create Person object");
    
    [database save];
}

-(void)testLoadObject {
    id object = [database selectObject:@"Person" withPredicate:@"name = 'pepe'" andArguments:nil];
    STAssertNotNil(object, @"OSDatabase doesn't find Person object");
}


@end
