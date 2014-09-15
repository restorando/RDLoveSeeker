//
//  RDLoveSeekerStatusController.m
//  RDLoveSeeker
//
//  Created by Lucas Vidal on 2/20/14.
//  Copyright (c) 2014 Restorando. All rights reserved.
//

#import "RDLoveSeekerStatusController.h"
#import "RDLoveSeekerViewController.h"
#import "RDLoveSeeker.h"

#define kSignificantEvents @"love_seeker_significant_events"
#define kInstallDate @"love_seeker_install_date"
#define kHasBeenShown @"love_seeker_has_been_shown"
#define kLastVersionRequested @"love_seeker_last_version_requested"

static RDLoveSeekerStatusController *_sharedInstance;

@interface RDLoveSeekerStatusController()

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) RDLoveSeekerViewController *loveSeekerVC;

@end

@implementation RDLoveSeekerStatusController

+ (RDLoveSeekerStatusController *) sharedInstance
{
    if (!_sharedInstance)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _sharedInstance = [[RDLoveSeekerStatusController alloc] init];
        });
    }

    return _sharedInstance;
}
- (void) setHasBeenShown: (BOOL) b
{
    if (b) [self setCurrentVersionAsLast];

    [[NSUserDefaults standardUserDefaults] setBool: b forKey:kHasBeenShown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL) hasBeenShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey: kHasBeenShown];
}

- (void) setInstallDate
{
    NSDate *date = [NSDate date];
    RDLSLog(@"Storing install date: %@", [date description]);
    [[NSUserDefaults standardUserDefaults] setValue: date forKey: kInstallDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *) currentBuildVersion
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    return [info objectForKey:@"CFBundleShortVersionString"];
}

- (void) setCurrentVersionAsLast
{
    RDLSLog(@"setting %@ as last version used", [self currentBuildVersion]);
    [[NSUserDefaults standardUserDefaults] setObject: [self currentBuildVersion] forKey:kLastVersionRequested];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) resetAllCounters
{
    [self setHasBeenShown: NO];
    [self setInstallDate];
    [self setCurrentVersionAsLast];
    [[NSUserDefaults standardUserDefaults] setInteger: 0 forKey: kSignificantEvents];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) requestUserRating
{
    if (!self.loveSeekerVC) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            RDLSLog(@"Requesting user rating.");
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            
            weakSelf.loveSeekerVC = [[RDLoveSeekerViewController alloc] init];
            
            [window.rootViewController addChildViewController: weakSelf.loveSeekerVC];
            [window.rootViewController.view addSubview: weakSelf.loveSeekerVC.view];
        });
    }
    else {
        RDLSLog(@"Dialog already shown");
    }
}

- (void) dismissAndRestoreApp
{
    [self.loveSeekerVC removeFromParentViewController];
    [self.loveSeekerVC.view removeFromSuperview];
    self.loveSeekerVC = nil;
}

- (NSString *) lastVersionUsed
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kLastVersionRequested];
}

- (NSDate *) installDate
{
    return [[NSUserDefaults standardUserDefaults] objectForKey: kInstallDate];
}

- (void) logSignificantEvent
{
    NSInteger events = [[NSUserDefaults standardUserDefaults] integerForKey: kSignificantEvents];
    [[NSUserDefaults standardUserDefaults] setInteger: ++events forKey: kSignificantEvents];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [RDLoveSeeker verifyIfNeedsToBeShown];
}

- (NSInteger) significantEvents
{
    return [[NSUserDefaults standardUserDefaults] integerForKey: kSignificantEvents];
}
@end
