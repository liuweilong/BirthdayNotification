
//
//  BNSettingTableViewDataSource.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 28/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNSettingTableViewDataSource.h"

@interface BNSettingTableViewDataSource()

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewCellConfigureBlock cellConfigureBlock;

@end

@implementation BNSettingTableViewDataSource

- (id)initWithCellIdentifier:(NSString *)cellIdentifier cellConfigureBlock:(TableViewCellConfigureBlock)cellConfigureBlock {
    if (self = [super init]) {
        self.cellIdentifier = cellIdentifier;
        self.cellConfigureBlock = cellConfigureBlock;
    }
    
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cellConfigureBlock(cell, indexPath);
    
    return cell;
}

@end
