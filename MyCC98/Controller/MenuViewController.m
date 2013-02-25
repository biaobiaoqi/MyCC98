//
//  MenuViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/26/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "MenuViewController.h"
#import "ECSlidingViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize sectionItems1;
@synthesize sectionItems2;
@synthesize sections;

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
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
    boardList = (UINavigationController*)self.slidingViewController.topViewController;
    
    sectionItems1 = [NSArray arrayWithObjects:@"版块列表", @"热门话题", nil];
    sectionItems2 = [NSArray arrayWithObjects:@"设置", @"关于", nil];
    sections = [NSArray arrayWithObjects:@"常用", @"更多", nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"menu appear");
    
    NSString *un = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    
    if (un == nil) {
        [profile setTitle:@"登陆" forState:UIControlStateNormal];
    } else {
        [profile setTitle:un forState:UIControlStateNormal];
        NSString *avatarurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatarurl"];
        [avatarImage setImageWithURL:[NSURL URLWithString:avatarurl]];
    }
    
    //profile.titleLabel.textColor = [UIColor whiteColor];
    //profile.titleLabel.text = @"fasda";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0) {
        return sectionItems1.count;
    } else {
        return sectionItems2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [sectionItems1 objectAtIndex:indexPath.row];
    } else {
        cell.textLabel.text = [sectionItems2 objectAtIndex:indexPath.row];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (boardList == nil) {
                        boardList = [self.storyboard instantiateViewControllerWithIdentifier:@"BoardList"];
                    }
                    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                        CGRect frame = self.slidingViewController.topViewController.view.frame;
                        self.slidingViewController.topViewController = boardList;
                        self.slidingViewController.topViewController.view.frame = frame;
                        [self.slidingViewController resetTopView];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    if (settings == nil) {
                        settings = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
                    }
                    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                        CGRect frame = self.slidingViewController.topViewController.view.frame;
                        self.slidingViewController.topViewController = settings;
                        self.slidingViewController.topViewController.view.frame = frame;
                        [self.slidingViewController resetTopView];
                    }];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *HeaderString = nil;
    
    HeaderString = [sections objectAtIndex:section];
    
    UILabel *HeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    HeaderLabel.backgroundColor = [UIColor darkGrayColor];
    HeaderLabel.font = [UIFont systemFontOfSize:14];
    HeaderLabel.textColor = [UIColor whiteColor];
    HeaderLabel.text = HeaderString;
    
    return HeaderLabel;
}


- (IBAction)profileButtonClicked:(id)sender
{
    //NSLog(@"aaaa");
    NSString *un = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (un == nil) {
        [self performSegueWithIdentifier:@"Login" sender:self];
    } else {
        [self performSegueWithIdentifier:@"Profile" sender:self];
    }
}


@end
