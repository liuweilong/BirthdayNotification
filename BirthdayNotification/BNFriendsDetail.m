//
//  BNFriendsDetail.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 27/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNFriendsDetail.h"

@implementation BNFriendsDetail

+ (BNFriendsDetail *)sharedFriendsDetail {
    static BNFriendsDetail *sharedFriendsDetail;
    @synchronized(self) {
        if (!sharedFriendsDetail) {
            sharedFriendsDetail = [[BNFriendsDetail alloc] init];
        }
    }
    
    return sharedFriendsDetail;
}

- (id)init {
    if (self = [super init]) {
        self.friendsDetail = [[NSMutableArray alloc] init];
    }
    return  self;
}

- (void)appendFriendDetail:(FriendInfo *)info {
    [self.friendsDetail addObject:info];
}

@end
