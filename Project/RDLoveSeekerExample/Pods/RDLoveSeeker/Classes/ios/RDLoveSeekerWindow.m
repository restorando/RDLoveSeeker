//
//  RDLoveSeekerWindow.m
//  RDLoveSeeker
//
//  Created by Lucas Vidal on 2/18/14.
//  Copyright (c) 2014 Restorando. All rights reserved.
//

#import "RDLoveSeekerWindow.h"

@implementation RDLoveSeekerWindow
@synthesize oldWindow;

- (instancetype)init {
    if ((self = [super initWithFrame:[[UIScreen mainScreen] bounds]])) {
        self.windowLevel = UIWindowLevelStatusBar;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIWindow *) oldWindow {
    if (oldWindow == nil) {
        if ([[[UIApplication sharedApplication] windows] count]) {
            self.oldWindow = [[UIApplication sharedApplication] windows][0];
        }
        else {
            self.oldWindow = nil;
        }
    }
    
    RDLSLog(@"Old Window: %@", oldWindow);
    
    return oldWindow;
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    [super setRootViewController:rootViewController];
    
    [self orientRootViewControllerForOrientation:rootViewController.interfaceOrientation];
}

- (void)orientRootViewControllerForOrientation:(UIInterfaceOrientation)interfaceOrientation {
    CGAffineTransform transform;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(-M_PI_2);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(M_PI);
            break;
        default:
        case UIInterfaceOrientationPortrait:
            transform = CGAffineTransformIdentity;
            break;
    }
    
    self.rootViewController.view.transform = transform;
}


@end
