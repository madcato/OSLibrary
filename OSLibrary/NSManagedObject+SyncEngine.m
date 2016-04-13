//
//  NSManagedObject+JSON.m
//  EasyTablet
//
//  Created by Daniel Vela on 17/04/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

#import "NSManagedObject+SyncEngine.h"
#import "OSCoreDataSyncEngine.h"

@implementation NSManagedObject (SyncEngine)

- (void)deleteObject {
    [OSCoreDataSyncEngine deleteObject:self inContext:self.managedObjectContext];
}

- (void)updateObjectAndSave {
    [OSCoreDataSyncEngine updateObjectAndSave:self inContext:self.managedObjectContext];
}

@end
