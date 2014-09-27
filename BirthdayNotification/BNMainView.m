//
//  BNMainView.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 29/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNMainView.h"

@implementation BNMainView

- (void)loadViewWithModel:(BNFriendsDetail *)friendsDetail searchDisplauController:(UISearchDisplayController *)searchDisplayController {
    self.friendsDetail = friendsDetail;
    self.searchDisplayController = searchDisplayController;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    
    [self setupTableView];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //Hiding search bar
//    CGRect newBounds = self.mainTableView.bounds;
//    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
//    self.mainTableView.bounds = newBounds;
}

- (void)setupTableView {
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.tableCellColor = [NSArray arrayWithObjects:@"f39c12", @"d35400", @"c0392b", @"e74c3c", @"e67e22", @"f1c40f", nil];
    CGRect newBounds = self.mainTableView.bounds;
    newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height;
    self.mainTableView.bounds = newBounds;
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.friendsDetail.filteredFriendsDetail count];
    } else {
        return [self.friendsDetail.friendsDetail count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNFriendDetailTableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:@"MainCell" forIndexPath:indexPath];
    
    FriendInfo *info = self.friendsDetail.friendsDetail[indexPath.row];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        info = [self.friendsDetail.filteredFriendsDetail objectAtIndex:indexPath.row];
    }
    int randNum = (int)(indexPath.row % (self.tableCellColor.count - 1));
    
    [cell setupWithFriendDetail:info colorHex:[self.tableCellColor objectAtIndex:randNum]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (void)resetTableViewContentOffset:(float)offset withAnimation:(BOOL)animation {
    [self.mainTableView setContentOffset:CGPointMake(0, -offset) animated:animation];
}

@end
