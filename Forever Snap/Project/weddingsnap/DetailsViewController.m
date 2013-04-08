//
//  DetailsViewController.m
//  weddingsnap
//
//  Created by Mark Evans on 4/8/13.
//  Copyright (c) 2013 Mark Evans. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailsViewController ()

@end

@implementation DetailsViewController
@synthesize _theUrl, _theNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Detail View";
    }
    return self;
}

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
        if (_theUrl != nil){
            [imageView setImageWithURL:_theUrl placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            [imageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [imageView.layer setBorderWidth: 2.0];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            
            CALayer * l = [imageView layer];
            [l setMasksToBounds:YES];
            [l setCornerRadius:10.0];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0067 green:0.1818 blue:0.2824 alpha:1.0]];
    self.view.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"bg.png"]];
}

-(void)passImageURL:(NSURL *)url passPosition:(NSString *)pos
{
    _theUrl = url;
    int s = pos.intValue+1;
    NSString *temp = [[NSString alloc]initWithFormat:@"IMG @%d", s];
    self.title = temp;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
