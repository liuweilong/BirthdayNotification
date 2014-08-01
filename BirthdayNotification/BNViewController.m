//
//  BNViewController.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 31/7/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNViewController.h"
#import "FriendInfo.h"

@interface BNViewController () <RennLoginDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *friendIDArray;
@property NSArray *friendInfoArray;
@property int pageNumber;
@property NSArray *tableCellColor;

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
    [RennClient initWithAppId:@"a"
                       apiKey:@"9b20561fa1454f78b9506f432cea9790"
                    secretKey:@"55f15c5de9f441a1ab9a7dae987a20c0"];

    self.pageNumber = 1;
    self.friendIDArray = [[NSMutableArray alloc] init];
    self.friendInfoArray = [self queryFriendInfo];
    self.tableCellColor = [NSArray arrayWithObjects:@"16a085", @"27ae60", @"2980b9", @"8e44ad", @"e74c3c", @"c0392b", nil];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    //设置权限
    [RennClient setScope:@"read_user_blog read_user_photo read_user_status read_user_album read_user_comment read_user_share publish_blog publish_share send_notification photo_upload status_update create_album publish_comment publish_feed operate_like"];
    
    if ([RennClient isLogin]) {
        [self.btnLogin setTitle:@"Log out" forState:UIControlStateNormal];
    }
    else {
        [self.btnLogin setTitle:@"Log in" forState:UIControlStateNormal];
    }
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    FriendInfo *info = self.friendInfoArray[indexPath.row];
    
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [(NSDictionary *)info.basicInformation objectForKey:@"birthday"];
    
    //Give cell a random color from the array
    int randNum = indexPath.row % (self.tableCellColor.count - 1);
    cell.backgroundColor = [self colorWithHexString:self.tableCellColor[randNum]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (NSInteger)self.friendInfoArray.count;
}

//Convert hex to UIColor
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
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

- (void)rennService:(RennService *)service requestSuccessWithResponse:(id)response
{
    NSArray *array = (NSArray *)response;
    
    if (array.count > 0) {
        if ([[(NSDictionary *)array[0] objectForKey:@"basicInformation"] isEqual:[NSNull null]]) {
            //query ID
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dict = (NSDictionary *)array[i];
                NSLog(@"id: %@, name: %@", [dict objectForKey:@"id"], [dict objectForKey:@"name"]);
                [self.friendIDArray addObject:[dict objectForKey:@"id"]];
            }
            
            [self rennRequestWithPageNumber:self.pageNumber++ pageSize:requestPageSize];
            
        } else {
            //Where query full infomation
//            for (int i = 0; i < array.count; i++) {
//                NSDictionary *dict = (NSDictionary *)array[i];
//                //NSLog(@"id: %@, name: %@, birthday: %@", [dict objectForKey:@"id"], [dict objectForKey:@"name"], (NSDictionary *)[dict objectForKey:@"basicInformation"]);
//                [self storeFriendInfo:dict];
//            }
        }
    } else {
        //[self userInfoRequestWithID:self.friendIDArray];
    }
}

//Store friend infomation into sqlite database
- (BOOL)storeFriendInfo:(NSDictionary *)dict {
    if ([[dict objectForKey:@"basicInformation"] isEqual: [NSNull null]]) {
        NSLog(@"Basic is null");
        return FALSE;
    }
    
    NSError *error;
    NSManagedObjectContext *context = [self managedObjectContext];
    FriendInfo *friendInfo = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"FriendInfo"
                                       inManagedObjectContext:context];
    friendInfo.id = [dict objectForKey:@"id"];
    friendInfo.name = (NSString *)[dict objectForKey:@"name"];
    friendInfo.basicInformation = [dict objectForKey:@"basicInformation"];
    friendInfo.avatar = [dict objectForKey:@"avatar"];

    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        return FALSE;
    }
    return TRUE;
}

//Query friend info from database
- (NSArray *)queryFriendInfo{
    NSError *error;
    
    //Fetch result
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"FriendInfo" inManagedObjectContext:[self managedObjectContext] ];
    [fetchRequest setEntity:entity];
    
    NSArray *result = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
//    for( FriendInfo *info in result ){
//        NSLog(@"%@ %@", info.id, info.name);
//    }
    return result;
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
