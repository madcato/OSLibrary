//
//  addressbookTests.m
//  addressbookTests
//
//  Created by Daniel Vela on 6/12/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "addressbookTests.h"

@interface addressbookTests ()

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;

@end

@implementation addressbookTests

- (void)setUp
{
    [super setUp];

    self.managedObjectContext = [[OSDatabase defaultDatabase] managedObjectContext];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreateSomeObjects
{
    [self insertNewObject:nil];
    [self insertNewObject:nil];
    [self insertNewObject:nil];
    [[OSCoreDataSyncEngine sharedEngine] startSync];
    
    
}

- (NSManagedObject*)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = self.managedObjectContext;
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [newManagedObject setValue:[NSDate date] forKey:@"birthDate"];
    [newManagedObject setValue:@1.80f forKey:@"height"];
    [newManagedObject setValue:@"Dani Vela" forKey:@"name"];
    [newManagedObject setValue:@YES forKey:@"programmer"];
    [newManagedObject setValue:[NSData data] forKey:@"avatar"];
    [newManagedObject setValue:[NSNumber numberWithInt:OSObjectCreated] forKey:@"syncStatus"];
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return newManagedObject;
}

- (void)updateObject:(NSManagedObject*)object {
    
    if (object == nil) return;
    
    [object setValue:@"Star Wars" forKey:@"name"];
    [OSCoreDataSyncEngine updateObjectAndSave:object inContext:self.managedObjectContext];
}

@end
