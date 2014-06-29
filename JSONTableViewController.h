//
//  JSONTableViewController.h
//  JSONSorter
//
//  Created by Troy Barrett on 6/28/14.
//
//

#import <UIKit/UIKit.h>

@interface JSONTableViewController : UITableViewController

@property (strong, nonatomic) NSDictionary *parsedJSON;
@property (strong, nonatomic) NSArray *allKeys;

@end
