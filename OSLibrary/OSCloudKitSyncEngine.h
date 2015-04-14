//
//  OSCloudKitSyncEngine.h
//  OSLibrary
//
//  Created by Daniel Vela on 13/02/15.
//
//



NSString * const kOSCloudSyncEngineSyncCompletedNotificationName;
NSString * const kOSCloudKitSyncEngineInitialCompleteKey;

@interface OSCloudKitSyncEngine : NSObject

+ (OSCloudKitSyncEngine *)sharedEngine;
-(void)fetchUserInfo;
- (void)registerNSManagedObjectClassToSync:(Class)aClass;
- (void)startSync:(id)observer selector:(SEL)selector;
- (NSString *)dateStringForAPIUsingDate:(NSDate *)date;
    
@end
