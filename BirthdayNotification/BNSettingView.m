//
//  BNSettingView.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 28/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNSettingView.h"

static NSString *const SettingTablViewCellIdentifier = @"Cell";

@implementation BNSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)loadWithTableViewCellSelectionBlock:(TableViewCellSelectionBlock) cellSelectionBlock delegate:(id<BNSettingViewDelegate>) delegate{
    self.delegate = delegate;
    self.cellSelectionBlock = cellSelectionBlock;
    [self setupTableView];
    [self setupAlertView];
}

- (void)setupAlertView {
    self.waitAlert = [[UIAlertView alloc] initWithTitle:@"等等等..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    self.waitAlert.cancelButtonIndex = -1;
}

- (void)showAlertView {
    [self.waitAlert show];
}

- (void)dismissAlertView {
    [self.waitAlert dismissWithClickedButtonIndex:-1 animated:YES];
}

- (IBAction)dismissViewController:(id)sender {
    [self.delegate dismissViewController];
}

- (void)setupTableView {
    TableViewCellConfigureBlock cellConfigureBlock = ^(BNSettingViewTableViewCell *cell,
                                                       NSIndexPath *index) {
        [cell configureForIndex:index login:[[BNRennService sharedRennService] isLogin]];
    };
    
    self.tableViewDataSource = [[BNSettingTableViewDataSource alloc] initWithCellIdentifier:SettingTablViewCellIdentifier cellConfigureBlock:cellConfigureBlock];
    self.settingTableView.dataSource = self.tableViewDataSource;
    self.settingTableView.delegate = self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cellSelectionBlock(indexPath);
}

@end
