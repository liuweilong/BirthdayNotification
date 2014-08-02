//
//  BNSettingViewController.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 1/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNSettingViewController.h"
#import "FriendInfo.h"
#import "BNUtilities.h"
#import "BNCoreDataHelper.h"

@interface BNSettingViewController () <RennLoginDelegate>{
    int numOfFriends;
    int requestPageNumber;
}
@property NSMutableArray *renRenFriendIdList;
@property NSMutableArray *renRenFriendDetailedList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *quitButton;

@end

#define REQUEST_PAGE_SIZE 100
#define USER_PROFILE_REQUEST @"GetProfile"
#define USER_FRINED_LIST_REQUEST @"ListUserFriend"
#define USER_DETAIL_REQUEST @"BatchUser"

@implementation BNSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setting up everything
    requestPageNumber = 1;
    self.renRenFriendIdList = [[NSMutableArray alloc] init];
    self.renRenFriendDetailedList = [[NSMutableArray alloc] init];
    
    //set navigation bar apperance
    /*
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    */
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    /*
    [self.navigationController.navigationBar setBarTintColor:[BNUtilities colorWithHexString:@"c0392b"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    NSArray *actionButtonItems = @[menuItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    */
    [self.view bringSubviewToFront:self.quitButton];
    
    //TableView setting
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    //Change table view background color
    self.tableView.backgroundColor = [BNUtilities colorWithHexString:@"34495e"];
    
    //初始化
    [RennClient initWithAppId:@"a"
                       apiKey:@"9b20561fa1454f78b9506f432cea9790"
                    secretKey:@"55f15c5de9f441a1ab9a7dae987a20c0"];
    //设置权限
    [RennClient setScope:@"read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backToMainWithDatabaseUpdated {
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTableView" object:nil userInfo:nil];
    }];
}

#pragma mark - RennService part
- (void)toggleLoginStatus {
    if ([RennClient isLogin]) {
        [RennClient logoutWithDelegate:self];
    } else {
        [RennClient loginWithDelegate:self];
    }
}

- (BOOL)isLogin {
    return false;
}

- (void)requestCurrentUserProfile {
    GetProfileParam *param = [[GetProfileParam alloc] init];
    param.userId = [RennClient uid];
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)requestFriendListInfo:(int)numOfFriend {
    for (int i = 0; i < numOfFriend; i+=REQUEST_PAGE_SIZE) {
        [self friendListRequestWithPageNumber:requestPageNumber++ pageSize:REQUEST_PAGE_SIZE];
    }
}

/**
 There are restrictions of using RennService. Developers can only request uptp 100 user's friend per page
 */
- (void)friendListRequestWithPageNumber:(int)pageNumber pageSize:(int)pageSize {
    ListUserFriendParam *param = [[ListUserFriendParam alloc] init];
    param.userId = [RennClient uid];
    param.pageNumber = pageNumber;
    param.pageSize = pageSize;
    [RennClient sendAsynRequest:param delegate:self];
}

- (void)userInfoRequestWithID:(NSArray *)idArray {
    NSLog(@"Size: %lu", (unsigned long)idArray.count);
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

#pragma mark - Renn Delegate method
- (void)rennLoginSuccess {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.backgroundColor = [BNUtilities colorWithHexString:@"95a5a6"];
    cell.textLabel.text = @"解除人人链接";
}

- (void)rennLogoutSuccess {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.backgroundColor = [BNUtilities colorWithHexString:@"16a085"];
    cell.textLabel.text = @"链接到人人";
}

- (void)rennService:(RennService *)service requestFailWithError:(NSError*)error
{
    //NSLog(@"requestFailWithError:%@", [error description]);
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
        //NSLog(@"numofFriend: %d", num);
        [self requestFriendListInfo:num];
    } else if ([service.type isEqualToString:USER_FRINED_LIST_REQUEST]){
        NSArray *array = (NSArray *)response;
        for (NSDictionary *friend in array) {
            NSLog(@"name: %@", [friend objectForKey:@"name"]);
            [self.renRenFriendIdList addObject:[friend objectForKey:@"id"]];
        }
        //NSLog(@"array cout: %d", array.count);
        if (self.renRenFriendIdList.count == numOfFriends) {
            [self userInfoRequestWithID:self.renRenFriendIdList];
        }
    } else if ([service.type isEqualToString:USER_DETAIL_REQUEST]){
        NSArray *array = (NSArray *)response;
        NSLog(@"arraysize: %lu", (unsigned long)array.count);
        for (NSDictionary *friendDetail in array) {
            NSLog(@"id: %@, name: %@", [friendDetail objectForKey:@"id"], [friendDetail objectForKey:@"name"]);
            [BNCoreDataHelper storeFriendInfo:friendDetail managedObjectContext:[self managedObjectContext]];
        }
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    switch (indexPath.row) {
        case 0:
            if ([RennClient isLogin]) {
                cell.backgroundColor = [BNUtilities colorWithHexString:@"95a5a6"];
                cell.textLabel.text = @"解除人人链接";
            }
            else {
                cell.backgroundColor = [BNUtilities colorWithHexString:@"16a085"];
                cell.textLabel.text = @"链接到人人";
            }
            break;

        case 1:
            cell.textLabel.text = @"同步人人数据";
            cell.backgroundColor = [BNUtilities colorWithHexString:@"27ae60"];
            break;

        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self toggleLoginStatus];
            break;
        case 1:
            [self requestCurrentUserProfile];
            break;
            
        default:
            break;
    }
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 

@end
