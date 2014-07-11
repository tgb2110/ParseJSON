//
//  JSN_SourceTVC.h
//  JSONSorter
//
//  Created by Zachary Drossman on 7/6/14.
//
//

#import <UIKit/UIKit.h>
#import "JSN_DataManager.h"
@interface JSN_SourceTVC : UITableViewController <NSFetchedResultsControllerDelegate>

#pragma mark - Properties
@property (strong, nonatomic) JSN_DataManager *dataManager;
@property (strong, nonatomic) NSArray *sources;

@end
