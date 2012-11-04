//
//  OSNetwork.m
//  OSLibrary
//
//  Created by Daniel Vela on 14/02/12.
//  Copyright (c) 2012 veladan. All rights reserved.
//

#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#import "OSNetwork.h"

@interface OSNetwork ()
-(void)networkChanged;
@end

@implementation OSNetwork

- (void) dealloc
{
	[self stopNotifier];
	if(reachabilityRef!= NULL)
	{
		CFRelease(reachabilityRef);
	}
}

static void ReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info)
{
#pragma unused (target, flags)
	NSCAssert(info != NULL, @"info was NULL in ReachabilityCallback");
	NSCAssert([(__bridge NSObject*) info isKindOfClass: [OSNetwork class]], @"info was wrong class in ReachabilityCallback");
    
	//We're on the main RunLoop, so an NSAutoreleasePool is not necessary, but is added defensively
	// in case someon uses the Reachablity object in a different thread.
    @autoreleasepool {
        OSNetwork* noteObject = (__bridge OSNetwork*) info;
        // Post a notification to notify the client that the network reachability changed.
        [noteObject networkChanged];
    }
}

-(void)networkChanged {
    [delegate networkStatusChanged:self];
}


+ (OSNetwork*) reachabilityWithHostName: (NSString*) hostName andDelegate:(id<OSNetworkDelegate>) dele
{
    
    
	OSNetwork* retVal = NULL;
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, [hostName UTF8String]);
	if(reachability!= NULL)
	{
		retVal= [[self alloc] init];
		if(retVal!= NULL)
		{
			retVal->reachabilityRef = reachability;
            retVal->delegate = dele;
        }
	}
	return retVal;
}

+ (OSNetwork*) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress andDelegate:(id<OSNetworkDelegate>) dele
{
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)hostAddress);
	OSNetwork* retVal = NULL;
	if(reachability!= NULL)
	{
		retVal= [[self alloc] init] ;
		if(retVal!= NULL)
		{
			retVal->reachabilityRef = reachability;
			retVal->localWiFiRef = NO;
            retVal->delegate = dele;
		}
	}
	return retVal;
}

+ (OSNetwork*) reachabilityForInternetConnectionWithDelegate:(id<OSNetworkDelegate>) dele
{
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	return [self reachabilityWithAddress: &zeroAddress andDelegate:dele];
}

+ (OSNetwork*) reachabilityForLocalWiFiWithDelegate:(id<OSNetworkDelegate>) dele
{
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
	OSNetwork* retVal = [self reachabilityWithAddress: &localWifiAddress andDelegate:dele];
	if(retVal!= NULL)
	{
		retVal->localWiFiRef = YES;
	}
	return retVal;
}

- (BOOL) startNotifier
{
	BOOL retVal = NO;
	SCNetworkReachabilityContext	context = {0,(__bridge void*) self, NULL, NULL, NULL};
	if(SCNetworkReachabilitySetCallback(reachabilityRef, ReachabilityCallback, &context))
	{
		if(SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode))
		{
			retVal = YES;
		}
	}
	return retVal;
}

- (void) stopNotifier
{
	if(reachabilityRef!= NULL)
	{
		SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	}
}


#pragma mark Status funcs

- (BOOL) isNetworkReachable 
{
    NSAssert(reachabilityRef != NULL, @"currentNetworkStatus called with NULL reachabilityRef");
	
	SCNetworkReachabilityFlags flags;
    if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags))
    {
        BOOL isReachable = flags & kSCNetworkFlagsReachable;
        BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
        return (isReachable && !needsConnection) ? YES : NO;
    }
    
    return NO;
}

@end
