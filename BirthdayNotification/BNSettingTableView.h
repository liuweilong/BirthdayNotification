//
//  BNSettingTableView.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 28/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNSettingTableViewDataSource.h"
#import "BNUtilities.h"

@interface BNSettingTableView : UITableView

- (void)changeCellStyleAfterLogin;
- (void)changeCellStyleAfterLogout;

@end
