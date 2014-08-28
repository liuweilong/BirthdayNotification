//
//  BNSettingTableView.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 28/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNSettingTableView.h"

@interface BNSettingTableView()

@property (strong, nonatomic) BNSettingTableViewDataSource *tableViewDataSource;

@end

@implementation BNSettingTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)changeCellStyleAfterLogin {
    UITableViewCell *cell = (UITableViewCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.backgroundColor = [BNUtilities colorWithHexString:@"95a5a6"];
    cell.textLabel.text = @"解除人人链接";
}

- (void)changeCellStyleAfterLogout {
    UITableViewCell *cell = (UITableViewCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.backgroundColor = [BNUtilities colorWithHexString:@"16a085"];
    cell.textLabel.text = @"链接到人人";
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
