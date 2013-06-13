//
//  NSManagedObject+JSON.m
//  EasyTablet
//
//  Created by Daniel Vela on 17/04/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

#import "NSManagedObject+JSON.h"
#import "NSData+Base64.h"
#import "OSCoreDataSyncEngine.h"

@implementation NSManagedObject (JSON)

- (NSDictionary *)JSONToCreateObjectOnServer {
    @throw [NSException exceptionWithName:@"JSONStringToCreateObjectOnServer Not Overridden" reason:@"Must override JSONStringToCreateObjectOnServer on NSManagedObject class" userInfo:nil];
    return nil;
}


@end
