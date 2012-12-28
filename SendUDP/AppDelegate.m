//
//  AppDelegate.m
//  SendUDP
//
//  Created by Thomas Mohaupt on 25.12.12.
//  Copyright (c) 2012 Thomas Mohaupt. All rights reserved.
//

#import "AppDelegate.h"
#import "SendUdpViewController.h"

@implementation AppDelegate

static NSString *PREFERENCE_RECEIVER_IPADDRESS = @"receiver_ip";
static NSString *PREFERENCE_RECEIVER_PORT = @"receiver_port";

- (void)loadPreferences{
    NSLog(@"loadPreferences");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [self.configuration setIpAddress:[defaults stringForKey:PREFERENCE_RECEIVER_IPADDRESS]];
    [self.configuration setPort:[defaults stringForKey:PREFERENCE_RECEIVER_PORT]];
}

- (void)savePreferences{
    NSLog(@"savePreferences");
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[self.configuration ipAddress] forKey:PREFERENCE_RECEIVER_IPADDRESS];
    [defaults setValue:[self.configuration port] forKey:PREFERENCE_RECEIVER_PORT];
}

#pragma mark -
#pragma mark standard application interface

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self setConfiguration:[Configuration alloc]];
    [self loadPreferences];
    
    UINavigationController* navController = (UINavigationController*)  self.window.rootViewController;
    SendUdpViewController* mainController = (SendUdpViewController*)  navController.topViewController;
    [mainController setConfiguration:self.configuration];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self savePreferences];
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
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self setConfiguration:nil];
}

@end
