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
  OSDatabase* instance = [OSDatabase initWith:nil
                  objectModel:nil
                     andStore:nil];
  database.persistentStoreCoordinator = [instance persistentStoreCoordinator];
  database.managedObjectContext = [instance managedObjectContext];
  database.managedObjectModel = [instance managedObjectModel];
  return database;
}

+(OSDatabase*)backgroundDatabase {
  OSDatabase* database = [[OSDatabase alloc] init];
  OSDatabase* instance = [OSDatabase initWith:nil
                  objectModel:nil
                     andStore:nil];
  database.persistentStoreCoordinator = [instance persistentStoreCoordinator];
  database.managedObjectModel = [instance managedObjectModel];
  database.managedObjectContext = [instance createObjectContext];
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
    // abort() causes the application to generate a crash log and terminate.
    // You should not use this function in a shipping application,
    // although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
}

- (NSManagedObject*)insertObject:(NSString*)entityName
              values:(NSDictionary*)values {
  // Insert new object
  NSManagedObject *managedObject = [NSEntityDescription
                    insertNewObjectForEntityForName:entityName
                inManagedObjectContext:self.managedObjectContext];
  assert(managedObject != nil);
  // If appropriate, configure the new managed object.
  // Normally you should use accessor methods,
  //but using KVC here avoids the need to add a custom class to the template.
  NSArray* keyArray = [values allKeys];
  for(NSString* key in keyArray) {
    [managedObject setValue:[values valueForKey:key] forKey:key];
  }
  return managedObject;
}

- (NSManagedObject*)selectObject:(NSString*)entityName
           withPredicate:(NSString*)predicateText
          andArguments:(NSArray*)arguments {
  NSArray* array = [self getResultsFrom:entityName
                sortArray:nil
              withPredicate:predicateText
               andArguments:arguments];
  assert([array count] <= 1);
  if([array count] == 0) return nil;
  return array[0];
}

- (NSArray*)getResultsFrom:(NSString*)entityName
         sortArray:(NSArray*)sortArray
       withPredicate:(NSString*)predicateText
        andArguments:(NSArray*)arguments {
  assert(self.managedObjectContext != nil);
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate.
  NSEntityDescription *entity = [NSEntityDescription
                   entityForName:entityName
              inManagedObjectContext:self.managedObjectContext];
  assert(entity != nil);
  [fetchRequest setEntity:entity];
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  // Edit the sort key as appropriate.
  if(sortArray) {
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    for(NSString* sortName in sortArray) {
      NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                        initWithKey:sortName
                          ascending:YES];
      [sortDescriptors addObject:sortDescriptor];
    }
    [fetchRequest setSortDescriptors:sortDescriptors];
  }
  NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateText
                        argumentArray:arguments];
  assert(predicate != nil);
  [fetchRequest setPredicate:predicate];
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSError* error = nil;
  NSArray *fetchedObjects = [self.managedObjectContext
                 executeFetchRequest:fetchRequest
                       error:&error];
  if (error != nil) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return fetchedObjects;
}

- (NSFetchedResultsController*)
createFetchedResultsController:(NSString*)entityName
           sortArray:(NSArray*)sortArray
         withPredicate:(NSString*)predicateText
          andArguments:(NSArray*)arguments
     andSectionNameKeyPath:(NSString*)keyPath {
  assert(self.managedObjectContext != nil);
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate.
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
              inManagedObjectContext:self.managedObjectContext];
  assert(entity != nil);
  [fetchRequest setEntity:entity];
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  // Edit the sort key as appropriate.
  NSMutableArray *sortDescriptors = [NSMutableArray array];
  for(NSString* sortName in sortArray) {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                      initWithKey:sortName
                        ascending:YES];
    [sortDescriptors addObject:sortDescriptor];
  }
  [fetchRequest setSortDescriptors:sortDescriptors];
  NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateText
                        argumentArray:arguments];
  assert(predicate != nil);
  [fetchRequest setPredicate:predicate];
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController =
  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                managedObjectContext:self.managedObjectContext
                  sectionNameKeyPath:keyPath
                       cacheName:@"MasterList"];
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate.
    // You should not use this function in a shipping application,
    // although it may be useful during development.
	  NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}  
  return aFetchedResultsController;
}

- (NSManagedObjectContext*)createObjectContext {
  NSManagedObjectContext* newManagedObjectContext = nil;
  NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
  if (coordinator != nil) {
    newManagedObjectContext = [[NSManagedObjectContext alloc] init];
    [newManagedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  assert(newManagedObjectContext != nil);
  self.managedObjectContext = newManagedObjectContext;
  return newManagedObjectContext;
}

-(void)deleteObjects:(NSString*)entityName
     withPredicate:(NSString*)format
    andArguments:(NSArray*)arguments {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
              inManagedObjectContext:self.managedObjectContext];
  assert(entity != nil);
  [fetchRequest setEntity:entity];
  NSPredicate* predicate = [NSPredicate predicateWithFormat:format
                        argumentArray:arguments];
  assert(predicate != nil);
  [fetchRequest setPredicate:predicate];
  NSError* error = nil;
  NSArray *fetchedObjects = [self.managedObjectContext
                 executeFetchRequest:fetchRequest
                       error:&error];
  if (fetchedObjects == nil) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  for(NSManagedObject* toDelAccount in fetchedObjects) {
    [self.managedObjectContext deleteObject:toDelAccount];
  }
}

-(NSManagedObject*)objectWithID:(NSManagedObjectID*)objectID {
  return [self.managedObjectContext objectWithID:objectID];
}

@end
