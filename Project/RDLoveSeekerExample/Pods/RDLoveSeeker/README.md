# RDLoveSeeker

[![Version](http://cocoapod-badges.herokuapp.com/v/RDLoveSeeker/badge.png)](http://cocoadocs.org/docsets/RDLoveSeeker)
[![Platform](http://cocoapod-badges.herokuapp.com/p/RDLoveSeeker/badge.png)](http://cocoadocs.org/docsets/RDLoveSeeker)

## Usage

To run the example project; clone the repo, and run `pod install` from the Project directory first.

## Installation

RDLoveSeeker will be soon available through [CocoaPods](http://cocoapods.org).
To install it simply add the following line to your Podfile:

    pod 'RDLoveSeeker', :git => 'git@github.com:Restorando/RDLoveSeeker.git'

## Author

Lucas Vidal, lucas@restorando.com

## License

RDLoveSeeker is available under the MIT license. See the LICENSE file for more info.

## Configuration examples

When you setup the library, i.e. in the AppDelegate.m you have to import the library with

    #import "RDLoveSeeker.h"

####Configuration

    [RDLoveSeeker setDebug: NO]; 						// Will display debug information

    [RDLoveSeeker setEventsToRequestRating:15];			// How many significant events should be triggered before requesting user opinion

    [RDLoveSeeker setDaysToRequestRating:21];			// How many days from install before requesting user opinion
    
    [RDLoveSeeker setShouldRequestOnNewVersion:YES];	// If set to YES, the library will reset counters when the build number is changed, to request user feedback again once requirements are met.
    
    [RDLoveSeeker setFeedbackEmailAddress:@"feedback@restorando.com"];	// Which email addres will be used to receive user feedback
    
    [RDLoveSeeker setAppStoreID:529290320];				// App ip from app store, where the user will (hopefully) reward with 5 stars

####Logging events

    [RDLoveSeeker logSignificantEvent]; 				// Use this method when you want to mark a significant event has happened.
One great use is to call this on AppDelegate#applicationDidBecomeActive:(UIApplication *)application method, which will count every app open.

If you want to check if condidions are met in a particular moment, just call

    [RDLoveSeeker verifyIfNeedsToBeShown]


####Localization and texts

To manage which texts will be displayed, set in your Localizable.strings for every language the following texts:

    // LoveSeeker Pod

	"Do you love Restorando?" = "Do you love Restorando?";
	"No" = "No";
	"Yes" = "Yes";
	"We're so happy to hear that" = "We're so happy to hear that you love Restorando!";
	"It'd be really helpful if you rated us." = "It'd be really helpful if you rated us. Thanks so much for using Restorando ;)";
	"Rate app" = "Rate app";
	"What can we do to ensure that you love our app?" = "What can we do to ensure that you love our app?";
	"We appreciate your feedback." = "We appreciate your feedback.";
	"No thanks" = "No thanks";
	"Not now" = "Not now";
	"Send email" = "Send email";
	"Feedback Email subject" = "My opinion about Restorando app";
	"Feedback Email body" = "What I didn't like: \n\n\n What I did like: \n\n\n";
	"Ooops" = "Ooops";
	"There was an error sending feedback. Please try again later." = "There was an error sending feedback. Please try again later.";
	"OK" = "OK";
	"Thank you for helping us improve!" = "Thank you for helping us improve!";

