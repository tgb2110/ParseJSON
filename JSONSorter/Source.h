//
//  Source.h
//  JSONSorter
//
//  Created by Zachary Drossman on 7/6/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Source : NSManagedObject

@property (nonatomic, retain) NSString * urlAddress;
@property (nonatomic, retain) NSString * name;

@end
