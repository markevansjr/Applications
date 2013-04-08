//
//  ViewController.m
//  weddingsnap
//
//  Created by Mark Evans on 4/8/13.
//  Copyright (c) 2013 Mark Evans. All rights reserved.
//

#import "ViewController.h"
#import "JSON.h"
#import "DetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>
#import "NearByViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

-(void)viewWillAppear:(BOOL)animated
{
    if(![self connected])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Connection Lost. Please check your connection. This application requires an active internet connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        
        NSLog(@"Not Connected to internet");
        [alert show];
    } else {
        // Flickr Key
        NSString *flickrKey = @"028871bce520f6f7b5fafecdc38d84a3";
    
        // Flickr Tag
        NSString *flickrTag = @"wedding";
    
        // Build the string to call the Flickr API
        NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=30&format=json&nojsoncallback=1", flickrKey, flickrTag];
    
        // Create NSURL string from formatted string, by calling the Flickr API
        NSURL *url = [NSURL URLWithString:urlString];
    
        // Setup and start async download
        if (url != nil)
        {
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
            if (request != nil)
            {
                NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                [connection start];
            }
        }
    }
}

- (void)nearBy
{
    NearByViewController *nearbyView = [[NearByViewController alloc]initWithNibName:@"NearByViewController" bundle:nil];
    [self.navigationController pushViewController:nearbyView animated:true];
}


- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.png"]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0067 green:0.1818 blue:0.2824 alpha:1.0]];
    UIBarButtonItem *rightButton =[[UIBarButtonItem alloc]initWithTitle:@"NearBy" style:UIBarButtonItemStylePlain target:self action:@selector(nearBy)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // Set GMGridView
    GMGridView *gmGridView = [[GMGridView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    gmGridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gmGridView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:gmGridView];
    _gmGridView = gmGridView;
    
    // Set Delegate
    _gmGridView.style = GMGridViewStyleSwap;
    _gmGridView.itemSpacing = 10;
    _gmGridView.minEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
    _gmGridView.centerGrid = YES;
    _gmGridView.actionDelegate = self;
    _gmGridView.dataSource = self;
    _gmGridView.mainSuperView = self.navigationController.view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set Title
    self.title = @"Forever Snap";
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Initialize arrays
    photoURLsSmallImage = [[NSMutableArray alloc] init];
    photoURLsLargeImage = [[NSMutableArray alloc] init];
    
    // Store incoming data into a string
    if (data != nil)
    {
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        // Create a dictionary from the JSON string
        NSDictionary *results = [jsonString JSONValue];
        
        NSLog(@"%@", results.description);
        
        // Build an array from the dictionary for easy access to each entry
        NSArray *photos = [[results objectForKey:@"photos"] objectForKey:@"photo"];
        
        // Loop
        for (NSDictionary *photo in photos)
        {
            // Build the URL
            NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
            [photoURLsSmallImage addObject:[NSURL URLWithString:photoURLString]];
            
            // Build and save the URL to the large image so we can view on a detailed view
            photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
            [photoURLsLargeImage addObject:[NSURL URLWithString:photoURLString]];
        }
    }
    
    // Update the grid with data
    [_gmGridView reloadData];
}

- (NSInteger)numberOfItemsInGMGridView:(GMGridView *)gridView
{
    return [photoURLsSmallImage count];
}

- (CGSize)GMGridView:(GMGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (INTERFACE_IS_PHONE)
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(170, 135);
        }
        else
        {
            return CGSizeMake(140, 110);
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(orientation))
        {
            return CGSizeMake(285, 205);
        }
        else
        {
            return CGSizeMake(230, 175);
        }
    }
}

- (GMGridViewCell *)GMGridView:(GMGridView *)gridView cellForItemAtIndex:(NSInteger)index
{
   CGSize size = [self GMGridView:gridView sizeForItemsInInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    
    GMGridViewCell *cell = [gridView dequeueReusableCell];
    
    if (!cell)
    {
        cell = [[GMGridViewCell alloc] init];
        NSURL *imageURL = [photoURLsSmallImage objectAtIndex:index];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        if (imageURL != nil)
        {
            [imageview setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [imageview.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [imageview.layer setBorderWidth: 2.0];
            
            CALayer * l = [imageview layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
            
            [view addSubview:imageview];
            [cell addSubview:view];
        }
    }
    
    return cell;
}

- (BOOL)GMGridView:(GMGridView *)gridView canDeleteItemAtIndex:(NSInteger)index
{
    return NO;
}

- (void)GMGridView:(GMGridView *)gridView didTapOnItemAtIndex:(NSInteger)position
{
    DetailsViewController *detailsView = [[DetailsViewController alloc]initWithNibName:@"DetailsViewController" bundle:nil];
    NSNumber *n = [NSNumber numberWithInteger:position];
    [detailsView passImageURL:[photoURLsLargeImage objectAtIndex:position] passPosition:[n stringValue]];
    [self.navigationController pushViewController:detailsView animated:true];
}

- (void)GMGridViewDidTapOnEmptySpace:(GMGridView *)gridView
{
    NSLog(@"Tap on empty space");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
