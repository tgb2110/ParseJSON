//
//  JSONTableViewController.h
//  JSONSorter
//
//  Created by Troy Barrett on 6/28/14.
//
//

#import <UIKit/UIKit.h>

@class Source;
@class JSN_DataManager;
@interface JSONTableViewController : UITableViewController

#pragma mark - Properties
@property (strong, nonatomic) id layerData;
@property (strong, nonatomic) NSArray *allKeys;
@property (strong, nonatomic) NSArray *allValues;
@property (strong, nonatomic) JSN_DataManager *dataManager;
@property (strong, nonatomic) Source *source;

#pragma mark - Methods
#pragma mark Parsing

- (void)parseLayerDataIntoArrays;

#pragma mark BuildNextLevelOfJSON

- (void)buildNextLevelFromDictionary:(NSString *)key;
- (void)buildNextLevelFromArray:(NSIndexPath *)indexPath;
- (void)buildFinalNextLevel:(id)nextLevel;

@end
