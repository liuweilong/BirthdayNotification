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

@property (nonatomic, strong) NSArray *friendsDetail;
@property (nonatomic, strong) NSMutableArray *filteredFriendsDetail;

+ (BNFriendsDetail *)sharedFriendsDetail;

@end
