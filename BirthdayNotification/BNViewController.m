//
//  BNViewController.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 31/7/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNViewController.h"

@interface BNViewController () <RennLoginDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *friendIDArray;
@property NSMutableArray *friendInfoArray;
@property int pageNumber;

@end

#define requestPageSize 100

@implementation BNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //Hide status bar
    [self setNeedsStatusBarAppearanceUpdate];
    
    //初始化
    [RennClient initWithAppId:@"270488"
                       apiKey:@"9b20561fa1454f78b9506f432cea9790"
                    secretKey:@"55f15c5de9f441a1ab9a7dae987a20c0"];

    self.pageNumber = 1;
    self.friendIDArray = [[NSMutableArray alloc] init];
    self.friendInfoArray = [[NSMutableArray alloc] init];
    
    //设置权限
    [RennClient setScope:@"read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
    
    if ([RennClient isLogin]) {
        [self.btnLogin setTitle:@"Log out" forState:UIControlStateNormal];
    }
    else {
        [self.btnLogin setTitle:@"Log in" forState:UIControlStateNormal];
    }
    
    
}

- (void)saveData:(NSDictionary *)friendInfoDict {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = self.friendIDArray[indexPath.row];
    NSLog(@"%@", cell.textLabel.text);
    return cell;
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendInfoArray.count;
}

//Log in action
- (IBAction)login:(id)sender {
    if ([RennClient isLogin]) {
        [RennClient logoutWithDelegate:self];
    } else {
        [RennClient loginWithDelegate:self];
    }
}

- (void)rennLoginSuccess {
    [self.btnLogin setTitle:@"Logout" forState:UIControlStateNormal];
}

- (void)rennLogoutSuccess {
    [self.btnLogin setTitle:@"Login" forState:UIControlStateNormal];
}
- (IBAction)getFriendsInfo:(id)sender {
    [self userInfoRequestWithID:[NSArray arrayWithObjects:[RennClient uid], nil]];
}

- (IBAction)request:(id)sender {
    [self rennRequestWithPageNumber:self.pageNumber pageSize:requestPageSize];
}

- (void)rennRequestWithPageNumber:(int)pageNumber pageSize:(int)pageSize {
    ListUserFriendParam *param = [[ListUserFriendParam alloc] init];
    param.userId = [RennClient uid];
    param.pageNumber = pageNumber;
    param.pageSize = pageSize;
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)userInfoRequestWithID:(NSArray *)idArray {
    NSLog(@"Size: %d", idArray.count);
    for (int i = 0; i < idArray.count; i+=50) {
        int range = 49;
        if (i+49 >= idArray.count) {
            range = idArray.count - i -1;
        }
        BatchUserParam *param = [[BatchUserParam alloc] init];
        param.userIds = [idArray subarrayWithRange:NSMakeRange(0, range+1)];
        [RennClient sendAsynRequest:param delegate:self];
    }
    
}

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    //NSLog(@"requestSuccessWithResponse:%@", [response description]);
    NSArray *array = (NSArray *)response;
    
    if (array.count > 0) {
        if ([[(NSDictionary *)array[0] objectForKey:@"basicInformation"] isEqual:[NSNull null]]) {
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dict = (NSDictionary *)array[i];
                [self.friendIDArray addObject:[dict objectForKey:@"id"]];
            }
            
            [self rennRequestWithPageNumber:self.pageNumber++ pageSize:requestPageSize];
            
            //NSLog(@"ID: %@", self.friendIDArray);
        } else {
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dict = (NSDictionary *)array[i];
                [self.friendInfoArray addObject:dict];
            }
            
            [self.tableView reloadData];
        }
    } else {
        [self userInfoRequestWithID:self.friendIDArray];
    }
    [self.tableView reloadData];
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    //NSLog(@"requestFailWithError:%@", [error description]);
    NSString *domain = [error domain];
    NSString *code = [[error userInfo] objectForKey:@"code"];
    NSLog(@"requestFailWithError:Error Domain = %@, Error Code = %@", domain, code);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
