//
//  BNSettingView.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 28/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNSettingTableView.h"
#import "BNSettingTableViewDataSource.h"
#import "BNSettingViewTableViewCell.h"
#import "BNSettingViewController.h"
#import "BNSettingViewDelegate.h"

typedef void (^TableViewCellSelectionBlock)(id index);

@interface BNSettingView : UIView <UITableViewDelegate>

@property (strong, nonatomic) IBOutlet BNSettingTableView *settingTableView;
@property (strong, nonatomic) BNSettingTableViewDataSource *tableViewDataSource;
@property (nonatomic, copy) TableViewCellSelectionBlock cellSelectionBlock;
@property (strong, nonatomic) UIAlertView *waitAlert;
@property (strong, nonatomic) UIAlertView *loginAlert;
@property (strong, nonatomic) id<BNSettingViewDelegate> delegate;

- (void)loadWithTableViewCellSelectionBlock:(TableViewCellSelectionBlock)cellSelectionBlock delegate:(id<BNSettingViewDelegate>) delegate;
- (void)showAlertView;
- (void)dismissAlertView;
- (void)showLoginAlert;
@end
