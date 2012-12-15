//
//  WebViewController.m
//  app
//
//  Created by Mark Evans on 8/28/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import "WebViewController.h"
#import "DetailsViewController.h"
#import "AppDelegate.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [bgimg setHidden:true];
    [actBtn setHidden:true];
    [actView stopAnimating];
    [actView setHidden:true];
    [actView2 stopAnimating];
    [actView2 setHidden:true];
    backButton.enabled = (webBrowser.canGoBack);
    forwardButton.enabled = (webBrowser.canGoForward);
}

- (IBAction)print:(id)sender
{
    UIPrintInteractionController *print = [UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    
    print.printInfo = printInfo;
    print.printFormatter = [webBrowser viewPrintFormatter];
    print.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *printController, BOOL completed, NSError *error)
    {
        if (!completed && error)
        {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
    };
    [print presentAnimated:YES completionHandler:completionHandler];
}

- (IBAction)back:(id)sender
{
    if (webBrowser.canGoBack)
    {
        [webBrowser goBack];
        
        backButton.enabled = (webBrowser.canGoBack);
    }
}

- (IBAction)forward:(id)sender
{
    if (webBrowser.canGoForward)
    {
        [webBrowser goForward];
        
        forwardButton.enabled = (webBrowser.canGoForward);
    }
}

- (IBAction)stop:(id)sender
{
    if (webBrowser.isLoading)
    {
        [webBrowser stopLoading];
        [actView stopAnimating];
        [actView setHidden:true];
    }
}

- (IBAction)refresh:(id)sender
{
    [webBrowser reload];
    [actView startAnimating];
    [actView setHidden:false];
}

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(IBAction)showaction
{
    popquery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Open in Safari" otherButtonTitles:nil];
    popquery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popquery showFromBarButtonItem:actionButton animated:true];
}

- (void)pushSafari
{
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[appDel webURL]]];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSString *cancelTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Open in Safari"])
	{
        [self pushSafari];
    }
    else if([cancelTitle isEqualToString:@"Cancel"])
    {
        NSLog(@"Cancel button clicked.");
    }
}

- (void)viewDidLoad
{
    if ([theNavbar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"navbar_blank.png"];
        [theNavbar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    if ([theToolbar respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)]) {
        [theToolbar setBackgroundImage:[UIImage imageNamed:@"tabbar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        [theToolbar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar.png"]] atIndex:0];
    }
    [bgimg setHidden:false];
    [actBtn setHidden:false];
    [actView setHidden:false];
    [actView startAnimating];
    [actView2 setHidden:false];
    [actView2 startAnimating];
    [webBrowser setDelegate:self];
    actBtn.layer.cornerRadius = 5.0f;
    
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *theurl = [appDel webURL];
    
    NSLog(@"webview - %@", theurl);
    if (theurl != nil)
    {
        url = [[NSURL alloc] initWithString:theurl];
        request = [[NSURLRequest alloc] initWithURL:url];
        if (request != nil)
        {
            connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        }
        webBrowser.scalesPageToFit = YES;
        [webBrowser loadRequest:request];
    }
    else if (!webBrowser.canGoBack)
    {
        backButton.enabled = false;
    }
    else if (!webBrowser.canGoForward)
    {
        backButton.enabled = false;
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
