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

/*!
 @class OSNetwork
 @abstract Checks the network availability
 @namespace OSLibrary
 @updated 2011-07-30
 */
@interface OSNetwork : NSObject {
    
    SCNetworkReachabilityRef reachabilityRef;
    
    id<OSNetworkDelegate> delegate;
    
    BOOL localWiFiRef;
}

/*!
 @method reachabilityWithHostName:andDelegate
 @param hostName The name of the host to check. Example: "www.apple.com"
 @param delegate Delegate object that will receive the notifications. Must implement OSNetworkDelegate protocol.
 @abstract Check if there is connection againts a host.
 @discussion Use this method to check if a host is reachable. This call doesn't start the notifications. Call startNotifier.
 @return The created OSNetwork.
 */
+ (OSNetwork*) reachabilityWithHostName: (NSString*) hostName andDelegate:(id<OSNetworkDelegate>) dele;

/*!
 @method reachabilityForInternetConnectionWithDelegate
 @param delegate Delegate object that will receive the notifications. Must implement OSNetworkDelegate protocol.
 @abstract Check if there is connection againts internet.
 @discussion Use this method to check if there is internet connectivity. This call doesn't start the notifications. Call startNotifier.
 @return The created OSNetwork.
 */
+ (OSNetwork*) reachabilityForInternetConnectionWithDelegate:(id<OSNetworkDelegate>) dele;

/*!
 @method reachabilityForLocalWiFiWithDelegate
 @param delegate Delegate object that will receive the notifications. Must implement OSNetworkDelegate protocol.
 @abstract Check if the wifi is connected.
 @discussion Use this method to check if the wifi is on and connected to a wifi network. This call doesn't start the notifications. Call startNotifier.
 @return The created OSNetwork.
 */
+ (OSNetwork*) reachabilityForLocalWiFiWithDelegate:(id<OSNetworkDelegate>) dele;

/*!
 @method startNotifier
 @abstract Starts the notifications.
 @discussion Call this method to start the check. Every time a change is detected in the network status, a notification will be send to de delegate object.
 @return YES if the procces can be started, otherwise return NO.
 */
- (BOOL) startNotifier;

/*!
 @method stopNotifier
 @abstract Stops the notifications.
 @discussion Call this method to stop the checks.
 */
- (void) stopNotifier;

/*!
 @method isNetworkReachable
 @abstract Call this method to check the network reachability status.
 @discussion This method works differently depending of wich method is called to initialize: reachabilityWithHostName,  reachabilityForInternetConnectionWithDelegate, reachabilityForLocalWiFiWithDelegate.
 @return YES if the network is reachable.
 */
- (BOOL)isNetworkReachable;

@end
