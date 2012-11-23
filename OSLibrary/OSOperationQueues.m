//
//  OSOperationQueues.m
//  OSLibrary
//
//  Created by Daniel Vela on 16/08/12.
//
//

#import "OSOperationQueues.h"

@implementation OSOperationQueues

+(OSOperationQueues*)defaultQueues
{
    static dispatch_once_t onceToken;
    static OSOperationQueues* qu = nil;
    
    dispatch_once(&onceToken, ^{
        qu = [[OSOperationQueues alloc] init];
    });
    
    return qu;
}

-(void)createOperationQueueNamed:(const NSString*)queueName withMaxConcurrentOpeartionCount:(NSInteger)count
{
    if(queues == nil) {
        queues = [NSMutableDictionary dictionary];
    }
    
    id object = [queues objectForKey:queueName];
    
    if(object) {
        // Queue already exits, throw an exception to notify programmer.
        @throw [NSException exceptionWithName:@"OSOperationQueuesException" reason:[NSString stringWithFormat:@"Queue '%@' already exists.",queueName] userInfo:nil];
    
    }
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:count];
    [queues setObject:queue forKey:queueName];
}

-(void)addOperation:(NSOperation*)operation toQueueNamed:(const NSString*)queueName
{
    if(queues == nil) {
        @throw [NSException exceptionWithName:@"OSOperationQueuesException" reason:[NSString stringWithFormat:@"You must create a queue before calling this method."] userInfo:nil];
    }
    
    NSOperationQueue* object = [queues objectForKey:queueName];
    
    if(object == nil) {
        // Queue already exits, throw an exception to notify programmer.
        @throw [NSException exceptionWithName:@"OSOperationQueuesException" reason:[NSString stringWithFormat:@"Queue '%@' not exists.",queueName] userInfo:nil];
    }
    
    [object addOperation:operation];
}

@end
