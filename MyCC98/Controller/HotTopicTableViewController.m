//
//  HotTopicTableViewController.m
//  MyCC98
//
//  Created by Yan Chen on 2/25/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "HotTopicTableViewController.h"
#import "ECSlidingViewController.h"
#import "PostListViewController.h"
#import "SVPullToRefresh.h"
#import "CC98API.h"
#import "CC98Parser.h"
#import "CC98Store.h"
#import "CCHotTopicEntity.h"
#import "HotTopicCell.h"
#import "GAI.h"

@interface HotTopicTableViewController ()

@end

@implementation HotTopicTableViewController
@synthesize items;

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
    [[[GAI sharedInstance] defaultTracker] sendView:@"HotTopic Screen"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"热门话题";
    
    items = [[CC98Store sharedInstance] getHotTopic];
    //currPageNum = [[CC98Store sharedInstance] getTopicListMaxPageNumWithBoardId:boardInfo.boardId] + 1;
    
    
    //NSLog(@"%d", currPageNum);
    __weak HotTopicTableViewController *weakSelf = self;
    
    // setup pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        [[CC98API sharedInstance] getHotTopicListWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            weakSelf.items = [[CC98Parser sharedInstance] parseHottopicList:responseObject];
            //NSLog(@"items num: %d", weakSelf.items.count);
            [[CC98Store sharedInstance] updateHotTopic:weakSelf.items];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }];
    }];
    
    if (items.count == 0) {
        [self.tableView triggerPullToRefresh];
    }
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
    static NSString *CellIdentifier = @"HotTopicCell";
    HotTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[HotTopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    CCHotTopicEntity *topicEntity = [items objectAtIndex:indexPath.row];
    cell.title.text = topicEntity.topicName;
    cell.author.text = [NSString stringWithFormat:@"作者：%@", topicEntity.postAuthor];
    cell.boardname.text = [NSString stringWithFormat:@"版块：%@", topicEntity.boardName];
    //NSLog(@"boardId %@", topicEntity.boardId);
    
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
    CCHotTopicEntity *entity = [items objectAtIndex:indexPath.row];
    
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    PostListViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"PostList"];
    
    nextViewController.topicId = entity.topicId;
    nextViewController.boardId = entity.boardId;
    nextViewController.topicName = entity.topicName;
    
    [self.navigationController pushViewController:nextViewController animated:YES];
}


- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

@end
