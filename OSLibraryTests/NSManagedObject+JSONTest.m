//
//  NSManagedObject+JSONTest.m
//  OSLibrary
//
//  Created by Daniel Vela on 27/02/13.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSManagedObject+JSON.h"

@interface NSManagedObject_JSONTest : SenTestCase

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation NSManagedObject_JSONTest

- (void)testToJSON {
  NSDate *now = [NSDate date];
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  NSEntityDescription *entityDescription =
  [NSEntityDescription entityForName:@"DataToTest"
              inManagedObjectContext:managedObjectContext];
  NSManagedObject *object = [[NSManagedObject alloc]
                             initWithEntity:entityDescription
                             insertIntoManagedObjectContext:
                             managedObjectContext];
  [object setValue:@"55" forKey:@"adios"];
  [object setValue:@(3) forKey:@"hola"];
  [object setValue:now forKey:@"pepe"];
  [object setValue:@(2.3f) forKey:@"cosa"];
  [object setValue:@(3.4f) forKey:@"cosa2"];
  [object setValue:@(YES) forKey:@"tren"];

  NSDictionary *dict = @{@"hola": @(3),
                         @"adios": @"55",
                         @"pepe": [object stringFromDate:now],
                         @"cosa": @(2.3f),
                         @"cosa2": @(3.4f),
                         @"tren": @(YES)
                         };
  NSMutableDictionary * jsonDict = [object toJSON];
  STAssertTrue([dict isEqualToDictionary:jsonDict], @"toJSON failing");
}

- (void)testInitWithDictionary {
  NSDate *now = [NSDate date];
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  NSEntityDescription *entityDescription =
  [NSEntityDescription entityForName:@"DataToTest"
              inManagedObjectContext:managedObjectContext];
  NSManagedObject *object = [[NSManagedObject alloc]
                             initWithEntity:entityDescription
                             insertIntoManagedObjectContext:
                             managedObjectContext];
  [object setValue:@"55" forKey:@"adios"];
  [object setValue:@(3) forKey:@"hola"];
  [object setValue:[object dateFromString:[object stringFromDate:now]] forKey:@"pepe"];
  [object setValue:@(2.3f) forKey:@"cosa"];
  [object setValue:@(3.4f) forKey:@"cosa2"];
  [object setValue:@(YES) forKey:@"tren"];

  NSDictionary *dict = @{@"hola": @(3),
                         @"adios": @"55",
                         @"pepe": [object stringFromDate:now],
                         @"cosa": @(2.3f),
                         @"cosa2": @(3.4f),
                         @"tren": @(YES)
                         };

  NSManagedObject *newobject = [[NSManagedObject alloc]
                                initWithEntity:entityDescription
                                insertIntoManagedObjectContext:
                                managedObjectContext];
  newobject = [newobject initWithDictionary:dict];
  STAssertTrue([[newobject valueForKey:@"hola"] isEqual:
                [object valueForKey:@"hola"]]
               , @"initWithDictionary failing");
  STAssertTrue([[newobject valueForKey:@"adios"] isEqual:
                [object valueForKey:@"adios"]]
               , @"initWithDictionary failing");
  STAssertTrue([[newobject valueForKey:@"pepe"] isEqual:
                [object valueForKey:@"pepe"]]
               , @"initWithDictionary failing"); 
  STAssertTrue([[newobject valueForKey:@"cosa"] isEqual:
                [object valueForKey:@"cosa"]]
               , @"initWithDictionary failing");
  STAssertTrue([[newobject valueForKey:@"cosa2"] isEqual:
                [object valueForKey:@"cosa2"]]
               , @"initWithDictionary failing");
  STAssertTrue([[newobject valueForKey:@"tren"] isEqual:
                [object valueForKey:@"tren"]]
               , @"initWithDictionary failing");
}


- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
		NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc performBlockAndWait:^{
      [moc setPersistentStoreCoordinator: coordinator];
		}];
    _managedObjectContext = moc;
 		_managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
	}
  return _managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSURL *modelURL = [bundle URLForResource:@"OSLibraryTest" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

  // Returns the persistent store coordinator for the application.
  // If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator == nil) {
		_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
  }
  return _persistentStoreCoordinator;
}

@end
