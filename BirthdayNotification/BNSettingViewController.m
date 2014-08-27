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
#import "BNRennService.h"

@interface BNSettingViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *quitButton;
@property (strong, nonatomic) UIAlertView *waitAlert;

@end

@implementation BNSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [BNRennService sharedRennService].delegate = self;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.view bringSubviewToFront:self.quitButton];
    
    //Alert init
    self.waitAlert = [[UIAlertView alloc] initWithTitle:@"等等等..." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
    self.waitAlert.cancelButtonIndex = -1;
    
    //TableView setting
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    //Change table view background color
    self.tableView.backgroundColor = [BNUtilities colorWithHexString:@"34495e"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    switch (indexPath.row) {
        case 0:
            if ([[BNRennService sharedRennService] isLogin]) {
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
            [[BNRennService sharedRennService] toggleLoginStatus];
            break;
        case 1:
            [BNCoreDataHelper clearAnEntity:@"FriendInfo" managedObjectContext:self.managedObjectContext];
            [[BNRennService sharedRennService] requestRennFriendsDetail];
            break;
            
        default:
            break;
    }
}

- (void)loginSuccess {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.backgroundColor = [BNUtilities colorWithHexString:@"95a5a6"];
    cell.textLabel.text = @"解除人人链接";
    [[BNRennService sharedRennService] requestRennFriendsDetail];
}

- (void)logOutSuccess {
    UITableViewCell *cell = (UITableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.backgroundColor = [BNUtilities colorWithHexString:@"16a085"];
    cell.textLabel.text = @"链接到人人";
}

- (void)dataQueryingStarted {
    [self.waitAlert show];
}

- (void)dataQueryingFinished {
    NSLog(@"Query finished");
    [self.waitAlert dismissWithClickedButtonIndex:-1 animated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTableView" object:nil userInfo:nil];
    }];
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
 {tr
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
