//
//  BNMainView.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 29/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BNMainTableView.h"
#import "BNFriendsDetail.h"
#import "BNFriendDetailTableViewCell.h"
#import "BNUtilities.h"

@interface BNMainView : UIView <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet BNMainTableView *mainTableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) BNFriendsDetail *friendsDetail;
@property (strong, nonatomic) UISearchDisplayController *searchDisplayController;
@property NSArray *tableCellColor;

- (void)loadViewWithModel:(BNFriendsDetail *)friendsDetail searchDisplauController:(UISearchDisplayController *)searchDisplayController;
- (void)resetTableViewContentOffset:(float)offset withAnimation:(BOOL)animation;

@end
