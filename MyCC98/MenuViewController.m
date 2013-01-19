//
//  MenuViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/18/13.
//  Copyright (c) 2013 Zhejiang University. All rights reserved.
//

#import "MenuViewController.h"
#import "CC98Store.h"
#import "CC98API.h"
#import "UIImageView+AFNetworking.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
@synthesize menuItems;

- (void)awakeFromNib
{
    self.menuItems = [NSArray arrayWithObjects:@"个人定制区", @"热门话题", nil];
}

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
    
    customBoard = (UINavigationController*)self.slidingViewController.topViewController;
    //menuTable.layer.borderWidth = 2.0;
    //menuTable.layer.borderColor = [UIColor whiteColor].CGColor;
    //[avatarImage setImageWithURL:[NSURL URLWithString: @"http://file.cc98.org/uploadface/348191.png"]];
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    [profile setTitle:username forState:UIControlStateNormal];
    [[CC98API sharedInstance] getPath:[[CC98UrlManager alloc] getUserProfilePath:username] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *webcontent = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSString *avatarUrl = [[CC98Parser alloc] parseUserProfile:webcontent];
        [avatarImage setImageWithURL:[NSURL URLWithString:avatarUrl]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSString *identifier; // = [self.menuItems objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
            if (customBoard == nil) {
                customBoard = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomBoard"];
            }
            [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = customBoard;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];
            }];
        }
            break;
        case 1:
        {
            if (hotTopic == nil) {
                hotTopic = [self.storyboard instantiateViewControllerWithIdentifier:@"HotTopic"];
            }
            [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
                CGRect frame = self.slidingViewController.topViewController.view.frame;
                self.slidingViewController.topViewController = hotTopic;
                self.slidingViewController.topViewController.view.frame = frame;
                [self.slidingViewController resetTopView];
            }];
        }
            break;
        default:
            //identifier = @"CustomBoard";
            break;
    }
    
    //UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    
    
}

-(IBAction)logout:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:[NSDictionary dictionary] forName:[[NSBundle mainBundle] bundleIdentifier]];
    [self performSegueWithIdentifier:@"logout" sender:self];
}


@end
 