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

@interface BNMainViewController ()

@property NSArray *friendInfoArray;
@property NSArray *tableCellColor;

@end

@implementation BNMainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableView:) name:@"updateTableView" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateTableView:(NSNotification *)notis{
    self.friendInfoArray = [BNCoreDataHelper queryFriendInOfEntity:@"FriendInfo" managedObjectContext:self.managedObjectContext];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.friendInfoArray = self.friendInfoArray = [BNCoreDataHelper queryFriendInOfEntity:@"FriendInfo" managedObjectContext:self.managedObjectContext];;
    self.tableCellColor = [NSArray arrayWithObjects:@"f39c12", @"d35400", @"c0392b", @"e74c3c", @"e67e22", @"f1c40f", nil];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar setBarTintColor:[BNUtilities colorWithHexString:@"c0392b"]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(actionBarButtonItemWasPressed)];
    NSArray *actionButtonItems = @[menuItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    //Change table view background color
    self.tableView.backgroundColor = [BNUtilities colorWithHexString:@"34495e"];
}

- (void)actionBarButtonItemWasPressed {
    [self performSegueWithIdentifier:@"SettingViewController" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.friendInfoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Main Cell" forIndexPath:indexPath];
    
    FriendInfo *info = self.friendInfoArray[indexPath.row];
    
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [(NSDictionary *)info.basicInformation objectForKey:@"birthday"];
    
    //Give cell a random color from the array
    int randNum = (int)(indexPath.row % (self.tableCellColor.count - 1));
    cell.backgroundColor = [BNUtilities colorWithHexString:self.tableCellColor[randNum]];
    
    return cell;
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
    if ([segue.destinationViewController isKindOfClass:[BNSettingViewController class]]) {
        [(BNSettingViewController *)segue.destinationViewController setManagedObjectContext:self.managedObjectContext];
    }
}


@end
