//
//  OSCoreDataCloudKitSyncEngine.h
//  OSLibrary
//
//  Created by Daniel Vela on 13/02/15.
//
//

#import "OSCoreDataSyncEngine.h"

@interface OSCoreDataCloudKitSyncEngine : OSCoreDataSyncEngine

@property (atomic, readonly) BOOL syncInProgress;

@end
