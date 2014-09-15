//
//  RDLoveSeekerStatusController.h
//  RDLoveSeeker
//
//  Created by Lucas Vidal on 2/20/14.
//  Copyright (c) 2014 Restorando. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RDLoveSeekerStatusController : NSObject

+ (RDLoveSeekerStatusController *) sharedInstance;

- (void) dismissAndRestoreApp;

- (void) resetAllCounters;
- (void) setHasBeenShown: (BOOL) hasBeenShown;

- (BOOL) hasBeenShown;
- (NSString *) currentBuildVersion;
- (NSString *) lastVersionUsed;
- (NSDate *) installDate;
- (void) setInstallDate;
- (void) logSignificantEvent;

- (void) requestUserRating;
- (NSInteger) significantEvents;

@end
