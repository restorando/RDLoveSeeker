//
//  RDLoveSeekerViewController.m
//  RDLoveSeeker
//
//  Created by Lucas Vidal on 2/18/14.
//  Copyright (c) 2014 Restorando. All rights reserved.
//

#import "RDLoveSeekerViewController.h"
#import "RDLoveSeeker.h"
#import "RDLoveSeekerStatusController.h"

@interface RDLoveSeekerViewController ()

@property (nonatomic, strong) NSBundle *bundle;

@end

typedef enum {
    AlertDoYouLoveRestorando = 0,
    AlertWeAreSoHappyToHearThat,
    AlertWhatCanWeDoToMakeYouLoveUs,
    AlertErrorSendingFeedback,
    AlertThanksForYourFeedback
} Alerts;

@implementation RDLoveSeekerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)setView:(UIView *)view{
    [super setView:view];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view = [[UIView alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor: [UIColor clearColor]];
    [self.view setFrame: [[UIApplication sharedApplication] keyWindow].frame];

    [self showDialog: AlertDoYouLoveRestorando];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showDialog: (NSInteger) dialogTag
{
    UIAlertView *alert;
    
    switch (dialogTag) {
        case AlertDoYouLoveRestorando:
            alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Do you love Restorando?",nil)
                                               message: nil
                                              delegate: self
                                     cancelButtonTitle: NSLocalizedString(@"No",nil)
                                     otherButtonTitles: NSLocalizedString(@"Yes",nil), nil];
            break;
            
        case AlertWeAreSoHappyToHearThat:           //positive review
            alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"We're so happy to hear that",nil)
                                               message: NSLocalizedString(@"It'd be really helpful if you rated us.",nil)
                                              delegate: self
                                     cancelButtonTitle: NSLocalizedString(@"No thanks",nil)
                                     otherButtonTitles: NSLocalizedString(@"Rate app",nil), NSLocalizedString(@"Not now",nil), nil];
            break;
            
        case AlertWhatCanWeDoToMakeYouLoveUs:       //negative review
           alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"What can we do to ensure that you love our app?",nil)
                                              message: NSLocalizedString(@"We appreciate your feedback.",nil)
                                             delegate: self
                                    cancelButtonTitle: NSLocalizedString(@"No thanks",nil)
                                    otherButtonTitles: NSLocalizedString(@"Send email",nil), NSLocalizedString(@"Not now",nil), nil];
            break;
        
        case AlertThanksForYourFeedback:       //negative review
            alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Thank you for helping us improve!",nil)
                                               message: @""
                                              delegate: self
                                     cancelButtonTitle: NSLocalizedString(@"OK",nil)
                                     otherButtonTitles: nil];
            break;
            
        default:
            return;
            break;
    }
    [alert setTag: dialogTag];
    [alert show];
}

- (void) goToAppStore
{
    NSString *str = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%d", [RDLoveSeeker appStoreID]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void) sendFeedbackEmail
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    mailComposer.navigationBar.tintColor = UIColorFromRGB(0x3466FF);
    [mailComposer setMailComposeDelegate: self];
    
    if ([MFMailComposeViewController canSendMail]) {
        [mailComposer setToRecipients:@[[RDLoveSeeker feedbackEmailAddress]]];
        [mailComposer setSubject: NSLocalizedString(@"Feedback Email subject", nil)];
        [mailComposer setMessageBody:NSLocalizedString(@"Feedback Email body", nil) isHTML:NO];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    else
    {
        [self errorSendingFeedbackEmail];
    }
}

- (void) errorSendingFeedbackEmail
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: NSLocalizedString(@"Ooops",nil) message:NSLocalizedString(@"There was an error sending feedback. Please try again later.",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil];
    [alert setTag: AlertErrorSendingFeedback];
    [alert show];
    [self askAgainLater];
}

- (void) askAgainLater
{
    [[RDLoveSeekerStatusController sharedInstance] resetAllCounters];
    [[RDLoveSeekerStatusController sharedInstance] dismissAndRestoreApp];
}

- (void) doNotAskAgain
{
    [[RDLoveSeekerStatusController sharedInstance] setHasBeenShown: YES];
    [[RDLoveSeekerStatusController sharedInstance] dismissAndRestoreApp];
}

#pragma mark UIAlertViewDelegate

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case AlertDoYouLoveRestorando:
            if (buttonIndex == 1) {     // YES
                [self showDialog:AlertWeAreSoHappyToHearThat];
                [RDLoveSeeker notifyLSDelegateWithAnswer: LoveSeekerAnswerEventILoveYou];
            }
            else {                      // NO
                [self showDialog:AlertWhatCanWeDoToMakeYouLoveUs];
                [RDLoveSeeker notifyLSDelegateWithAnswer: LoveSeekerAnswerEventIDontLoveYou];
            }
            break;
            
        case AlertWeAreSoHappyToHearThat:
            if (buttonIndex == 1) {         //Yes!
                [self doNotAskAgain];
                [self goToAppStore];
                [RDLoveSeeker notifyLSDelegateWithAnswer: LoveSeekerAnswerEventImGoingToRateYou];
            }
            else if (buttonIndex == 2) {    //Not now
                [self askAgainLater];
                [RDLoveSeeker notifyLSDelegateWithAnswer: LoveSeekerAnswerEventIDontWantToRateYou];
            }
            else {                          // No, thanks
                [self doNotAskAgain];
                [RDLoveSeeker notifyLSDelegateWithAnswer: LoveSeekerAnswerEventIDontWantToRateYouAndDontBotherAnymore];
            }
            break;
            
        case AlertWhatCanWeDoToMakeYouLoveUs:
            if (buttonIndex == 1) {         //Send email
                [self sendFeedbackEmail];   //will dismiss everything after being called by mail composer
                [RDLoveSeeker notifyLSDelegateWithAnswer: LoveSeekerAnswerEventImGoingToGiveYouFeedback];
            } else if (buttonIndex == 2) {  //Not now
                [self askAgainLater];
                [RDLoveSeeker notifyLSDelegateWithAnswer: LoveSeekerAnswerEventIDontWantToGiveYouFeedback];
            } else {                        // No, thanks
                [self doNotAskAgain];
                [RDLoveSeeker notifyLSDelegateWithAnswer: LoveSeekerAnswerEventIDontWantToGiveYouFeedbackAndDontBotherAnymore];
            }
            break;
            
        case AlertThanksForYourFeedback:
        {
            [self doNotAskAgain];
        }
        default:
            break;
    }

}

#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
    if (!error)
    {
        if (result == MFMailComposeResultSent)
            [self showDialog: AlertThanksForYourFeedback];
        else
            [self askAgainLater];
    }
    else
    {
        [self errorSendingFeedbackEmail];
    }
}

@end
