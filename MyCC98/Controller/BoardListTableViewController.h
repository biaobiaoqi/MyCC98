//
//  BoardListTableViewController.h
//  MyCC98
//
//  Created by Yan Chen on 1/26/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoardListTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *allBoards;
@property (nonatomic, strong) NSArray *allBoardsSearchResults;
@property (nonatomic, strong) NSMutableArray *personalBoards;
@property (nonatomic, strong) NSArray *personalBoardsSearchResults;
@property (nonatomic, strong) NSArray *sections;

- (IBAction)revealMenu:(id)sender;

@end
