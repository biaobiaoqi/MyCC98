//
//  PostListViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/22/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "PostListViewController.h"
#import "PostCell.h"
#import "CC98API.h"
#import "CC98Store.h"
#import "PostEntity.h"

@interface PostListViewController ()

@end

@implementation PostListViewController
@synthesize topicInfo;
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
    self.navigationItem.title = topicInfo.topicName;
    
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
	//[_refreshHeaderView refreshLastUpdatedDate];
    
    [self loadTableViewDataSource];
}

-(void)prevPageButtonPressed {
    currPageNum--;
    [self loadTableViewDataSource];
}

-(void)nextPageButtonPressed {
    currPageNum++;
    [self loadTableViewDataSource];
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
    //NSLog(@"%@", [items objectAtIndex:indexPath.row]);
    PostEntity *entity = [items objectAtIndex:indexPath.row];
    cell.content.text = entity.postContent;
    cell.author.text = entity.postAuthor;
    CGSize maximumLabelSize = CGSizeMake(280, FLT_MAX);
    
    CGSize expectedLabelSize = [cell.content.text sizeWithFont:cell.content.font constrainedToSize:maximumLabelSize lineBreakMode:cell.content.lineBreakMode];
    
    //adjust the label the the new height.
    CGRect newFrame = cell.content.frame;
    newFrame.size.height = expectedLabelSize.height;
    cell.content.frame = newFrame;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostCell *cell = (PostCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.content.frame.size.height + 40;
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

- (void)loadTableViewDataSource
{
    if (currPageNum == 1) {
        [self.toolbar1 setHidden:NO];
        [self.toolbar2 setHidden:YES];
    }
    else {
        [self.toolbar1 setHidden:YES];
        [self.toolbar2 setHidden:NO];
    }
    //items = [[CC98Store sharedInstance] getPostListWithBoardId:topicInfo.boardId topicId:topicInfo.topicId pageNum:currPageNum];
    totalPageNum = topicInfo.topicPageNum;
    //if (items.count == 0) {
        [self reloadTableViewDataSource];
        //NSLog(@"Loading Topic List From Web");
    //}
    //else {
    //    [self doneLoadingTableViewData];
        //[self.tableView reloadData];
    //    NSLog(@"Loaded Post List From DB");
    //}
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
    NSLog(@"Loading Topic List From Web");
    if (currPageNum == 1) {
        [self.toolbar1 setHidden:NO];
        [self.toolbar2 setHidden:YES];
    }
    else {
        [self.toolbar1 setHidden:YES];
        [self.toolbar2 setHidden:NO];
    }
    
    NSLog(@"Starting GET ===");
	[[CC98API sharedInstance] getPath:[[CC98UrlManager alloc] getTopicPathWithBoardId:topicInfo.boardId topicId:topicInfo.topicId pageNum:currPageNum] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"GET succeed! ===");
        //NSString *webcontent = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", webcontent);
        NSMutableArray *array = [[CC98Parser alloc] parsePostList:responseObject];
        //NSLog(@"%@====", array);
        items = array;
        [self doneLoadingTableViewData];
        //NSLog(@"%@", items);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];

    
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
	currPageNum = 1;
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
