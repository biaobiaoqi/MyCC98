//
//  PostListTableViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/28/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "PostListViewController.h"
#import "NewPostViewController.h"
#import "WebViewController.h"
#import "PostCell.h"
#import "SVPullToRefresh.h"
#import "CC98Store.h"
#import "CCPostEntity.h"
#import "CC98API.h"
#import "CC98Parser.h"
#import "CC98UrlManager.h"
#import "MBProgressHUD.h"
#import "GAI.h"

@interface PostListViewController ()

@end

@implementation PostListViewController
//@synthesize topicInfo;
@synthesize topicId;
@synthesize boardId;
@synthesize topicName;
@synthesize items;
@synthesize currPageNum;
@synthesize totalPageNum;
@synthesize lastUpdateNum;
@synthesize refreshButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[[GAI sharedInstance] defaultTracker] sendView:@"PostList Screen"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = topicName;
    
    items = [[CC98Store sharedInstance] getPostListWithTopicId:topicId];
    currPageNum = [[CC98Store sharedInstance] getPostListMaxPageNumWithTopicId:topicId] + 1;
    lastUpdateNum = [[CC98Store sharedInstance] getPostListLastUpdateNumWithTopicId:topicId];
    //NSLog(@"lastupdate:%d", lastUpdateNum);
    __weak PostListViewController *weakSelf = self;
    
    // setup pull to refresh
    [self.tableView addPullToRefreshWithActionHandler:^{
        weakSelf.currPageNum = 1;
        
        [[CC98API sharedInstance] getPostListWithTopicId:weakSelf.topicId boardId:weakSelf.boardId pageNum:weakSelf.currPageNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            weakSelf.items = [[CC98Parser sharedInstance] parsePostList:responseObject boardId:weakSelf.boardId];
            NSMutableArray *insertion = [[NSMutableArray alloc] init];
            for (int i=0; i<weakSelf.items.count; ++i) {
                [insertion addObject:[NSIndexPath indexPathForRow:i+weakSelf.items.count inSection:0]];
            }
            weakSelf.lastUpdateNum = [insertion count];
            weakSelf.totalPageNum = [[CC98Parser sharedInstance] parseTotalPageNumInPostList:responseObject];
            //NSLog(@"%d", weakSelf.totalPageNum);
            if (weakSelf.totalPageNum == 1) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            } else {
                weakSelf.tableView.showsInfiniteScrolling = YES;
            }
            weakSelf.refreshButton.hidden = NO;
            weakSelf.refreshButton.enabled = YES;
            
            [[CC98Store sharedInstance] updatePostListWithEntity:weakSelf.items topicId:weakSelf.topicId pageNum:weakSelf.currPageNum];
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
        [[CC98API sharedInstance] getPostListWithTopicId:weakSelf.topicId boardId:weakSelf.boardId pageNum:weakSelf.currPageNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
            weakSelf.currPageNum++;
            if (weakSelf.currPageNum > weakSelf.totalPageNum) {
                weakSelf.tableView.showsInfiniteScrolling = NO;
            }
            //NSLog(@"%d", weakSelf.currPageNum);
            NSMutableArray *array = [[CC98Parser sharedInstance] parsePostList:responseObject boardId:weakSelf.boardId];
            [[CC98Store sharedInstance] updatePostListWithEntity:array topicId:weakSelf.topicId pageNum:weakSelf.currPageNum-1];
            //NSLog(@"%d", array.count);
            NSMutableArray *insertion = [[NSMutableArray alloc] init];
            for (int i=0; i<array.count; ++i) {
                [insertion addObject:[NSIndexPath indexPathForRow:i+weakSelf.items.count inSection:0]];
            }
            [weakSelf.items addObjectsFromArray:array];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView endUpdates];
            weakSelf.lastUpdateNum = [insertion count];
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
    static NSString *CellIdentifier = @"PostCell";
    PostCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CCPostEntity *entity = [items objectAtIndex:indexPath.row];
    
    [cell setUBBCode:entity rowNum:indexPath.row];
    cell.controller = self;
    
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
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复", @"引用", @"查看网页", nil];
    actionsheet.tag = indexPath.row;
    [actionsheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%d", buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            NewPostViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"NewPost"];
            CCPostEntity *postEntity = [items objectAtIndex:0];
            //CCTopicEntity *topicEntity = topicInfo;
            nextViewController.postEntity = postEntity;
            nextViewController.boardId = boardId;
            nextViewController.topicId = topicId;
            //nextViewController.topicEntity = topicEntity;
            nextViewController.postMode = 0;
            //nextViewController.preContent = [NSString stringWithFormat:@"[quotex][b]以下是引用[i]%@在*****[/i]的发言：[/b]\n%@\n[/quotex]\n", entity.postAuthor, entity.postContent];
            [self presentViewController:nextViewController animated:YES completion:nil];
        }
            break;
        case 1:
        {
            UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            NewPostViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"NewPost"];
            CCPostEntity *postEntity = [items objectAtIndex:actionSheet.tag];
            //CCTopicEntity *topicEntity = topicInfo;
            nextViewController.postEntity = postEntity;
            nextViewController.boardId = boardId;
            nextViewController.topicId = topicId;
            nextViewController.postMode = 1;
            //nextViewController.preContent = [NSString stringWithFormat:@"[quotex][b]以下是引用[i]%@在*****[/i]的发言：[/b]\n%@\n[/quotex]\n", entity.postAuthor, entity.postContent];
            [self presentViewController:nextViewController animated:YES completion:nil];
        }
            break;
        case 2:
        {
            UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            WebViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"WebView"];
            //[nextViewController.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
            //[self presentViewController:nextViewController animated:YES completion:nil];
            nextViewController.url = [[CC98API sharedInstance] urlFromBoardId:boardId topicId:topicId pageNum:@""];
            [self.navigationController pushViewController:nextViewController animated:YES];
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = (PostCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (IBAction)refreshButtonClicked:(id)sender
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在更新...";
    self.currPageNum--;
    //NSLog(@"pagenum: %d", self.currPageNum);
    self.tableView.showsInfiniteScrolling = YES;
    [[CC98API sharedInstance] getPostListWithTopicId:self.topicId boardId:self.boardId pageNum:self.currPageNum success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.currPageNum++;
        self.totalPageNum = [[CC98Parser sharedInstance] parseTotalPageNumInPostList:responseObject];
        //NSLog(@"pagenum: %d/%d", self.currPageNum, self.totalPageNum);
        if (self.currPageNum > self.totalPageNum) {
            self.tableView.showsInfiniteScrolling = NO;
        }
        //NSLog(@"%d", weakSelf.currPageNum);
        NSMutableArray *array = [[CC98Parser sharedInstance] parsePostList:responseObject boardId:self.boardId];
        if ([array count] == lastUpdateNum) {
            //NSLog(@"equal");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            //NSLog(@"notequal");
            
            for (int i=0; i<lastUpdateNum; ++i) {
                [array removeObjectAtIndex:0];
            }
            [[CC98Store sharedInstance] updatePostListWithEntity:array topicId:self.topicId pageNum:self.currPageNum-1];
            //NSLog(@"%d", array.count);
            NSMutableArray *insertion = [[NSMutableArray alloc] init];
            for (int i=0; i<array.count; ++i) {
                [insertion addObject:[NSIndexPath indexPathForRow:i+self.items.count inSection:0]];
            }
            //NSLog(@"insert num: %d", [insertion count]);
            [self.items addObjectsFromArray:array];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:insertion withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            lastUpdateNum = [array count] + lastUpdateNum;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[self.tableView.infiniteScrollingView stopAnimating];
        //[MBProgressHUD hideHUDForView:weakSelf.navigationController.view animated:YES];
    }];

}

@end
