//
//  BNRennService.h
//  BirthdayNotification
//
//  Created by Liu Weilong on 27/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RennSDK/RennSDK.h>
#import "FriendInfo.h"
#import "BNFriendsDetail.h"
#import "BNUtilities.h"
#import "BNCoreDataHelper.h"
#import "BNRennServiceDelegate.h"

@interface BNRennService : NSObject <RennLoginDelegate> {
    int requestPageNumber;
    int numOfFriends;
}

@property (strong, nonatomic) NSMutableArray *renRenFriendIdList;
@property (strong, nonatomic) NSMutableArray *renRenFriendDetailList;
@property (strong, nonatomic) id<BNRennServiceDelegate> delegate;

+ (BNRennService *)sharedRennService;
- (void)toggleLoginStatus;
- (BOOL)isLogin;
- (void)requestRennFriendsDetail;

@end
