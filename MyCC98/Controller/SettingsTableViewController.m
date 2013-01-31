//
//  SettingsTableViewController.m
//  MyCC98
//
//  Created by Yan Chen on 1/27/13.
//  Copyright (c) 2013 YANN. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "RVPNSwitchCell.h"
#import "CC98API.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                NSString *CellIdentifier = @"RVPNCodeCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }

                //cell.textLabel.text = @"RVPN Code";
                cell.detailTextLabel.text = rvpnCode;
                return cell;
            }
                break;
            case 1:
            {
                NSString *CellIdentifier = @"RVPNSwitchCell";
                RVPNSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[RVPNSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                //cell.textLabel.text = @"RVPN Switch";
                cell.sw.on = isRVPN;
                [cell.sw addTarget:self action:@selector(switchRVPN:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }
                break;
            default:
            {
                return nil;
            }
                break;
        }
    } else {
        return nil;
    }
}

- (void) switchRVPN:(id)sender
{
    isRVPN = ((UISwitch*) sender).on;
    if (isRVPN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注意"  message:@"请输入EasyConnect中获取的密钥"
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alert show];
    }
    else {
        
    }
}

#pragma mark - Alert View delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        //NSLog(@"Plain text input: %@",textField.text);
        if ([textField.text length] == 0) {
            NSLog(@"空值");
            return;
        } else {
            rvpnCode = textField.text;
            [[CC98API sharedInstance] setRVPN:YES key:rvpnCode];
            [self.tableView reloadData];
        }
    }
    else {
        isRVPN = NO;
        [[CC98API sharedInstance] setRVPN:NO key:nil];
        [self.tableView reloadData];
    }
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
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"RVPN设置";
    } else {
        return nil;
    }
}

@end
