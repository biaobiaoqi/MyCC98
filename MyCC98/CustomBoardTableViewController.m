//
//  CustomBoardTableViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "CustomBoardTableViewController.h"
#import "CC98API.h"
#import "CC98Store.h"
#import "BoardEntity.h"
#import "TopicListViewController.h"
#import "BoardCell.h"

@interface CustomBoardTableViewController ()

@end

@implementation CustomBoardTableViewController
@synthesize items;

/*- (void)awakeFromNib
{
    [[CC98API sharedInstance] getPath:[[CC98UrlManager alloc] getIndexPath] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *webcontent = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableArray *boardlist = [[CC98Parser alloc] parseCustomBoardList:webcontent];
        items = [[NSMutableArray alloc] init];
        for (BoardEntity *entity in boardlist) {
            [items addObject:[entity getBoardName]];
        }
        [self.tableView reloadData];
        //NSLog(@"%@", items);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    //self.items = [NSArray arrayWithObjects:@"One", @"Two", @"Three", nil];
}*/

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
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		
	}
	
	//  update the last update date
	//[_refreshHeaderView refreshLastUpdatedDate];
    
    //[self reloadTableViewDataSource];
    [self loadTableViewDataSource];
    //[self.navigationController setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
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
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"BoardCell"];
    BoardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[BoardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.title.text = [[items objectAtIndex:indexPath.row] getBoardName];
    cell.postNum.text = [NSString stringWithFormat:@"今日贴数：%d", [[items objectAtIndex:indexPath.row] getPostNumberToday]];
    cell.intro.text = [[items objectAtIndex:indexPath.row] getBoardIntro];
    cell.lastReply.text = [NSString stringWithFormat:@"最后回复：%@", [[items objectAtIndex:indexPath.row] getLastReplyAuthor]];
    
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
    
    BoardEntity *entity = [items objectAtIndex:indexPath.row];
    
    UIStoryboard *board=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    TopicListViewController *nextViewController =[board instantiateViewControllerWithIdentifier:@"TopicList"];
    
    nextViewController.boardInfo = entity;
    
    [self.navigationController pushViewController:nextViewController animated:YES];
    //[self performSegueWithIdentifier:@"postList" sender:self];
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)loadTableViewDataSource
{
    //NSLog(@"");
    items = [[CC98Store sharedInstance] getCustomBoard];
    if (items.count == 0) {
        [self reloadTableViewDataSource];
        NSLog(@"Loading Custom Board List From Web");
    }
    else {
        [self.tableView reloadData];
        NSLog(@"Loaded Custom Board List From DB");
    }
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	_reloading = YES;
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    [[CC98API sharedInstance] getPath:[[CC98UrlManager alloc] getIndexPath] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *webcontent = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSMutableArray *boardlist = [[CC98Parser alloc] parseCustomBoardList:webcontent];
        [[CC98Store sharedInstance] updateCustomBoard:boardlist];
        items = [[CC98Store sharedInstance] getCustomBoard];
        [self doneLoadingTableViewData];
        //NSLog(@"%@", items);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)doneLoadingTableViewData
{
	
	//  model should call this when its done loading
    [self.tableView reloadData];
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
