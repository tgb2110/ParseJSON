//
//  JSN_DataManager.m
//  JSONSorter
//
//  Created by Zachary Drossman on 7/4/14.
//
//

#import "JSN_DataManager.h"
#import "Source.h"

@interface JSN_DataManager ()

//@property (nonatomic, strong) CompletionBlock completionBlock;
@property (nonatomic) BOOL finished;

@end

@implementation JSN_DataManager

@synthesize managedObjectContext = _managedObjectContext;

#pragma mark - Singleton
+ (instancetype)sharedDataManager {
    static JSN_DataManager *_sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataManager = [[JSN_DataManager alloc] init];
    });
    
    return _sharedDataManager;
}

#pragma mark - WebData
-(void)fetchJSONData:(NSString *)URLAddress withCompletionBlock:(CompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URLAddress] cachePolicy:NSURLRequestUseProtocolCachePolicy
        timeoutInterval:10.0];
    // ^ Creates a request with the URL passed in
    
    NSURLConnection *connection =[[NSURLConnection alloc] initWithRequest:request delegate:self];

    // ^ Sets up a connection using the request
    
    dispatch_queue_t queue = dispatch_queue_create("dataDownloader",NULL);
    dispatch_async(queue, ^{
        [self waitForResponse];
        // ^ Holds up until it hears back that all of the delegate methods have completed
        
        NSLog(@"Active request finished");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error;
            completionBlock(self.responseData, error);
            // ^ Having completed the connection, the completion block gets filled with it's data
            NSLog(@"Download Process - Complete");
        });
    });
}
                       
- (void)waitForResponse // How NSRunLoops work I still have no idea. Going to talk to Joe about them to find out more.
{
    while (!self.finished) {

            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    self.finished = YES;
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
}



#pragma mark - CoreData

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"jsonApp.sqlite"];
    
    NSError *error = nil;
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"model" withExtension:@"momd"];
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


- (void)generateTestData
{

    Source *sourceOne = [NSEntityDescription insertNewObjectForEntityForName:@"Source" inManagedObjectContext:self.managedObjectContext];
    
    sourceOne.name = @"Stack Overflow";
    sourceOne.urlAddress = @"http://api.stackexchange.com/2.2/questions/?site=stackoverflow";
    
    [self saveContext];
    [self fetchSourceData];
}

-(NSFetchedResultsController *)resultsController
{
    if (!_resultsController)
    {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Source"];
        NSSortDescriptor *alphabeticalSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        fetchRequest.sortDescriptors = @[alphabeticalSort];
        
        _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        [_resultsController performFetch:nil];
        
    }
    return _resultsController;
}

- (void)fetchSourceData
{
    if ([self.resultsController.fetchedObjects count]==0) {
        [self generateTestData];
    }
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - ApplicationDocumentsDirectory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
