//
//  AppDelegate.m
//  addressbook
//
//  Created by Daniel Vela on 6/12/13.
//  Copyright (c) 2013 Daniel Vela. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"
#import "Person.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [OSDatabase initWith:self.managedObjectContext
//             objectModel:self.managedObjectModel
//                andStore:self.persistentStoreCoordinator];
    [OSDatabase initWithModelName:@"addressbook" storeName:@"addressbook" testing:NO delegate:nil];
    [[OSCloudKitSyncEngine sharedEngine] registerNSManagedObjectClassToSync:[Person class]];

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[OSCloudKitSyncEngine sharedEngine] startSync];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [[OSDatabase defaultDatabase] save];
}


@end
