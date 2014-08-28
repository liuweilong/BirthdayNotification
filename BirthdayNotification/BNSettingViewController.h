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
#import "BNRennService.h"
#import "BNSettingView.h"
#import "BNSettingViewDelegate.h"

@interface BNSettingViewController : UIViewController <BNRennServiceDelegate, BNSettingViewDelegate>

@end
