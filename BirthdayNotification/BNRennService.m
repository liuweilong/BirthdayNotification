//
//  BNRennService.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 27/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNRennService.h"

#define REQUEST_PAGE_SIZE 100
#define USER_PROFILE_REQUEST @"GetProfile"
#define USER_FRINED_LIST_REQUEST @"ListUserFriend"
#define USER_DETAIL_REQUEST @"BatchUser"

@implementation BNRennService

+ (BNRennService *)sharedRennService {
    static BNRennService *rennService;
    @synchronized(self) {
        if (!rennService) {
            rennService = [[BNRennService alloc] init];
        }
    }
    return rennService;
}

- (id)init {
    self = [super init];
    if (self) {
        requestPageNumber = 1;
        
        self.renRenFriendIdList = [[NSMutableArray alloc] init];
        self.renRenFriendDetailList = [[NSMutableArray alloc] init];
        
        [RennClient initWithAppId:@"a"
                           apiKey:@"9b20561fa1454f78b9506f432cea9790"
                        secretKey:@"55f15c5de9f441a1ab9a7dae987a20c0"];
        //设置权限
        [RennClient setScope:@"read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
    }
    
    return self;
}

/**
 Renn Login/Logout process
 */
- (void)toggleLoginStatus {
    if ([RennClient isLogin]) {
        [RennClient logoutWithDelegate:self];
    } else {
        [RennClient loginWithDelegate:self];
    }
}

- (BOOL)isLogin {
    return [RennClient isLogin];
}

- (void)rennLoginSuccess {
    [self.delegate loginSuccess];
}

- (void)rennLogoutSuccess {
    [self.delegate logOutSuccess];
}

/**
 Request User's friend's details related functions
 */

- (void)requestRennFriendsDetail {
    [self.delegate dataQueryingStarted];
    [self requestRennCurrentUserInfo];
}

- (void)requestRennFriendListInfo:(int)numOfFriend {
    for (int i = 0; i < numOfFriend; i+=REQUEST_PAGE_SIZE) {
        [self friendListRequestWithPageNumber:requestPageNumber++ pageSize:REQUEST_PAGE_SIZE];
    }
}


- (void)requestRennCurrentUserInfo {
    GetProfileParam *param = [[GetProfileParam alloc] init];
    param.userId = [RennClient uid];
    [RennClient sendAsynRequest:param delegate:self];
}

//There are restrictions of using RennService. Developers can only request uptp 100 user's friend per page
- (void)friendListRequestWithPageNumber:(int)pageNumber pageSize:(int)pageSize {
    ListUserFriendParam *param = [[ListUserFriendParam alloc] init];
    param.userId = [RennClient uid];
    param.pageNumber = pageNumber;
    param.pageSize = pageSize;
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)userInfoRequestWithIDArray:(NSArray *)idArray {
    for (int i = 0; i < idArray.count; i+=50) {
        int range = 49;
        if (i+49 >= idArray.count) {
            range = (int)idArray.count - i - 1;
        }
        BatchUserParam *param = [[BatchUserParam alloc] init];
        param.userIds = [idArray subarrayWithRange:NSMakeRange(i, range+1)];
        [RennClient sendAsynRequest:param delegate:self];
    }
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    if ([service.type isEqualToString:USER_PROFILE_REQUEST]) {
        NSDictionary *profile = (NSDictionary *)response;
        int num = [[profile objectForKey:@"friendCount"] intValue];
        numOfFriends = num;
        [self requestRennFriendListInfo:num];
    } else if ([service.type isEqualToString:USER_FRINED_LIST_REQUEST]){
        NSArray *array = (NSArray *)response;
        for (NSDictionary *friend in array) {
            [self.renRenFriendIdList addObject:[friend objectForKey:@"id"]];
        }
        
        if (self.renRenFriendIdList.count == numOfFriends) {
            [self userInfoRequestWithIDArray:self.renRenFriendIdList];
        }
    } else if ([service.type isEqualToString:USER_DETAIL_REQUEST]){
        NSArray *array = (NSArray *)response;
        for (NSDictionary *friendDetail in array) {
            [self.renRenFriendDetailList addObject:friendDetail];
            [BNCoreDataHelper storeFriendInfo:friendDetail managedObjectContext:[FriendInfo managedObjectContext]];
        }
        NSLog(@"%d and num: %d",self.renRenFriendDetailList.count, numOfFriends);
        if (self.renRenFriendDetailList.count == numOfFriends) {
            [self.delegate dataQueryingFinished];
        }
    }
}


@end
