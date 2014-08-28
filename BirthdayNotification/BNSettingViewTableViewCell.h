//
//  BNSettingViewTableViewCell.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 28/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNUtilities.h"
#import "BNRennService.h"

@interface BNSettingViewTableViewCell : UITableViewCell

- (void)configureForIndex:(NSIndexPath *)index login:(BOOL)login;

@end
