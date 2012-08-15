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
+(OSDatabase*)initWith:(NSManagedObjectContext *)managedObjectContext
    objectModel:(NSManagedObjectModel *)managedObjectModel
       andStore:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+(OSDatabase*)defaultDatabase;
+(OSDatabase*)backgroundDatabase;
- (NSManagedObject*)insertObject:(NSString*)entityName values:(NSDictionary*)values;
- (NSManagedObject*)getObject:(NSString*)entityName withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments;
- (NSArray*)getFetchedResults:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments;
- (NSFetchedResultsController*)getFetchedResultsController:(NSString*)entityName sortArray:(NSArray*)sortArray withPredicate:(NSString*)predicateText andArguments:(NSArray*)arguments andSectionNameKeyPath:(NSString*)keyPath;
- (NSManagedObjectContext*)getNewObjectContext;
-(void)save;
-(void)deleteObjects:(NSString*)entityName withPredicate:(NSString*)format andArguments:(NSArray*)arguments;
-(NSManagedObject*)objectWithID:(NSManagedObjectID*)objectID;
@property (atomic, strong) NSManagedObjectContext *managedObjectContext;
@property (atomic, strong) NSManagedObjectModel *managedObjectModel;
@property (atomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end
