//
//  NearByViewController.m
//  weddingsnap
//
//  Created by Mark Evans on 4/8/13.
//  Copyright (c) 2013 Mark Evans. All rights reserved.
//

#import "NearByViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface NearByViewController ()

@end

@implementation NearByViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"NearBy";
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    CLController = [[CoreLocationController alloc] init];
    CLController.delegate = self;
    [CLController.locMgr startUpdatingLocation];
}

- (void)locationUpdate:(CLLocation *)location
{
	NSLog(@"Lat- %f Lon- %f",location.coordinate.latitude, location.coordinate.longitude);
    loadURL = [[NSString alloc]initWithFormat:@"http://m.flickr.com/nearby/%f,%f?show=detail&fromfilter=1&by=everyone&taken=recent&sort=distance", location.coordinate.latitude, location.coordinate.longitude];
    [CLController.locMgr stopUpdatingLocation];
    NSURL *url = [NSURL URLWithString:loadURL];
    if (url != nil){
        NSLog(@"%@", loadURL);
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        [theWebView loadRequest:request];
        theWebView.scalesPageToFit = YES;
    }
    else if (!theWebView.canGoBack)
    {
        backButton.enabled = false;
    }
    else if (!theWebView.canGoForward)
    {
        backButton.enabled = false;
    }
}

- (void)locationError:(NSError *)error {
	NSLog(@"%@", [error description]);
}

- (IBAction)back:(id)sender
{
    if (theWebView.canGoBack)
    {
        [theWebView goBack];
        
        backButton.enabled = (theWebView.canGoBack);
    }
}  

- (IBAction)stop:(id)sender
{
    if (theWebView.isLoading)
    {
        [theWebView stopLoading];
    }
}

- (IBAction)refresh:(id)sender
{
    [theWebView reload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.png"]];
    theWebView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.png"]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0067 green:0.1818 blue:0.2824 alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
