//
//  OSDatabase.m
//  OSLibrary
//
//  Created by Daniel Vela on 13/08/12.
//
//

#import "OSDatabase.h"

@interface OSDatabase()
 @property (nonatomic ,strong)OSDatabase* backgroundDatabase;
@end

@implementation OSDatabase

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;

+(OSDatabase*)defaultDatabase {
    static OSDatabase* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[OSDatabase alloc] init];
    });
    return instance;
}

+(OSDatabase*)backgroundDatabase {
    static OSDatabase* database = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        database = [[OSDatabase alloc] init];
        OSDatabase* instance = [OSDatabase defaultDatabase];
        instance.backgroundDatabase = instance;
        database.persistentStoreCoordinator = [instance persistentStoreCoordinator];
        database.managedObjectModel = [instance managedObjectModel];
        database.managedObjectContext = [instance createObjectContextForPrivateThread];
    });
    return database;
}

+(OSDatabase*)initWithModelName:(NSString *)modelName
                      storeName:(NSString*)storeName
                        testing:(BOOL)testing
                       delegate:(id<OSDatabaseDelegate>) dele {
    static OSDatabase* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [OSDatabase defaultDatabase];
        instance.modelName = modelName;
        instance.unittesting = testing;
        instance.storeName = storeName;
        instance.delegate = dele;
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
        [OSDatabase displayValidationError:error];
    }
}

- (NSManagedObject*)insertObject:(NSString*)entityName values:(NSDictionary*)values {
    // Insert new object
    NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.managedObjectContext];
    assert(managedObject != nil);
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    NSArray* keyArray = [values allKeys];
    for(NSString* key in keyArray) {
        [managedObject setValue:[values valueForKey:key] forKey:key];
    }
    return managedObject;
}

- (NSManagedObject*)selectObject:(NSString*)entityName withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments {
    NSArray* array = [self getResultsFrom:entityName sortArray:nil withPredicate:predicateText andArguments:arguments];
    assert([array count] <= 1);
    if([array count] == 0) return nil;
    return array[0];
}

- (NSArray*)getResultsFrom:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments {
    assert(self.managedObjectContext != nil);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    assert(entity != nil);
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    // Edit the sort key as appropriate.
    NSMutableArray *sortDescriptors;
    sortDescriptors = [self sortDesciptors:sortArray];
    [fetchRequest setSortDescriptors:sortDescriptors];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateText argumentArray:arguments];
    assert(predicate != nil);
    [fetchRequest setPredicate:predicate];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSError* error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [OSDatabase displayValidationError:error];
    }
    return fetchedObjects;
}

- (NSMutableArray *)sortDesciptors:(NSArray *)sortArray {
    // Edit the sort key as appropriate.
    NSMutableArray *sortDescriptors = [NSMutableArray array];
    for(id element in sortArray) {
        if ([element isKindOfClass:[NSString class]]) {
            NSString* sortName = (NSString *)element;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:sortName
                                                ascending:YES];
            [sortDescriptors addObject:sortDescriptor];
        } else if ([element isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)element;
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                initWithKey:dict[@"sort"]
                                                ascending:[dict[@"ascending"] boolValue]];
            [sortDescriptors addObject:sortDescriptor];
        }
    }
    return sortDescriptors;
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
    NSMutableArray *sortDescriptors;
    sortDescriptors = [self sortDesciptors:sortArray];
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
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [OSDatabase displayValidationError:error];
    }    
    return aFetchedResultsController;
}

- (id)calculate:(NSString*)entityName
  withPredicate:(NSString*)predicateText
      arguments:(NSArray*)arguments
        keyPath:(NSString*)keyPath
       function:(NSString*)function
           type:(NSAttributeType)type {
    assert(self.managedObjectContext != nil);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    assert(entity != nil);
    [fetchRequest setEntity:entity];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:predicateText
                                                argumentArray:arguments];
    assert(predicate != nil);
    [fetchRequest setPredicate:predicate];

    // Specify that the request should return dictionaries.
    [fetchRequest setResultType:NSManagedObjectResultType];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:keyPath];
    
    // Create an expression to represent the minimum value at the key path 'creationDate'
    NSExpression *minExpression = [NSExpression expressionForFunction:function arguments:@[keyPathExpression]];
    
    // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"result"];
    [expressionDescription setExpression:minExpression];
    [expressionDescription setExpressionResultType:type];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSError *error = nil;
    NSArray *objects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (objects == nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [OSDatabase displayValidationError:error];
    }
    else {

        if ([objects count] > 0) {
            return [[objects objectAtIndex:0] valueForKey:@"result"];
        } 
    }
    return nil;
}

- (NSManagedObjectContext*)createObjectContextForMainThread {
    NSManagedObjectContext* newManagedObjectContext = nil;
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        newManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [newManagedObjectContext performBlockAndWait:^{
            [newManagedObjectContext setPersistentStoreCoordinator:coordinator];
        }];

    }
    newManagedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    assert(newManagedObjectContext != nil);
    self.managedObjectContext = newManagedObjectContext;
    return newManagedObjectContext;
}

- (NSManagedObjectContext*)createObjectContextForPrivateThread {
    NSManagedObjectContext* newManagedObjectContext = nil;
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if (coordinator != nil) {
        newManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [newManagedObjectContext performBlockAndWait:^{
            [newManagedObjectContext setPersistentStoreCoordinator:coordinator];
        }];
        
    }
    newManagedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    assert(newManagedObjectContext != nil);
    self.managedObjectContext = newManagedObjectContext;
    return newManagedObjectContext;
}


-(void)deleteObjects:(NSString*)entityName withPredicate:(NSString*)format andArguments:(NSArray*)arguments {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:self.managedObjectContext];
    assert(entity != nil);
    [fetchRequest setEntity:entity];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:format argumentArray:arguments];
    assert(predicate != nil);
    [fetchRequest setPredicate:predicate];

    NSError* error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [OSDatabase displayValidationError:error];
    }

    for(NSManagedObject* toDelAccount in fetchedObjects) {
        [self.managedObjectContext deleteObject:toDelAccount];
    }
}

-(NSManagedObject*)objectWithID:(NSManagedObjectID*)objectID {
  return [self.managedObjectContext objectWithID:objectID];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    _managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *modelURL = [bundle URLForResource:self.modelName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",self.storeName]];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *optionsDictionary =
    [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                forKey:NSMigratePersistentStoresAutomaticallyOption];
    
    if(self.unittesting == NO){
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.

         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.


         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.

         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]

         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}

         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.

         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [OSDatabase displayValidationError:error];
    }
    } else {
        
        // Unit testing: store in memory
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:optionsDictionary error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
             
             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
             
             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
             
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            [OSDatabase displayValidationError:error];
        }
    }

    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    NSURL *url;
    url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return url;
}

- (void)resetDatabaseFile {
    NSPersistentStore* store = [[_persistentStoreCoordinator persistentStores] lastObject];
    
    NSError *error = nil;
    NSURL *storeURL = store.URL;
    
    // release context and model
    _managedObjectModel = nil;
    _managedObjectContext = nil;
    
    [_persistentStoreCoordinator removePersistentStore:store error:nil];
    
    _persistentStoreCoordinator = nil;
    
    if (self.unittesting == NO) {
        [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
        if (error) {
            NSLog(@"filemanager error %@", error);
        }
    }
    // recreate the stack
    _managedObjectContext = [self managedObjectContext];
    
}

- (void)deleteAllEntities:(NSString *)nameEntity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [self.managedObjectContext deleteObject:object];
    }
    
    error = nil;
    [self.managedObjectContext save:&error];
}

+ (void)displayValidationError:(NSError *)anError {
    [[[OSDatabase defaultDatabase] delegate] displayError:anError];
}
    
+ (void)displayValidationErrorSample:(NSError *)anError {
    if (anError && [[anError domain] isEqualToString:@"NSCocoaErrorDomain"]) {
        NSArray *errors = nil;
        
        // multiple errors?
        if ([anError code] == NSValidationMultipleErrorsError) {
            errors = [anError userInfo][NSDetailedErrorsKey];
        } else {
            errors = @[anError];
        }
        
        if (errors && [errors count] > 0) {
            NSString *messages = @"Reason(s):\n";
            
            for (NSError * error in errors) {
                NSString *entityName = [[[error userInfo][@"NSValidationErrorObject"] entity] name];
                NSString *attributeName = [error userInfo][@"NSValidationErrorKey"];
                NSString *msg;
                switch ([error code]) {
                    case NSManagedObjectValidationError:
                        msg = @"Generic validation error.";
                        break;
                    case NSValidationMissingMandatoryPropertyError:
                        msg = [NSString stringWithFormat:@"The attribute '%@' mustn't be empty.", attributeName];
                        break;
                    case NSValidationRelationshipLacksMinimumCountError:
                        msg = [NSString stringWithFormat:@"The relationship '%@' doesn't have enough entries.", attributeName];
                        break;
                    case NSValidationRelationshipExceedsMaximumCountError:
                        msg = [NSString stringWithFormat:@"The relationship '%@' has too many entries.", attributeName];
                        break;
                    case NSValidationRelationshipDeniedDeleteError:
                        msg = [NSString stringWithFormat:@"To delete, the relationship '%@' must be empty.", attributeName];
                        break;
                    case NSValidationNumberTooLargeError:
                        msg = [NSString stringWithFormat:@"The number of the attribute '%@' is too large.", attributeName];
                        break;
                    case NSValidationNumberTooSmallError:
                        msg = [NSString stringWithFormat:@"The number of the attribute '%@' is too small.", attributeName];
                        break;
                    case NSValidationDateTooLateError:
                        msg = [NSString stringWithFormat:@"The date of the attribute '%@' is too late.", attributeName];
                        break;
                    case NSValidationDateTooSoonError:
                        msg = [NSString stringWithFormat:@"The date of the attribute '%@' is too soon.", attributeName];
                        break;
                    case NSValidationInvalidDateError:
                        msg = [NSString stringWithFormat:@"The date of the attribute '%@' is invalid.", attributeName];
                        break;
                    case NSValidationStringTooLongError:
                        msg = [NSString stringWithFormat:@"The text of the attribute '%@' is too long.", attributeName];
                        break;
                    case NSValidationStringTooShortError:
                        msg = [NSString stringWithFormat:@"The text of the attribute '%@' is too short.", attributeName];
                        break;
                    case NSValidationStringPatternMatchingError:
                        msg = [NSString stringWithFormat:@"The text of the attribute '%@' doesn't match the required pattern.", attributeName];
                        break;
                    default:
                        msg = [NSString stringWithFormat:@"Unknown error (code %li).", (long)[error code]];
                        break;
                }
                
                messages = [messages stringByAppendingFormat:@"%@%@%@\n", (entityName?:@""),(entityName?@": ":@""),msg];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation Error"
                                                            message:messages
                                                           delegate:nil
                                                  cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}

@end
