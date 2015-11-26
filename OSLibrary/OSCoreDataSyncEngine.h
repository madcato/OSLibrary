//
//  OSCoreDataSyncEngine.h
//  OSLibrary
//
//  Created by Daniel Vela on 6/12/13.
//
//
// Inspired in http://www.raywenderlich.com/15916/how-to-synchronize-core-data-with-a-web-service-part-1
// and http://www.raywenderlich.com/17927/how-to-synchronize-core-data-with-a-web-service-part-2
//
// And then add this to application:didFinishLaunchingWithOptions:
// - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions :(NSDictionary *)launchOptions
// {
//     [[OSCoreDataSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Holiday class]];
//     [[OSCoreDataSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Birthday class]];
//
//     return YES;
// }
//
//
// Then call startSync in applicationDidBecomeActive:
// - (void)applicationDidBecomeActive:(UIApplication *)application
// {
//     [[SDSyncEngine sharedEngine] startSync];
// }
//
//
// In the ViewController
//
// - (void)viewDidAppear:(BOOL)animated {
// [super viewDidAppear:animated];
//
// [[NSNotificationCenter defaultCenter] addObserverForName:kOSCoreDataSyncEngineSyncCompletedNotificationName object:nil queue:nil usingBlock:^(NSNotification *note) {
//    [self loadRecordsFromCoreData];
//    [self.tableView reloadData];
// }];
// }
//
// - (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kOSCoreDataSyncEngineSyncCompletedNotificationName object:nil];
// }

#import <Foundation/Foundation.h>
#import "HTTPAPIClient.h"

typedef enum {
    OSObjectSynced = 0,
    OSObjectCreated = 1,
    OSObjectDeleted = 2,
    OSObjectUpdated = 3
} OSObjectSyncStatus;

NSString * const kOSCoreDataSyncEngineInitialCompleteKey;
NSString * const kOSCoreDataSyncEngineSyncCompletedNotificationName;



@interface OSCoreDataSyncEngine : NSObject

+ (OSCoreDataSyncEngine *)sharedEngine;
- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)registerHTTPAPIClient:(id<HTTPAPIClient>)apiClient;
- (void)startSync;
- (NSString *)dateStringForAPIUsingDate:(NSDate *)date;
- (NSDate *)dateUsingStringFromAPI:(NSString *)dateString;
+ (void)deleteObject:(NSManagedObject*)object inContext:(NSManagedObjectContext *)context;
+ (void)updateObjectAndSave:(NSManagedObject*)object inContext:(NSManagedObjectContext *)context;
    
@property (atomic, readonly) BOOL syncInProgress;


- (NSDate *)mostRecentUpdatedAtDateForEntityWithName:(NSString *)entityName;
- (BOOL)initialSyncComplete;
- (NSArray *)JSONArrayForClassWithName:(NSString *)className;
- (NSArray *)JSONDataRecordsForClass:(NSString *)className sortedByKey:(NSString *)key;
- (NSArray *)managedObjectsForClass:(NSString *)className sortedByKey:(NSString *)key usingArrayOfIds:(NSArray *)idArray inArrayOfIds:(BOOL)inIds;
- (void)deleteJSONDataRecordsForClassWithName:(NSString *)className;
- (void)executeSyncCompletedOperations;
- (void)writeJSONResponse:(id)response toDiskForClassWithName:(NSString *)className;
- (NSArray *)managedObjectsForClass:(NSString *)className withSyncStatus:(OSObjectSyncStatus)syncStatus;
- (void)setInitialSyncCompleted;

@end


//
//- (IBAction)refreshButtonTouched:(id)sender {
//    [[SDSyncEngine sharedEngine] startSync];
//}
//
//- (void)checkSyncStatus {
//    if ([[SDSyncEngine sharedEngine] syncInProgress]) {
//        [self replaceRefreshButtonWithActivityIndicator];
//    } else {
//        [self removeActivityIndicatorFromRefreshButton];
//    }
//}
//
//- (void)replaceRefreshButtonWithActivityIndicator {
//    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//    [activityIndicator setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
//    [activityIndicator startAnimating];
//    UIBarButtonItem *activityItem = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
//    self.navigationItem.leftBarButtonItem = activityItem;
//}
//
//- (void)removeActivityIndicatorFromRefreshButton {
//    self.navigationItem.leftBarButtonItem = self.refreshButton;
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"syncInProgress"]) {
//        [self checkSyncStatus];
//    }
//}
//
// - (void)viewDidAppear:(BOOL)animated {
// [super viewDidAppear:animated];
// [self checkSyncStatus];
// [[SDSyncEngine sharedEngine] addObserver:self forKeyPath:@"syncInProgress" options:NSKeyValueObservingOptionNew context:nil];
// }

// - (void)viewDidDisappear:(BOOL)animated {
// [super viewDidDisappear:animated];
// [[SDSyncEngine sharedEngine] removeObserver:self forKeyPath:@"syncInProgress"];
// }
