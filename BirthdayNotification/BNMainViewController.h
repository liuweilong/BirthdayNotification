//
//  BNMainViewController.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 2/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNMainViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
