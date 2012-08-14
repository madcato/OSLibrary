//
//  OSDatabase.m
//  OSLibrary
//
//  Created by Daniel Vela on 13/08/12.
//
//

#import "OSDatabase.h"



@implementation OSDatabase

+(OSDatabase*)defaultDatabase {
    OSDatabase* database = [[OSDatabase alloc] init];
    OSDatabase* instance = [OSDatabase initWith:nil objectModel:nil andStore:nil];
    database.persistentStoreCoordinator = [instance persistentStoreCoordinator];
    database.managedObjectContext = [instance managedObjectContext];
    database.managedObjectModel = [instance managedObjectModel];
    return database;
}

+(OSDatabase*)backgroundDatabase {
    OSDatabase* database = [[OSDatabase alloc] init];
    OSDatabase* instance = [OSDatabase initWith:nil objectModel:nil andStore:nil];
    database.persistentStoreCoordinator = [instance persistentStoreCoordinator];
    database.managedObjectModel = [instance managedObjectModel];
    database.managedObjectContext = [instance getNewObjectContext];
    return database;
}

+(OSDatabase*)initWith:(NSManagedObjectContext *)managedObjectContext
    objectModel:(NSManagedObjectModel *)managedObjectModel
       andStore:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    static OSDatabase* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OSDatabase alloc] init];
        [instance setManagedObjectContext:managedObjectContext];
        [instance setManagedObjectModel:managedObjectModel];
        [instance setPersistentStoreCoordinator:persistentStoreCoordinator];
    });
    return instance;
}

- (void)save {
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)insertObject:(NSString*)entityName values:(NSDictionary*)values {
    // Insert new object
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    NSArray* keyArray = [values allKeys];
    for(NSString* key in keyArray) {
        [managedObject setValue:[values valueForKey:key] forKey:key];
    }
    [self save];
}

- (NSManagedObject*)getObject:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText {
    NSArray* array = [self getFetchedResults:entityName sortArray:sortArray withPredicate:predicateText];
    assert([array count] > 1);
    if([array count] == 0) return nil;
    return [array objectAtIndex:0];
}

- (NSArray*)getFetchedResults:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText {
    assert(self.managedObjectContext != nil);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    // Edit the sort key as appropriate.
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    for(NSString* sortName in sortArray) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortName ascending:YES];
        [sortDescriptors addObject:sortDescriptor];
    }
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateText];
    [fetchRequest setPredicate:predicate];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSError* error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return fetchedObjects;
}

- (NSFetchedResultsController*)getFetchedResultsController:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText andSectionNameKeyPath:(NSString*)keyPath {
    assert(self.managedObjectContext != nil);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    // Edit the sort key as appropriate.
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    for(NSString* sortName in sortArray) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortName ascending:YES];
        [sortDescriptors addObject:sortDescriptor];
    }
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateText];
    [fetchRequest setPredicate:predicate];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:keyPath cacheName:@"MasterList"];
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}    
    return aFetchedResultsController;
}

- (NSManagedObjectContext*)getNewObjectContext {
    NSManagedObjectContext* newManagedObjectContext = nil;
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        newManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [newManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    assert(newManagedObjectContext != nil);
    return newManagedObjectContext;
}

@end
