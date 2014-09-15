//
//  RDLoveSeeker.h
//  RDLoveSeeker
//
//  Created by Lucas Vidal on 2/17/14.
//  Copyright (c) 2014 Restorando. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LoveSeekerAnswerEventLoveSeekerShown,
    LoveSeekerAnswerEventILoveYou,
    LoveSeekerAnswerEventIDontLoveYou,
    LoveSeekerAnswerEventImGoingToRateYou,
    LoveSeekerAnswerEventIDontWantToRateYou,
    LoveSeekerAnswerEventIDontWantToRateYouAndDontBotherAnymore,
    LoveSeekerAnswerEventImGoingToGiveYouFeedback,
    LoveSeekerAnswerEventIDontWantToGiveYouFeedback,
    LoveSeekerAnswerEventIDontWantToGiveYouFeedbackAndDontBotherAnymore
} LoveSeekerAnswerEvent;

@protocol RDLoveSeekerDelegate <NSObject>

@optional

- (void) loveSeekerDidReceiveAnswer: (LoveSeekerAnswerEvent) event;

@end

@interface RDLoveSeeker : NSObject

//Initialization

+ (void) setDebug: (BOOL) configDebug;
+ (void) setDaysToRequestRating: (NSInteger) configDays;
+ (void) setEventsToRequestRating: (NSInteger) configEvents;
+ (void) setShouldRequestOnNewVersion: (BOOL) configShouldRequestOnNewVersion;
+ (void) setAppStoreID: (NSInteger) configAppStoreID;
+ (void) setFeedbackEmailAddress: (NSString *) configFeedbackEmailAddress;
+ (void) setDelegate: (id<RDLoveSeekerDelegate>) delegate;

//Control
+ (void) logSignificantEvent;
+ (void) verifyIfNeedsToBeShown;
+ (void) notifyLSDelegateWithAnswer: (LoveSeekerAnswerEvent) answer;

//Internal

+ (NSInteger) appStoreID;
+ (NSString *) feedbackEmailAddress;
@end
