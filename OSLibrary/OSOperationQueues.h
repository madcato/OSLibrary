//
//  OSOperationQueues.h
//  OSLibrary
//
//  Created by Daniel Vela on 16/08/12.
//
//

#import <Foundation/Foundation.h>

@interface OSOperationQueues : NSObject {
  NSMutableDictionary* queues;
}

+(OSOperationQueues*)defaultQueues;

-(void)createOperationQueueNamed:(const NSString*)queueName
 withMaxConcurrentOpeartionCount:(NSInteger)count;

-(void)addOperation:(NSOperation*)operation
     toQueueNamed:(const NSString*)queueName;
@end
