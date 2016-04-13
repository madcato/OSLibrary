//
//  OSDatabase.h
//  OSLibrary
//
//  Created by Daniel Vela on 13/08/12.
//
//
// http://www.objc.io/issue-10/icloud-core-data.html

#import <Foundation/Foundation.h>

@protocol OSDatabaseDelegate <NSObject>

- (void)displayError:(NSError*) error;

@end


// // In order to be notificated when the background is saved, use this code.
// //
// - (void)viewDidLoad {
//	[[NSNotificationCenter defaultCenter] addObserver:self
// selector:@selector(updateContext:)
// name:NSManagedObjectContextDidSaveNotification
// object:[[OSDatabase backgroundDatabase] managedObjectContext]];
// }
// 
// // this is called from mergeChanges: method,
// // requested to be made on the main thread so we can update our table with our new earthquake objects
// //
// - (void)updateContext:(NSNotification *)notification
// {
// NSManagedObjectContext *mainContext = [self.fetchedResultsController managedObjectContext];
// [mainContext mergeChangesFromContextDidSaveNotification:notification];
// }

// Call every single method or group o method of dis class inside a performBlock method
// Example:
// [[OSDatabase backgroundDatabase] performBlock:^{
//     // Stuff here
// }];



@interface OSDatabase : NSObject

/**
 Call this method in the applicationDidFinishLaunching
*/
+(OSDatabase*)initWithModelName:(NSString *)modelName
                      storeName:(NSString*)storeName
                        testing:(BOOL)testing
                       delegate:(id<OSDatabaseDelegate>) dele;
+(OSDatabase*)defaultDatabase;

+(OSDatabase*)backgroundDatabase;

- (void)performBlock:(void (^)(void))block;
- (void)performBlockAndWait:(void (^)(void))block;

- (NSManagedObject*)insertObject:(NSString*)entityName values:(NSDictionary*)values;
- (NSManagedObject*)selectObject:(NSString*)entityName withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments;
- (NSArray*)getResultsFrom:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments;
- (NSFetchedResultsController*)createFetchedResultsController:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments andSectionNameKeyPath:(NSString*)keyPath;
- (void)save;
- (void)deleteObjects:(NSString*)entityName withPredicate:(NSString*)format andArguments:(NSArray*)arguments;
- (NSManagedObject*)objectWithID:(NSManagedObjectID*)objectID;
- (void)resetDatabaseFile;
- (id)calculate:(NSString*)entityName
  withPredicate:(NSString*)predicateText
      arguments:(NSArray*)arguments
        keyPath:(NSString*)keyPath
       function:(NSString*)function
           type:(NSAttributeType)type;
- (NSUInteger)count:(NSString*)entityName;
- (void)deleteAllEntities:(NSString *)nameEntity;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong)  NSString *modelName;
@property (nonatomic, strong)  NSString *storeName;
@property (nonatomic, assign)  BOOL unittesting;
@property (nonatomic, assign)  id<OSDatabaseDelegate> delegate;

+ (void)displayValidationError:(NSError *)anError;

@end
