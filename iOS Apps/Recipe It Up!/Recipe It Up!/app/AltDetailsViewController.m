//
//  AltDetailsViewController.m
//  app
//
//  Created by Mark Evans on 8/28/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import "AltDetailsViewController.h"
#import "WebViewController.h"
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "SecondViewController.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"
#import "SavedRecipesViewController.h"
#import "AJNotificationView.h"

@interface AltDetailsViewController ()

@end

@implementation AltDetailsViewController
@synthesize titleStr, thumbStr, sourceStr, linkStr, ratingStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (IBAction)webView:(id)sender
{
    if(![self connected])
    {
        NSLog(@"Not Connected to internet");
        // not connected
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Connection Lost. Please check your connection. This application requires an active internet connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
    } else {
        WebViewController *webView = [[WebViewController alloc]initWithNibName:@"WebViewController" bundle:nil];
        [self presentViewController:webView animated:true completion:nil];
    }
}

- (void)viewDidLoad
{
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    rightButton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showaction)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0039 green:0.5176 blue:0.5725 alpha:0.78]];
    
    NSLog(@"title- %@ thumb- %@ source- %@ link- %@ rating- %@", titleStr, thumbStr, sourceStr, linkStr, ratingStr);
    [self setTitle:@"Recipe Details"];
    theTitle.text = titleStr;
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel setWebURL:linkStr];
    
    [appDel setQuerySearch:titleStr];
    //ingTextView.text = ingredientsStr;
    NSURL *imgUrl = [NSURL URLWithString:thumbStr];
    //NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
    //UIImage *img = [[UIImage alloc] initWithData:imgData];
    UIImage *imgdefault = [UIImage imageNamed:@"defaultpic.png"];
    [thumbImageView setImageWithURL:imgUrl placeholderImage:imgdefault];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)showaction
{
    popquery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Email Recipe" otherButtonTitles:@"Open in Safari", nil];
    popquery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popquery showFromBarButtonItem:rightButton animated:true];
}

- (void)pushSafari
{
    //AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkStr]];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSString *cancelTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Email Recipe"])
	{
        [self pushEmail];
    }
    else if([title isEqualToString:@"Open in Safari"])
	{
        [self pushSafari];
    }
    else if([cancelTitle isEqualToString:@"Cancel"])
    {
        NSLog(@"Cancel button clicked.");
    }
}

-(IBAction)pushEmail
{
    if(![self connected])
    {
        NSLog(@"Not Connected to internet");
        // not connected
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Connection Lost. Please check your connection. This application requires an active internet connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [alert show];
    } else {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        if ([MFMailComposeViewController canSendMail])
        {
            //Setting up the Subject, recipients, and message body.
            NSString *formattMsg = [[NSString alloc]initWithFormat:@"%@\n\nLink to Recipe:\n%@", titleStr, linkStr];
            NSLog(@"%@", formattMsg);
            [mail setMessageBody:formattMsg isHTML:false];
            NSString *formatSub = [[NSString alloc]initWithFormat:@"Recipe: %@", titleStr];
            [mail setSubject:formatSub];
            //[mail setToRecipients:[NSArray arrayWithObjects:@"mevansjr@gmail.com",nil]];
            //Present the mail view controller
            [self presentViewController:mail animated:true completion:nil];
            
            NSURL *picUrl = [NSURL URLWithString:thumbStr];
            NSData *picData = [NSData dataWithContentsOfURL:picUrl];
            UIImage *pic = [[UIImage alloc] initWithData:picData];
            NSData *exportData = UIImageJPEGRepresentation(pic ,1.0);
            
            [mail addAttachmentData:exportData mimeType:@"image/jpeg" fileName:@"Picture.jpeg"];
        }
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == myTextField)
    {
        [myTextField resignFirstResponder];
        [self pushEmail];
    }
    return TRUE;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:true completion:nil];
	if (result == MFMailComposeResultFailed) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Failed!" message:@"Your email has failed to send" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
		[alert show];
    }
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