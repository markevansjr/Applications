//
//  WebViewController.h
//  app
//
//  Created by Mark Evans on 8/28/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate, UIPrintInteractionControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UIWebView *webBrowser;
    IBOutlet UIActivityIndicatorView *actView;
    IBOutlet UIActivityIndicatorView *actView2;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *forwardButton;
    IBOutlet UIButton *actBtn;
    IBOutlet UIToolbar *theToolbar;
    IBOutlet UINavigationBar *theNavbar;
    IBOutlet UIImageView *bgimg;
    IBOutlet UIBarButtonItem *actionButton;
    UIActionSheet *popquery;
    NSURL *url;
    NSURLRequest *request;
    NSURLConnection *connection;
}
- (IBAction)back:(id)sender;
- (IBAction)forward:(id)sender;
- (IBAction)print:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)showaction;

@end
