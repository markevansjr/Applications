//
//  FirstViewController.m
//  app
//
//  Created by Mark Evans on 8/27/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import "FirstViewController.h"
#import "CustomCell.h"
#import "DetailsViewController.h"
#import "AppDelegate.h"
#import "SavedRecipesViewController.h"
#import "UIImageView+WebCache.h"
#import "AJNotificationView.h"
#import "Reachability.h"
#import "SpecialRecipeViewController.h"
#import "CQMFloatingController.h"
#import "DemoTableViewController.h"

#define RECTLOG(rect)    (NSLog(@""  #rect @" x:%f y:%f w:%f h:%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height ));

@interface FirstViewController ()

@end

@implementation FirstViewController
@synthesize requestData, searchDataArray, dataArray, copydataArray, findRecipeStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Search";
        UIImage *headerImage = [UIImage imageNamed:@"mainlogo.png"];
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:headerImage];
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (BOOL)validateFieldsBeforeCommit
{
	if ([[foodSearchBar text] isEqualToString:@" "] || [[foodSearchBar text] isEqualToString:@""] )
    {
        [AJNotificationView showNoticeInView:self.view
                                        type:AJNotificationTypeRed
                                       title:@"Empty Search.. Please enter a food item or recipe!"
                             linedBackground:AJLinedBackgroundTypeAnimated
                                   hideAfter:4.5f];
		return NO;
	}
    return YES;
}
							
- (void)viewDidLoad
{
    RECTLOG(self.view.frame);
    [dimView setHidden:true];
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"navbar_blank.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    //UIImage *image = [UIImage imageNamed:@"facetime.png"];
    //leftBtn =[[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onClickRecipe:)];
    //self.navigationItem.leftBarButtonItem = leftBtn;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0039 green:0.5176 blue:0.5725 alpha:0.78]];
    UIImage *image2 = [UIImage imageNamed:@"newsearchheader.png"];
    [foodSearchBar setBackgroundImage:image2];
    UIImage *bgimage = [UIImage imageNamed:@"wood.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgimage];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSDate *notifyDate = [[NSDate date] dateByAddingTimeInterval:30];
    UILocalNotification *theNotification = [[UILocalNotification alloc] init];
    if (theNotification != nil)
    {
        theNotification.fireDate = notifyDate;
        theNotification.timeZone = [NSTimeZone localTimeZone];
        theNotification.alertBody = @"Find a recipe!";
        theNotification.alertAction = @"Open";
        [[UIApplication sharedApplication] scheduleLocalNotification:theNotification];
    }
    [foodTableView setHidden:true];
    [hideView setHidden:false];
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)toggleAdd
{
    [foodTableView setEditing:!foodTableView.editing animated:YES];
    
    if (foodTableView.editing)
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
    }
    else
    {
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
    }
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (IBAction)onClickRecipe:(id)sender
{
    if(![self connected])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Connection Lost. Please check your connection. This application requires an active internet connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        
        NSLog(@"Not Connected to internet");
        [alert show];
    }
    else
    {
        DemoTableViewController *demoViewController = [[DemoTableViewController alloc] init];
        CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
        UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [floatingController showInView:[rootViewController view] withContentViewController:demoViewController animated:YES];
        [floatingController setFrameColor:[UIColor colorWithRed:0.0039 green:0.5176 blue:0.5725 alpha:0.78]];
    }
}

- (IBAction)removekeyboard:(id)sender
{
    [dimView setHidden:true];
    self.navigationItem.rightBarButtonItem = nil;
    [foodSearchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == foodSearchBar)
    {
        if(![self connected])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Connection Lost. Please check your connection. This application requires an active internet connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
            
            NSLog(@"Not Connected to internet");
            [alert show];
        }
        else
        {
            if (![self validateFieldsBeforeCommit])
            {
                return;
            }
            
            [self searchResults];
            
            actview = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            leftBtn = [[UIBarButtonItem alloc] initWithCustomView:actview];
            [self navigationItem].leftBarButtonItem = leftBtn;
            [actview startAnimating];
        
            [foodTableView setHidden:false];
            [hideView setHidden:true];
            NSLog(@"Search Button pressed.");
        }
        [dimView setHidden:true];
        [foodTableView reloadData];
        [foodSearchBar resignFirstResponder];
    }
}

- (void)searchResults
{
    searchedStr = [foodSearchBar text];
    NSString *formatStr = [searchedStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *addSearchedStrURL = [[NSString alloc]initWithFormat:@"http://api.punchfork.com/recipes?key=13c42c860b3e65ae&q=%@&count=100", formatStr];
    NSURL *urlSearch = [NSURL URLWithString:addSearchedStrURL];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:urlSearch];
    if (request !=nil)
    {
        requestData = [[NSData alloc]initWithContentsOfURL:urlSearch];
        NSError *jsonError = nil;
        dataArray = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingAllowFragments error:&jsonError];
        NSLog(@"%@", dataArray.description);
        listItems = [dataArray valueForKey:@"recipes"];
        if (listItems.count < 1)
        {
            [foodTableView setHidden:true];
            [AJNotificationView showNoticeInView:self.view
                                            type:AJNotificationTypeRed
                                           title:@"Sorry no search results!"
                                 linedBackground:AJLinedBackgroundTypeAnimated
                                       hideAfter:4.0f];
        }
    }
    conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc]initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(toggleAdd)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == foodSearchBar)
    {
        foodSearchBar.showsCancelButton = YES;
        if(![self connected])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Connection Lost. Please check your connection. This application requires an active internet connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
            
            NSLog(@"Not Connected to internet");
            [alert show];
            [foodSearchBar resignFirstResponder];
        }
        else
        {
            [dimView setHidden:false];
            [foodTableView setHidden:true];
            [hideView setHidden:false];
            hideView.bounds = CGRectMake(0.0f, 25.0f, 320.0f, 367.0f);
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == foodSearchBar)
    {
        [foodSearchBar resignFirstResponder];
        self.navigationItem.rightBarButtonItem = nil;
        [dimView setHidden:true];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == conn)
    {
        NSLog(@"All Received!");
        [actview stopAnimating];
        [actview setHidden:true];
        
        //UIImage *image = [UIImage imageNamed:@"facetime.png"];
        //leftBtn =[[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onClickRecipe:)];
        //self.navigationItem.leftBarButtonItem = leftBtn;
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    foodSearchBar.showsCancelButton = NO;
    hideView.bounds = CGRectMake(0.0f, 0.0f, 320.0f, 367.0f);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return listItems.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSString *savedStr = [[NSString alloc]initWithFormat:@"Searched Recipes (%i)", listItems.count];
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
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
    CustomCell *cell = (CustomCell *)[nib objectAtIndex:0];
    if (cell != nil)
    {
        NSArray *titleFood = [listItems valueForKey:@"title"];
        NSArray *sourceFood = [listItems valueForKey:@"source_name"];
        NSArray *picFood = [listItems valueForKey:@"thumb"];
        NSArray *ratingFood = [listItems valueForKey:@"rating"];
        NSURL *picUrl = [NSURL URLWithString:[picFood objectAtIndex:indexPath.row]];
        UIImage *imgdefault = [UIImage imageNamed:@"defaultpic.png"];
        [cell.thumbnailPic setImageWithURL:picUrl placeholderImage:imgdefault];
        NSString *ratingNumber = [[NSString alloc]initWithFormat:@"%@",[ratingFood objectAtIndex:indexPath.row]];
        [cell.starControl setRating:ratingNumber.doubleValue];
        
        if (titleFood != nil)
        {
            cell.statusLabel.text = [titleFood objectAtIndex:indexPath.row];
            cell.sourceLabel.text = [sourceFood objectAtIndex:indexPath.row];
        }
        
    }
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleInsert)
    {
        AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSArray *titleFood = [listItems valueForKey:@"title"];
        NSArray *sourceFood = [listItems valueForKey:@"source_name"];
        NSArray *linkFood = [listItems valueForKey:@"pf_url"];
        NSArray *thumbFood = [listItems valueForKey:@"thumb"];
        NSArray *ratingFood = [listItems valueForKey:@"rating"];
        NSString *titleStr = [titleFood objectAtIndex:indexPath.row];
        NSString *linkStr = [linkFood objectAtIndex:indexPath.row];
        NSString *sourceStr = [sourceFood objectAtIndex:indexPath.row];
        NSString *thethumbStr = [thumbFood objectAtIndex:indexPath.row];
        NSString *theratingStr = [ratingFood objectAtIndex:indexPath.row];
        
        NSDictionary *product = [[NSDictionary alloc] initWithObjectsAndKeys: titleStr, @"title", thethumbStr, @"thumb", sourceStr, @"source", linkStr, @"link", theratingStr, @"rating", nil];
        [appDel.products addObject:product];
        
        // Store the data
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:appDel.products forKey:@"arr"];
        [defaults synchronize];
        NSLog(@"Data saved");
        
        [AJNotificationView showNoticeInView:self.view
                                        type:AJNotificationTypeOrange
                                       title:@"Recipe has been saved!"
                             linedBackground:AJLinedBackgroundTypeAnimated
                                   hideAfter:2.5f];
        
        NSLog(@"from app del saved recipes- %i", [appDel.products count]);
        SavedRecipesViewController *savedView = [[SavedRecipesViewController alloc]init];
        [savedView.savedRecipesTable reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *titleFood = [listItems valueForKey:@"title"];
    NSArray *thumbFood = [listItems valueForKey:@"thumb"];
    NSArray *linkFood = [listItems valueForKey:@"pf_url"];
    NSArray *sourceFood = [listItems valueForKey:@"source_name"];
    NSArray *ratingFood = [listItems valueForKey:@"rating"];
    NSString *titleStr = [titleFood objectAtIndex:indexPath.row];
    thumb = [thumbFood objectAtIndex:indexPath.row];
    NSString *linkStr = [linkFood objectAtIndex:indexPath.row];
    NSString *sourceStr = [sourceFood objectAtIndex:indexPath.row];
    NSString *ratingStr = [ratingFood objectAtIndex:indexPath.row];
    if ([UIScreen mainScreen].bounds.size.height <= 480) {
        DetailsViewController *detailsView = [[DetailsViewController alloc]initWithNibName:@"DetailsTwo" bundle:nil];
        [detailsView setTitleStr:titleStr];
        [detailsView setLinkStr:linkStr];
        [detailsView setSourceStr:sourceStr];
        [detailsView setRatingStr:ratingStr];
        detailsView.thumbStr = thumb;
        NSLog(@"title- %@ thumb- %@  source- %@ link- %@ rating- %@", titleStr, thumb, sourceStr, linkStr, ratingStr);
        [self.navigationController pushViewController:detailsView animated:true];
    } else {
        DetailsViewController *detailsView = [[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil];
        [detailsView setTitleStr:titleStr];
        [detailsView setLinkStr:linkStr];
        [detailsView setSourceStr:sourceStr];
        [detailsView setRatingStr:ratingStr];
        detailsView.thumbStr = thumb;
        NSLog(@"title- %@ thumb- %@  source- %@ link- %@ rating- %@", titleStr, thumb, sourceStr, linkStr, ratingStr);
        [self.navigationController pushViewController:detailsView animated:true];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationMaskPortrait);
}

@end
