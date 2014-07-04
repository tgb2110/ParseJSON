//
//  SendDataViewController.h
//  JSONSorter
//
//  Created by Troy Barrett on 7/4/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SendDataViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *emailTitle;
@property (strong, nonatomic) NSMutableString *message;
@property (strong, nonatomic) NSArray *recipients;
@property (strong, nonatomic) NSString *path;

@end
