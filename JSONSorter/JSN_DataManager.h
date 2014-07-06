//
//  JSN_DataManager.h
//  JSONSorter
//
//  Created by Zachary Drossman on 7/4/14.
//
//

#import <Foundation/Foundation.h>

typedef void(^CompletionBlock)(NSMutableData *responseData, NSError *error);


@interface JSN_DataManager : NSObject <NSURLConnectionDelegate>

#pragma mark - Properties
@property (strong, nonatomic) NSMutableData *responseData;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSArray *sources;

#pragma mark - ClassMethods
+ (instancetype)sharedDataManager;

#pragma mark - InstanceMethods

#pragma mark WebData
-(void)fetchJSONData:(NSString *)URLAddress withCompletionBlock:(CompletionBlock)completionBlock;

#pragma mark CoreData
- (void) saveContext;
- (void) generateTestData;
- (void) fetchSourceData;

@end
