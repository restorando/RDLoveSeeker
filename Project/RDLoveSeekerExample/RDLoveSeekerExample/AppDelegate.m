//
//  AppDelegate.m
//  RDLoveSeekerExample
//
//  Created by Lucas Vidal on 9/12/14.
//  Copyright (c) 2014 Restorando. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initLoveSeeker];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [RDLoveSeeker logSignificantEvent]; //log opening as significant event;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void) initLoveSeeker
{
    [RDLoveSeeker setDebug: YES];
    [RDLoveSeeker setEventsToRequestRating:5];
    [RDLoveSeeker setFeedbackEmailAddress:@"example@support.com"];

    [RDLoveSeeker setDelegate: self];
    [RDLoveSeeker setDaysToRequestRating: 5];
    [RDLoveSeeker setShouldRequestOnNewVersion: NO];
    [RDLoveSeeker setAppStoreID: 529290320];
}

#pragma mark RDLoveSeekerDelegate

- (void)loveSeekerDidReceiveAnswer:(LoveSeekerAnswerEvent)event
{
    NSLog(@"Love Seeker returned from popup with result code %d", event);
}

@end
