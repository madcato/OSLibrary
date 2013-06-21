//
//  OSDatabase.h
//  OSLibrary
//
//  Created by Daniel Vela on 13/08/12.
//
//

#import <Foundation/Foundation.h>

@interface OSDatabase : NSObject

/** 
 Call this method in the applicationDidFinishLaunching
*/
+(OSDatabase*)initWithModelName:(NSString *)modelName testing:(BOOL)testing;
+(OSDatabase*)defaultDatabase;
+(OSDatabase*)backgroundDatabase;
- (NSManagedObject*)insertObject:(NSString*)entityName values:(NSDictionary*)values;
- (NSManagedObject*)selectObject:(NSString*)entityName withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments;
- (NSArray*)getResultsFrom:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments;
- (NSFetchedResultsController*)createFetchedResultsController:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments andSectionNameKeyPath:(NSString*)keyPath;
- (NSManagedObjectContext*)createObjectContextForMainThread;
- (NSManagedObjectContext*)createObjectContextForPrivateThread;
- (void)save;
- (void)deleteObjects:(NSString*)entityName withPredicate:(NSString*)format andArguments:(NSArray*)arguments;
- (NSManagedObject*)objectWithID:(NSManagedObjectID*)objectID;
- (void)resetDatabaseFile;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong)  NSString *modelName;
@property (nonatomic, assign)  BOOL unittesting;
@end
