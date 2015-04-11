//
//  OSCloudKitRequestOperation.m
//  OSLibrary
//
//  Created by Daniel Vela on 11/04/15.
//
//

#import "OSCloudKitRequestOperation.h"

@interface OSCloudKitRequestOperation ()

@property (nonatomic,strong) CKDatabase* database;
@property (nonatomic,strong) CKQuery* query;
@property (nonatomic,strong) OSCKCompletionBlock completionOperation;

@end

@implementation OSCloudKitRequestOperation

+(OSCloudKitRequestOperation*)operationWithDatabase:(CKDatabase*)database query:(CKQuery*)query completionHandler:(OSCKCompletionBlock)completionOperation  {
    OSCloudKitRequestOperation* operation = [[OSCloudKitRequestOperation alloc] init];
    operation.database = database;
    operation.query = query;
    operation.completionOperation = completionOperation;
    return operation;
}

-(void)run {
    [self.database performQuery:self.query inZoneWithID:nil completionHandler:^(NSArray* results, NSError* error) {
        self.completionOperation(results,error);
        [self completeOperation];
    }];
}

- (void)main {
    @try {
        [self run];
    }
    @catch(...) {
        // Do not rethrow exceptions.
    }
}

@end
