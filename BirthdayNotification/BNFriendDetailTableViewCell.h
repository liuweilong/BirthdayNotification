//
//  BNFriendDetailTableViewCell.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 24/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendInfo.h"

@interface BNFriendDetailTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *nameTitle;
@property (strong, nonatomic) IBOutlet UILabel *birthdayTitle;

- (void)setupWithFriendDetail:(FriendInfo *)info colorHex:(NSString *)colorHex;

@end
