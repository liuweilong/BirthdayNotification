//
//  BNViewController.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 31/7/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RennSDK/RennSDK.h>
#import <CoreData/CoreData.h>

@interface BNViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
