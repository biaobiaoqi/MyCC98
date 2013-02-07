//
//  BoardListTableViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/26/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "BoardListTableViewController.h"
#import "ECSlidingViewController.h"
#import "TopicListTableViewController.h"
#import "SVPullToRefresh.h"
#import "CCBoardEntity.h"
#import "MBProgressHUD.h"
#import "CC98Store.h"
#import "CC98API.h"
#import "CC98Parser.h"

@interface BoardListTableViewController ()

@end

@implementation BoardListTableViewController
@synthesize sections;
@synthesize personalBoards;
@synthesize personalBoardsSearchResults;
@synthesize allBoards;
@synthesize allBoardsSearchResults;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    personalBoards = [[CC98Store sharedInstance] getPersonalBoardList];
    allBoards = [[CC98Store sharedInstance] getAllBoardList];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    sections = [NSArray arrayWithObjects:@"个人定制区",@"所有版块", nil];
    //personalBoards = [NSMutableArray arrayWithObjects:@"缘分",@"校园", nil];
    //allBoards = [NSMutableArray arrayWithObjects:@"ccc",@"校园信息",@"eee",@"a", @"b",@"c",@"d",@"e", nil];
    
    __weak BoardListTableViewController *weakSelf = self;
    
    //MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //hud.mode = MBProgressHUDModeCustomView;
    //hud.labelText = @"Loading";
    
    
    // setup pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:weakSelf.navigationController.view animated:YES];
        //hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = @"Loading";
        [[CC98API sharedInstance] getBoardStatWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            weakSelf.allBoards = [[CC98Parser sharedInstance] parseAllBoardList:responseObject];
            [[CC98Store sharedInstance] updateAllBoardList:weakSelf.allBoards];
            [[CC98API sharedInstance] getIndexWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                weakSelf.personalBoards = [[CC98Parser sharedInstance] parsePersonalBoardList:responseObject];
                [[CC98Store sharedInstance] updatePersonalBoardList:weakSelf.personalBoards];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.pullToRefreshView stopAnimating];
                [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"%@", error);
                if (error.code == -1001) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接超时"  message:nil
                                                                   delegate:weakSelf cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                }
                [weakSelf.tableView.pullToRefreshView stopAnimating];
                [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
            }];
            //NSLog(@"pull refre");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            if (error.code == -1001) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接超时"  message:nil
                                                               delegate:weakSelf cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            [MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        }];
    }];
    
    
    /*if (allBoards.count == 0) {
        [self.tableView triggerPullToRefresh];
    }*/
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"SELF.boardName contains[cd] %@",
                                    searchText];
    
    allBoardsSearchResults = [allBoards filteredArrayUsingPredicate:resultPredicate];
    personalBoardsSearchResults = [personalBoards filteredArrayUsingPredicate:resultPredicate];
}

//search display delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (section == 0) {
            return personalBoardsSearchResults.count;
        } else {
            return allBoardsSearchResults.count;
        }
    } else {
        if (section == 0) {
            return personalBoards.count;
        } else {
            return allBoards.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BoardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (indexPath.section == 0) {
            CCBoardEntity *entity = [personalBoardsSearchResults objectAtIndex:indexPath.row];
            cell.textLabel.text = entity.boardName;
        } else {
            CCBoardEntity *entity = [allBoardsSearchResults objectAtIndex:indexPath.row];
            cell.textLabel.text = entity.boardName;
        }
    } else {
        if (indexPath.section == 0) {
            CCBoardEntity *entity = [personalBoards objectAtIndex:indexPath.row];
            cell.textLabel.text = entity.boardName;
        } else {
            CCBoardEntity *entity = [allBoards objectAtIndex:indexPath.row];
            cell.textLabel.text = entity.boardName;
        }
    }
    
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sections objectAtIndex:section];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CCBoardEntity *entity;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (indexPath.section == 0) {
            entity = [personalBoardsSearchResults objectAtIndex:indexPath.row];
        } else {
            entity = [allBoardsSearchResults objectAtIndex:indexPath.row];
        }
    } else {
        if (indexPath.section == 0) {
            entity = [personalBoards objectAtIndex:indexPath.row];
        } else {
            entity = [allBoards objectAtIndex:indexPath.row];
        }
    }
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    TopicListTableViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"TopicList"];
    
    nextViewController.boardInfo = entity;
    
    [self.navigationController pushViewController:nextViewController animated:YES];
}



@end
