//
//  TopicListTableViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "TopicListTableViewController.h"
#import "PostListViewController.h"
#import "NewPostViewController.h"
#import "TopicCell.h"
#import "CCTopicEntity.h"
#import "SVPullToRefresh.h"
#import "CC98API.h"
#import "CC98Store.h"
#import "CC98Parser.h"
#import "MBProgressHUD.h"
#import "GAI.h"

@interface TopicListTableViewController ()

@end

@implementation TopicListTableViewController
@synthesize boardInfo;
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
    
    [[[GAI sharedInstance] defaultTracker] sendView:@"TopicList Screen"];
    
    UIButton *newpostButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [newpostButton addTarget:self action:@selector(newpostButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [newpostButton setBackgroundImage:[UIImage imageNamed:@"newpost"] forState:UIControlStateNormal];
    UIBarButtonItem *newpostButtonItem = [[UIBarButtonItem alloc] initWithCustomView:newpostButton];
    [self.navigationItem setRightBarButtonItem:newpostButtonItem];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = boardInfo.boardName;
    
    items = [[CC98Store sharedInstance] getTopicListWithBoardId:boardInfo.boardId];
    //currPageNum = [[CC98Store sharedInstance] getTopicListMaxPageNumWithBoardId:boardInfo.boardId] + 1;
    
    
    //NSLog(@"%d", currPageNum);
    __weak TopicListTableViewController *weakSelf = self;
    
    // setup pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.currPageNum = 1;
        
        [[CC98API sharedInstance] getTopicListWithBoardId:weakSelf.boardInfo.boardId pageNum:weakSelf.currPageNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
            weakSelf.items = [[CC98Parser sharedInstance] parseTopicList:responseObject boardId:weakSelf.boardInfo.boardId];
            weakSelf.totalPageNum = [[CC98Parser sharedInstance] parseTotalPageNumInTopicList:responseObject];
            if (weakSelf.totalPageNum == 1) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            } else {
                weakSelf.tableView.showsInfiniteScrolling = YES;
            }
            //NSLog(@"%d", weakSelf.totalPageNum);
            [[CC98Store sharedInstance] updateTopicListWithEntity:weakSelf.items boardId:weakSelf.boardInfo.boardId pageNum:weakSelf.currPageNum];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            weakSelf.currPageNum++;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //NSLog(@"%@", error);
            [weakSelf.tableView.pullToRefreshView stopAnimating];
        }];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        [[CC98API sharedInstance] getTopicListWithBoardId:weakSelf.boardInfo.boardId pageNum:weakSelf.currPageNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
            weakSelf.currPageNum++;
            if (weakSelf.currPageNum > weakSelf.totalPageNum) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }
            //NSLog(@"%d", weakSelf.currPageNum);
            NSMutableArray *array = [[CC98Parser sharedInstance] parseTopicList:responseObject boardId:weakSelf.boardInfo.boardId];
            [[CC98Store sharedInstance] updateTopicListWithEntity:array boardId:weakSelf.boardInfo.boardId pageNum:weakSelf.currPageNum];
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
    static NSString *CellIdentifier = @"TopicCell";
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //NSLog(@"cell != nil");
    // Configure the cell...
    if (cell == nil) {
        //NSLog(@"cell == nil");
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    CCTopicEntity *topicEntity = [items objectAtIndex:indexPath.row];
    cell.title.text = topicEntity.topicName;
    cell.author.text = [NSString stringWithFormat:@"作者：%@", topicEntity.topicAuthor];
    cell.lastReply.text = [NSString stringWithFormat:@"最后回复：%@", topicEntity.lastReplyAuthor];
    cell.numberStat.text = topicEntity.replyNum;
    
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
    CCTopicEntity *entity = [items objectAtIndex:indexPath.row];
    
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    PostListViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"PostList"];
    
    nextViewController.topicId = entity.topicId;
    nextViewController.boardId = entity.boardId;
    nextViewController.topicName = entity.topicName;
    
    [self.navigationController pushViewController:nextViewController animated:YES];
}

- (IBAction)newpostButtonClicked:(id)sender
{
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    NewPostViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"NewPost"];
    nextViewController.boardId = boardInfo.boardId;
    nextViewController.postMode = 2;
    [self presentViewController:nextViewController animated:YES completion:nil];
}

@end
