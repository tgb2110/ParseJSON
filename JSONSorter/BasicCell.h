//
//  BasicCell.h
//  JSONSorter
//
//  Created by Zachary Drossman on 7/2/14.
//
//

#import <UIKit/UIKit.h>

@interface BasicCell : UITableViewCell

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UILabel *keyLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dataPrintOut;

@end
