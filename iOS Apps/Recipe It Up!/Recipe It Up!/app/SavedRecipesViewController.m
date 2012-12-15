//
//  SavedRecipesViewController.m
//  app
//
//  Created by Mark Evans on 8/28/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import "SavedRecipesViewController.h"
#import "AppDelegate.h"
#import "CustomCell.h"
#import "AltDetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "AJNotificationView.h"
#import "Reachability.h"

@interface SavedRecipesViewController ()

@end

@implementation SavedRecipesViewController
@synthesize savedRecipesTable, savedArray, actView, actBtn, bgimg, savedDictionary;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Favorites";
        self.tabBarItem.image = [UIImage imageNamed:@"savedrecipe.png"];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(![self connected])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Connection Lost. Please check your connection. This application requires an active internet connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        
        NSLog(@"Not Connected to internet");
        [alert show];
    }
    else
    {
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [self loadTable];
        NSLog(@"view did %@", [appDel.products description]);
        
        if (appDel.products.count < 1)
        {
            [savedRecipesTable setHidden:true];
            [savedimg setHidden:false];
            self.navigationItem.rightBarButtonItem = nil;
            self.navigationItem.leftBarButtonItem = nil;
        }
        else
        {
            [savedRecipesTable setHidden:false];
            [savedimg setHidden:true];
            rightButton =[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleEdit)];
            self.navigationItem.rightBarButtonItem = rightButton;
            leftButton =[[UIBarButtonItem alloc]initWithTitle:@"Clear All" style:UIBarButtonItemStylePlain target:self action:@selector(clear:)];
            self.navigationItem.leftBarButtonItem = leftButton;
            [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0039 green:0.5176 blue:0.5725 alpha:0.78]];
        }
    }
    [super viewWillAppear:true];
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (IBAction)clear:(id)sender
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (test.count > 0)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"arr"];
        [appDel.products removeAllObjects];
        NSLog(@"from app del : %i",appDel.products.count);
        [self.savedRecipesTable reloadData];
        [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeRed title:@"Recipes have been cleared!" hideAfter:2.5f];
    }
    else
    {
        [AJNotificationView showNoticeInView:self.view type:AJNotificationTypeRed title:@"There are no recipes to clear!" hideAfter:2.5f];
    }
    if (appDel.products.count == 0)
    {
        [savedimg setHidden:false];
        [savedRecipesTable setHidden:true];
    }
}

- (void)viewDidLoad
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"navbar_blank.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)loadTable
{
    //[self.savedRecipesTable reloadData];
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    test = [defaults objectForKey:@"arr"];
    if (test.count < 1)
    {
        appDel.products = [[NSMutableArray alloc]init];
    }
    else
    {
        appDel.products = [[NSMutableArray alloc]initWithArray:test];
    }
    [self.savedRecipesTable reloadData];
}

-(void)toggleEdit
{
    [savedRecipesTable setEditing:!savedRecipesTable.editing animated:YES];
    
    if (savedRecipesTable.editing)
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:appDel.products forKey:@"arr"];
    [defaults synchronize];
    NSLog(@"Data saved");
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (section == 0)
    {
        return appDel.products.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (section == 0)
    {
        NSString *savedStr = [[NSString alloc]initWithFormat:@"Saved Recipes (%i)", appDel.products.count];
        return savedStr;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
    CustomCell *cell = (CustomCell *)[nib objectAtIndex:0];
    if (cell != nil)
    {
        NSDictionary *dict = [appDel.products objectAtIndex:indexPath.row];
        if (dict != nil)
        {
            NSString *ratingNumber = [[NSString alloc]initWithFormat:@"%@",[dict valueForKey:@"rating"]];
            cell.starControl.rating = ratingNumber.doubleValue;
            NSURL *picUrl = [NSURL URLWithString:[dict valueForKey:@"thumb"]];
            NSData *picData = [NSData dataWithContentsOfURL:picUrl];
            UIImage *imgdefault = [UIImage imageNamed:@"defaultpic.png"];
            [cell.thumbnailPic setImageWithURL:picUrl placeholderImage:imgdefault];
            [cell.statusLabel setText:[dict valueForKey:@"title"]];
            [cell.sourceLabel setText:[dict valueForKey:@"source"]];
            [cell.starControl setRating:ratingNumber.doubleValue];

            if (picData == nil)
            {
                [cell.thumbnailPic setImage:imgdefault];
            }
        }
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [AJNotificationView showNoticeInView:self.view
                                        type:AJNotificationTypeRed
                                       title:@"Recipe has been Deleted!"
                                   hideAfter:2.5f];
        
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDel.products removeObjectAtIndex:indexPath.row];
        NSLog(@"from app del : %i",appDel.products.count);
        [savedRecipesTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:true];
        [savedRecipesTable reloadData];
        if (appDel.products.count == 0)
        {
            [savedimg setHidden:false];
            [savedRecipesTable setHidden:true];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self connected])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Connection Lost. Please check your connection. This application requires an active internet connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        
        NSLog(@"Not Connected to internet");
        [alert show];
    }
    else
    {
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSDictionary *dict = [appDel.products objectAtIndex:indexPath.row];
        NSString *theTitle = [dict valueForKey:@"title"];
        NSString *theThumb = [dict valueForKey:@"thumb"];
        NSString *theLink = [dict valueForKey:@"link"];
        
        if ([UIScreen mainScreen].bounds.size.height <= 480) {
            AltDetailsViewController *detailsView = [[AltDetailsViewController alloc]initWithNibName:@"AltDetailsTwo" bundle:nil];
            [detailsView setTitleStr:theTitle];
            [detailsView setLinkStr:theLink];
            detailsView.thumbStr = theThumb;
            [self.navigationController pushViewController:detailsView animated:true];
        } else {
            AltDetailsViewController *detailsView = [[AltDetailsViewController alloc]initWithNibName:@"AltDetailsViewController" bundle:nil];
            [detailsView setTitleStr:theTitle];
            [detailsView setLinkStr:theLink];
            detailsView.thumbStr = theThumb;
            [self.navigationController pushViewController:detailsView animated:true];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
