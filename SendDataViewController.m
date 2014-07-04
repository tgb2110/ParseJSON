//
//  SendDataViewController.m
//  JSONSorter
//
//  Created by Troy Barrett on 7/4/14.
//
//

#import "SendDataViewController.h"

@interface SendDataViewController ()
- (IBAction)email:(id)sender;

- (IBAction)text:(id)sender;

@end

@implementation SendDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildMessage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions
- (IBAction)email:(id)sender {
    self.emailTitle = @"Test Email";
    
    self.recipients = @[@"OB.Troy@me.com"];
    // ^ will have an interim to take in user param and set email accordingly
    
    MFMailComposeViewController *emailView = [[MFMailComposeViewController alloc]init];
    
    emailView.mailComposeDelegate = self;
    
    [emailView setSubject:self.emailTitle];
    [emailView setMessageBody:self.message isHTML:NO];
    [emailView setToRecipients:self.recipients];
    
    [self presentViewController:emailView animated:YES completion:nil];
}

- (IBAction)text:(id)sender {
    
    if (![MFMessageComposeViewController canSendText]) {
        // ^ apparently this comes back as a boolean saying if texting is available wont run without it
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device does not support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    
    self.recipients = @[@"6198662982"];
    // ^ will have an interim to take in user param and set phone number accordingly
    
    MFMessageComposeViewController *messageView = [[MFMessageComposeViewController alloc]init];

    messageView.messageComposeDelegate = self;
    
    [messageView setRecipients:self.recipients];
    [messageView setBody:self.message];
    
    [self presentViewController:messageView animated:YES completion:nil];
}

#pragma mark - Email operations
// handles operations from mail client and dismisses modal back to app
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Text operations
// handles operations from text message and dismisses modal back to app
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MessageComposeResultSent:
            NSLog(@"Mail sent");
            break;
        default:
            break;
    }
    // Close the Message Interface
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Message

- (void)buildMessage
{// goes through all view controllers are adds title property to message string
    self.title = @"Final controller";
    
    self.message = [[NSMutableString alloc] initWithString:@"JSON PATH (via stacked View Controllers) \n\n"];
    
    NSArray *controllerArray = [[self navigationController] viewControllers];
    
    for (UIViewController *controller in controllerArray) {
        [self.message appendString:[NSString stringWithFormat:@"@[%@]\n", controller.title]];
        
        // ^ need to find a way around the "{" dictionary
        // messes with the print out and pretty sure skips an entire dictionary
    }
}


@end
