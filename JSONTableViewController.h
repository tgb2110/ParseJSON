//
//  JSONTableViewController.h
//  JSONSorter
//
//  Created by Troy Barrett on 6/28/14.
//
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface JSONTableViewController : UITableViewController  <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) id layerData;
@property (strong, nonatomic) NSArray *allKeys;
@property (strong, nonatomic) NSArray *allValues;
@property (strong, nonatomic) NSMutableString *message;


#pragma mark - Parsing Methods
- (void)parseJSON;
- (void)parseDataSourceIntoArrays;

#pragma mark - Build Next Level of JSON

#pragma mark From Selected Dictionary
- (void)buildNextLevelFromDictionary:(NSString *)key;

#pragma mark From Selected Array
- (void)buildNextLevelFromArray:(NSIndexPath *)indexPath;

#pragma mark
- (void)buildFinalNextLevel:(id)nextLevel;

@end
