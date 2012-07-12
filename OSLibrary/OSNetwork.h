//
//  OSNetwork.h
//  OSLibrary
//
//  Created by Daniel Vela on 14/02/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSNetwork;

@protocol OSNetworkDelegate <NSObject>

-(void)networkStatusChanged:(OSNetwork*)network;

@end
@interface OSNetwork : NSObject {
    
    SCNetworkReachabilityRef reachabilityRef;
    
    id<OSNetworkDelegate> delegate;
    
    BOOL localWiFiRef;
}

+ (OSNetwork*) reachabilityWithHostName: (NSString*) hostName andDelegate:(id<OSNetworkDelegate>) dele;
+ (OSNetwork*) reachabilityForInternetConnectionWithDelegate:(id<OSNetworkDelegate>) dele;
+ (OSNetwork*) reachabilityForLocalWiFiWithDelegate:(id<OSNetworkDelegate>) dele;

- (BOOL) startNotifier;
- (void) stopNotifier;

- (void)networkChanged;

- (BOOL) isNetworkReachable;

@end
