//
//  BNMainViewController.m
//  BirthdayNotification
//
//  Created by Liu Weilong on 2/8/14.
//  Copyright (c) 2014 Liu Weilong. All rights reserved.
//

#import "BNMainViewController.h"
#import "BNSettingViewController.h"
#import "BNUtilities.h"
#import "BNCoreDataHelper.h"
#import "FriendInfo.h"
#import "BNFriendDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "BNFriendsDetail.h"
#import "BNMainView.h"

@interface BNMainViewController ()

@property (strong, nonatomic) IBOutlet BNMainView *mainView;
@property (strong, nonatomic) IBOutlet UIButton *upButton;

@end

@implementation BNMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:@"updateTableView" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateTableView:(NSNotification *)notis{
    [BNFriendsDetail sharedFriendsDetail].friendsDetail = [BNCoreDataHelper queryFriendInOfEntity:[FriendInfo entityName] managedObjectContext:[FriendInfo managedObjectContext]];
    [self resetTableViewOffsetWithAnimate:YES];
    [self.mainView.mainTableView reloadData];
}

- (IBAction)upButtonClicked:(id)sender {
    [self resetTableViewOffsetWithAnimate:YES];
}

- (void)resetTableViewOffsetWithAnimate:(BOOL)animated {
    int offset = 20+self.navigationController.navigationBar.frame.size.height-self.mainView.searchBar.frame.size.height;
    [self.mainView.mainTableView setContentOffset:CGPointMake(0, -offset) animated:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Data related setup
   
    [BNFriendsDetail sharedFriendsDetail].friendsDetail = [BNCoreDataHelper queryFriendInOfEntity:[FriendInfo entityName] managedObjectContext:[FriendInfo managedObjectContext]];
    NSLog(@"%d", [[BNFriendsDetail sharedFriendsDetail].friendsDetail count]);
    
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [BNUtilities colorWithHexString:@"34495e"];
    
    [self.mainView loadViewWithModel:[BNFriendsDetail sharedFriendsDetail] searchDisplauController:self.searchDisplayController];
    //Navigation bar apperance setting
    self.title = @"森日";
    [self.navigationController.navigationBar setBarTintColor:[BNUtilities colorWithHexString:@"c0392b"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionBarButtonItemWasPressed)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleSearchController)];
    
    NSArray *actionButtonItems = @[menuItem, searchItem, ];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:23.0], NSFontAttributeName, nil]];
}

- (void)toggleSearchController {
    int offset =20 + self.navigationController.navigationBar.frame.size.height;
    [self.mainView.mainTableView setContentOffset:CGPointMake(0, -offset) animated:NO];
    [self.mainView.searchBar becomeFirstResponder];
}

- (void)actionBarButtonItemWasPressed {
    [self performSegueWithIdentifier:@"SettingViewController" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [[BNFriendsDetail sharedFriendsDetail].filteredFriendsDetail removeAllObjects];
    // Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    [BNFriendsDetail sharedFriendsDetail].filteredFriendsDetail = [NSMutableArray arrayWithArray:[[BNFriendsDetail sharedFriendsDetail].friendsDetail filteredArrayUsingPredicate:predicate]];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[BNSettingViewController class]]) {
    }
}


@end
