//
//  RDLoveSeekerExampleTests.m
//  RDLoveSeekerExampleTests
//
//  Created by Lucas Vidal on 9/12/14.
//  Copyright (c) 2014 Restorando. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import <objc/runtime.h>
#import <RDLoveSeekerStatusController.h>
#import "AppDelegate.h"

#define DAYS 24*60*60

@interface RDLoveSeekerExampleTests : XCTestCase

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

static NSDate *_mockedDate;
static NSDate *_nowDate;
static id _mockedRDLoveSeekerStatusControllerSharedInstance;

//this category will hold a method to be swapped with [NSDate date]
@implementation NSDate (dateStub)

+ (NSDate*) mockedDate
{
    return _mockedDate;
}

@end

@implementation RDLoveSeekerExampleTests

+ (void)setUp
{
    //replace current date method with mocked date
    _nowDate = [NSDate date];
    _mockedDate = [NSDate date];
    Method original,swizzled;
    original = class_getClassMethod([NSDate class], @selector(date));
    swizzled = class_getClassMethod([NSDate class], @selector(mockedDate));
    method_exchangeImplementations(original, swizzled);
}

+ (void)tearDown
{
    //Return methods to default implementation
    Method original,swizzled;
    original = class_getClassMethod([NSDate class], @selector(date));
    swizzled = class_getClassMethod([NSDate class], @selector(mockedDate));
    method_exchangeImplementations(original, swizzled);
}

- (void)setUp
{
    [super setUp];
    [[RDLoveSeekerStatusController sharedInstance] resetAllCounters];
    _mockedRDLoveSeekerStatusControllerSharedInstance = [OCMockObject partialMockForObject:[RDLoveSeekerStatusController sharedInstance]];
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)tearDown
{
    _mockedRDLoveSeekerStatusControllerSharedInstance = nil;
    [super tearDown];
}


- (void) testApplicationWillNOTOpenPopupWhenOpening3times
{
    XCTAssertNotNil(_mockedRDLoveSeekerStatusControllerSharedInstance, @"mocked love seeker status controller can't be nil");
    [[_mockedRDLoveSeekerStatusControllerSharedInstance reject] requestUserRating];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]];

    [_mockedRDLoveSeekerStatusControllerSharedInstance verify];
}

- (void) testApplicationWillOpenPopupWhenOpening5times
{
    XCTAssertNotNil(_mockedRDLoveSeekerStatusControllerSharedInstance, @"mocked love seeker status controller can't be nil");
    [[_mockedRDLoveSeekerStatusControllerSharedInstance expect] requestUserRating];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]];

    [_mockedRDLoveSeekerStatusControllerSharedInstance verify];

}

- (void) testApplicationWillOpenPopupWhenReopeningAfterOneWeek
{
    XCTAssertNotNil(_mockedRDLoveSeekerStatusControllerSharedInstance, @"mocked love seeker status controller can't be nil");
    [[[_mockedRDLoveSeekerStatusControllerSharedInstance expect] andForwardToRealObject] requestUserRating];

    _mockedDate = [_nowDate dateByAddingTimeInterval: 7 * DAYS];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]]; //simulate opening to trigger date comparison

    [_mockedRDLoveSeekerStatusControllerSharedInstance verify];
}

- (void) testApplicationWillNOTOpenPopupWhenReopeningAfterOneDay
{
    XCTAssertNotNil(_mockedRDLoveSeekerStatusControllerSharedInstance, @"mocked love seeker status controller can't be nil");
    [[_mockedRDLoveSeekerStatusControllerSharedInstance reject] requestUserRating];

    _mockedDate = [_nowDate dateByAddingTimeInterval: 1 * DAYS];
    [self.appDelegate applicationWillEnterForeground: [UIApplication sharedApplication]]; //simulate opening to trigger date comparison

    [_mockedRDLoveSeekerStatusControllerSharedInstance verify];
}

@end
