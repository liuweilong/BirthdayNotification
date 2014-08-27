//
//  BNFriendsDetail.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 27/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendInfo.h"

@interface BNFriendsDetail : NSObject

@property (nonatomic, strong) NSMutableArray *friendsDetail;

+ (BNFriendsDetail *)sharedFriendsDetail;
- (void)appendFriendDetail:(FriendInfo *)info;

@end
