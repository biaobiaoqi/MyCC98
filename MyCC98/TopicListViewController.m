//
//  TopicListViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/22/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "TopicListViewController.h"
#import "CC98API.h"
#import "CC98Store.h"
#import "TopicCell.h"
#import "TopicEntity.h"

@interface TopicListViewController ()

@end

@implementation TopicListViewController
@synthesize boardInfo;
@synthesize items;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationItem.title = [boardInfo getBoardName];
    
    self.prevPage2.action = @selector(prevPageButtonPressed);
    self.nextPage1.action = @selector(nextPageButtonPressed);
    self.nextPage2.action = @selector(nextPageButtonPressed);
    
    if (currPageNum == 0) {
        currPageNum = 1;
    }
    
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    [self reloadTableViewDataSource];
    //currPageNum = 1;
    
}

-(void)prevPageButtonPressed {
    currPageNum--;
    [self reloadTableViewDataSource];
}

-(void)nextPageButtonPressed {
    currPageNum++;
    [self reloadTableViewDataSource];
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
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    TopicEntity *entity = [items objectAtIndex:indexPath.row];
    cell.title.text = entity.topicName;
    cell.author.text = [NSString stringWithFormat:@"作者：%@", entity.topicAuthor];
    cell.lastReply.text = [NSString stringWithFormat:@"最后回复：%@", entity.lastReplyAuthor];
    cell.numberStat.text = entity.replyNum;
    return cell;
}


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

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    if (currPageNum == 1) {
        [self.toolbar1 setHidden:NO];
        [self.toolbar2 setHidden:YES];
    }
    else {
        [self.toolbar1 setHidden:YES];
        [self.toolbar2 setHidden:NO];
    }
    
	[[CC98API sharedInstance] getPath:[[CC98UrlManager alloc] getBoardPathWithBoardId:[boardInfo getBoardId] pageNum:currPageNum] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *webcontent = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", webcontent);
        NSMutableArray *postlist = [[CC98Parser alloc] parsePostList:webcontent];
        totalPageNum = [[CC98Parser alloc] parsePostListTotalPageNum:responseObject];
        //NSLog(@"%d", postlist.count);
        [[CC98Store sharedInstance] updateTopicListWithEntity:postlist boardId:[boardInfo getBoardId] pageNum:currPageNum];
        items = [[CC98Store sharedInstance] getTopicListWithBoardId:[boardInfo getBoardId] pageNum:currPageNum];
        //NSLog(@"%d", items.count);
        [self doneLoadingTableViewData];
        //NSLog(@"%@", items);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData
{
	
	//  model should call this when its done loading
    [self.tableView reloadData];
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    self.pageLabel1.title = [NSString stringWithFormat:@"%d/%d", currPageNum, totalPageNum];
    self.pageLabel2.title = [NSString stringWithFormat:@"%d/%d", currPageNum, totalPageNum];
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	
	[self reloadTableViewDataSource];
	//[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


@end
