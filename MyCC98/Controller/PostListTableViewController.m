//
//  PostListTableViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "PostListTableViewController.h"
#import "PostCell.h"
#import "SVPullToRefresh.h"
#import "CC98Store.h"
#import "CCPostEntity.h"
#import "CC98API.h"
#import "CC98Parser.h"

@interface PostListTableViewController ()

@end

@implementation PostListTableViewController
@synthesize topicInfo;
@synthesize items;
@synthesize currPageNum;
@synthesize totalPageNum;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = topicInfo.topicName;
    
    items = [[CC98Store sharedInstance] getPostListWithTopicId:topicInfo.topicId];
    //currPageNum = [[CC98Store sharedInstance] getPostListMaxPageNumWithTopicId:topicInfo.topicId] + 1;
    
    __weak PostListTableViewController *weakSelf = self;
    
    // setup pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.currPageNum = 1;
        
        [[CC98API sharedInstance] getPostListWithTopicId:weakSelf.topicInfo.topicId boardId:weakSelf.topicInfo.boardId pageNum:weakSelf.currPageNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            weakSelf.items = [[CC98Parser sharedInstance] parsePostList:responseObject];
            weakSelf.totalPageNum = [[CC98Parser sharedInstance] parseTotalPageNumInPostList:responseObject];
            //NSLog(@"%d", weakSelf.totalPageNum);
            if (weakSelf.totalPageNum == 1) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            } else {
                weakSelf.tableView.showsInfiniteScrolling = YES;
            }
            [[CC98Store sharedInstance] updatePostListWithEntity:weakSelf.items topicId:weakSelf.topicInfo.topicId pageNum:weakSelf.currPageNum];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            weakSelf.currPageNum++;
            //[MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"%@", error);
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            //[MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        }];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [[CC98API sharedInstance] getPostListWithTopicId:weakSelf.topicInfo.topicId boardId:weakSelf.topicInfo.boardId pageNum:weakSelf.currPageNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
            weakSelf.currPageNum++;
            if (weakSelf.currPageNum > weakSelf.totalPageNum) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }
            //NSLog(@"%d", weakSelf.currPageNum);
            NSMutableArray *array = [[CC98Parser sharedInstance] parsePostList:responseObject];
            [[CC98Store sharedInstance] updatePostListWithEntity:array topicId:weakSelf.topicInfo.topicId pageNum:weakSelf.currPageNum];
            //NSLog(@"%d", array.count);
            NSMutableArray *insertion = [[NSMutableArray alloc] init];
            for (int i=0; i<array.count; ++i) {
                [insertion addObject:[NSIndexPath indexPathForRow:i+weakSelf.items.count inSection:0]];
            }
            [weakSelf.items addObjectsFromArray:array];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView endUpdates];
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            //[MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
            [weakSelf.tableView.infiniteScrollingView stopAnimating];
            //[MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
        }];
    }];
    
    self.tableView.showsInfiniteScrolling = NO;
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
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostCell";
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CCPostEntity *entity = [items objectAtIndex:indexPath.row];
    
    [cell setUBBCode:entity rowNum:indexPath.row controller:self];
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = (PostCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

@end
