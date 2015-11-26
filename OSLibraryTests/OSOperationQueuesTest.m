//
//  OSOperationQueuesTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 19/11/12.
//
//

#import "OSOperationQueuesTest.h"

@implementation OSOperationQueuesTest

-(void)setUp
{
  operationQueues = [OSOperationQueues defaultQueues];
}

-(void)tearDown
{
  operationQueues = nil;
}

-(void)testExceptionInCreation
{
  [operationQueues createOperationQueueNamed:@"Prueba1" withMaxConcurrentOpeartionCount:1];
  
  XCTAssertThrows([operationQueues createOperationQueueNamed:@"Prueba1" withMaxConcurrentOpeartionCount:1]
           , @"The same operation queue can not be created twice");
}


-(void)testExceptionInOperation
{
  [operationQueues createOperationQueueNamed:@"Prueba2" withMaxConcurrentOpeartionCount:1];
  
  XCTAssertThrows([operationQueues addOperation:[[NSOperation alloc] init] toQueueNamed:@"Prueba3"]
           , @"The operations should not be queued in an inexistent queue");
}

@end
