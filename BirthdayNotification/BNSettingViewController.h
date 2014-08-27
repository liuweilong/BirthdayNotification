//
//  BNSettingViewController.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 1/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <RennSDK/RennSDK.h>
#import "BNRennServiceDelegate.h"

@interface BNSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BNRennServiceDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
