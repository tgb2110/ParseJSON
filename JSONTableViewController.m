//
//  JSONTableViewController.m
//  JSONSorter
//
//  Created by Troy Barrett on 6/28/14.
//
//

#import "JSONTableViewController.h"
#import "BasicCell.h"
#import "JSN_DataManager.h"
#import "Source.h"
#import "SendDataViewController.h"


@interface JSONTableViewController () <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableString *message;
@property (strong, nonatomic) NSString *keyForSelectedIndexPath;

@end

@implementation JSONTableViewController

#pragma mark - View Controller Lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUINavigationButtons];
}

- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];
    
    [self prepareDataSource];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allKeys count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    BasicCell *cell = (BasicCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BasicCell" owner:self options:nil];
        cell = [nib objectAtIndex:0]; // custom cell
    }
    
    id key = self.allKeys[indexPath.row];

    cell.keyLabel.text = [key description];
    
    NSString *dataType = [NSString stringWithFormat:@"%@", [self.allValues[indexPath.row] class]];
    // ^ pulls class from index path for data type display
    
    cell.dataTypeLabel.text = dataType;
    //cell.dataLabel.text =
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BasicCell *cell = (BasicCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    self.keyForSelectedIndexPath = cell.keyLabel.text;
    NSString *dataType = cell.dataTypeLabel.text;
    
    NSLog(@"\n\nSelected Key: @[%@] \nDataType : @[%@]\n", self.keyForSelectedIndexPath, dataType);
    
    //self.title = self.keyForSelectedIndexPath;
    // ^ easiest place to ensure we grab what the user sees for final path printout
    
    if ([self.layerData isKindOfClass:[NSDictionary class]])
    {
        [self buildNextLevelFromDictionary];
    }
    
    else if ([self.layerData isKindOfClass:[NSArray class]])
    {
        [self buildNextLevelFromArray:indexPath];
    }
}

#pragma mark - Parsing Methods
- (void)prepareDataSource
{
    if ([self.navigationController.viewControllers count] < 3)
    {
        
            self.dataManager = [JSN_DataManager sharedDataManager];
            
            [self.dataManager fetchJSONData:self.source.urlAddress withCompletionBlock:^(NSMutableData *responseData, NSError *error) {
                
                self.layerData = [NSJSONSerialization JSONObjectWithData:self.dataManager.responseData options: NSJSONReadingMutableContainers error: nil];
                
                [self parseLayerDataIntoArrays];
            }];
    }
    
    else
    {
        [self parseLayerDataIntoArrays];
    }

}

- (void)parseLayerDataIntoArrays
{
    if ([self.layerData isKindOfClass:[NSDictionary class]])
    {
        self.allKeys = [(NSDictionary *)self.layerData allKeys];
        self.allValues = [(NSDictionary *)self.layerData allValues];
        // ^ used for data type text field during cell population
    }
    else if ([self.layerData isKindOfClass:[NSArray class]])
    {
        self.allKeys = self.layerData;
        self.allValues = self.layerData;
        // ^ by setting equal removed need to descern between dictionary or array during cell population
    }
    
    [self.tableView reloadData];
}

#pragma mark - Build Next Level of JSON

#pragma mark From Selected Dictionary
- (void)buildNextLevelFromDictionary
{
    if ([[self.layerData objectForKey:self.keyForSelectedIndexPath] isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *nextLevel= [self.layerData objectForKey:self.keyForSelectedIndexPath];
        [self buildFinalNextLevel:nextLevel];
    }
    
    else if ([[self.layerData objectForKey:self.keyForSelectedIndexPath] isKindOfClass:[NSArray class]])
    {
        NSArray *nextLevel= [self.layerData objectForKey:self.keyForSelectedIndexPath];
        [self buildFinalNextLevel:nextLevel];
    }
}

#pragma mark From Selected Array
- (void)buildNextLevelFromArray:(NSIndexPath *)indexPath
{
    NSArray *nextLevel= self.layerData[indexPath.row];
    [self buildFinalNextLevel:nextLevel];
}

#pragma mark
- (void)buildFinalNextLevel:(id)nextLevel
{  // ^ used generic (id)nextLevel to allow same method for both incoming dictionary and array
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    JSONTableViewController *JSON_TVC = [storyboard instantiateViewControllerWithIdentifier:@"JSON_TVC"];
    
    JSON_TVC.layerData = nextLevel;
    JSON_TVC.title = self.keyForSelectedIndexPath;
    [self.navigationController pushViewController:JSON_TVC animated:YES];
}

#pragma mark - Boilerplate (unused)
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
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}
*/

#pragma mark - Distribution
- (void)setUINavigationButtons
{
    UIBarButtonItem *btnEmail = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(sendJSONPathViaEmail)];
    UIBarButtonItem *btnMessage = [[UIBarButtonItem alloc] initWithTitle:@"SMS" style:0 target:self action:@selector(sendJSONPathViaMessage)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnEmail, btnMessage, nil]];
}

#pragma mark - Build Final JSON Path

- (void)buildMessage
{// goes through all view controllers and adds title property to message string
    self.title = @"Final controller";
    
    self.message = [[NSMutableString alloc] initWithString:@"JSON PATH (via stacked View Controllers) \n\n"];
    
    NSArray *controllerArray = [[self navigationController] viewControllers];
    
    for (NSInteger controllerNumber = 0; controllerNumber < [controllerArray count]; controllerNumber++)
    {
        if (controllerNumber > 1)
        {
            UIViewController *controller = controllerArray[controllerNumber];
            
            NSMutableString *layerTitle = [[NSString stringWithFormat:@"@[%@]\n", controller.title] mutableCopy];
            
            if (![[layerTitle substringToIndex:3] isEqualToString:@"@[{"])
            {
                [self.message appendString:layerTitle];
            }
            
            // ^ need to find a way around the "{" dictionary
            // messes with the print out and pretty sure skips an entire dictionary
        }
    }
}

#pragma mark - Send JSON path via

#pragma mark Email

-(void)sendJSONPathViaEmail {
    
    [self buildMessage];
    MFMailComposeViewController *emailView = [[MFMailComposeViewController alloc]init];
    
    emailView.mailComposeDelegate = self;
    [emailView setMessageBody:self.message isHTML:NO];
    
    [self presentViewController:emailView animated:YES completion:nil];
}
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

#pragma mark SMS

- (void)sendJSONPathViaMessage {
    
    [self buildMessage];
    
    if (![MFMessageComposeViewController canSendText]) {
        // ^ apparently this comes back as a boolean saying if texting is available wont run without it
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device does not support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    MFMessageComposeViewController *messageView = [[MFMessageComposeViewController alloc]init];
    
    messageView.messageComposeDelegate = self;
    
    [messageView setBody:self.message];
    
    [self presentViewController:messageView animated:YES completion:nil];
}
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

@end
