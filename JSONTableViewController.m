//
//  JSONTableViewController.m
//  JSONSorter
//
//  Created by Troy Barrett on 6/28/14.
//
//

#import "JSONTableViewController.h"
#import "JSONTableViewController2.h"

@interface JSONTableViewController ()

@end

@implementation JSONTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)parseJSON
{
    NSError *error = nil;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"jsondata" ofType:@"txt"];
    NSString* jsonContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    NSData *jsonData = [jsonContents dataUsingEncoding:NSUTF8StringEncoding];
    
    self.parsedJSON =
    [NSJSONSerialization JSONObjectWithData: jsonData
                                    options: NSJSONReadingMutableContainers
                                      error: nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    NSMutableDictionary *myDictionary = [NSMutableDictionary new];
    
//    NSMutableArray *arrayKey =[NSMutableArray arrayWithArray:@[@"this is my element"]];
//    myDictionary[arrayKey] = @"It Worked!";
//    
//    NSLog(@"My Class is: %@", [arrayKey.class description]);
//    NSLog(@"Retreive: %@", [myDictionary[arrayKey] description]);
    [self parseJSON];
    self.allKeys = [self.parsedJSON allKeys];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allKeys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"basicCell" forIndexPath:indexPath];
    
    // Configure the cell...
    id key = self.allKeys[indexPath.row];
    cell.textLabel.text = [key description];
    
    NSString *className = [[self.parsedJSON[key] class] description];
    cell.detailTextLabel.text = className;
    
    
    
    
//    NSString *keyValue = cell.textLabel.text;
//    
//    id object = [self.parsedJSON objectForKey:keyValue];
//    
//    NSString *className = [[object class] description];
    

    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    JSONTableViewController2 *nextVC = segue.destinationViewController;
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    
    
//    UITableViewCell *cell = sender;
//    NSString *key = cell.textLabel.text;
//    NSDictionary *nextLevel= [self.parsedJSON objectForKey:key];
//    nextVC.allKeys = [nextLevel allKeys];
//    nextVC.parsedJSON = nextLevel;
}

@end
