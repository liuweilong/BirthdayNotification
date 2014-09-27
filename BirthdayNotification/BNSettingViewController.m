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


static NSString *const SettingTablViewCellIdentifier = @"Cell";

@interface BNSettingViewController ()

@property (strong, nonatomic) IBOutlet BNSettingView *settingView;

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
    [self setupSettingView];
}

- (void)setupSettingView {
    TableViewCellSelectionBlock cellSelectionBlock = ^(NSIndexPath *indexPath) {
        switch (indexPath.row) {
            case 0:
                [[BNRennService sharedRennService] toggleLoginStatus];
                break;
            case 1:
                [BNCoreDataHelper clearAnEntity:@"FriendInfo" managedObjectContext:[FriendInfo managedObjectContext]];
                [[BNRennService sharedRennService] requestRennFriendsDetail];
                break;
                
            default:
                break;
        }
    };
    NSLog(@"setting view setup");
    [self.settingView loadWithTableViewCellSelectionBlock:cellSelectionBlock delegate:self];
}

#pragma mark - BNRennServiceDelegate
- (void)loginSuccess {
    [self.settingView.settingTableView changeCellStyleAfterLogin];
    [[BNRennService sharedRennService] requestRennFriendsDetail];
}

- (void)logOutSuccess {
    [self.settingView.settingTableView changeCellStyleAfterLogout];
}

- (void)dataQueryingStarted {
    [self.settingView showAlertView];
}

- (void)dataQueryingFinished {
    [self.settingView dismissAlertView];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTableView" object:nil userInfo:nil];
    }];
}

- (void)dataQueryingFailed {
    [self.settingView showLoginAlert];
}

#pragma mark - BNSettingViewDelegate
- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
 

@end
