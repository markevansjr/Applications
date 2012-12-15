//
//  SpecialRecipeViewController.m
//  Recipe It up!
//
//  Created by Mark Evans on 9/2/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import "SpecialRecipeViewController.h"
#import  <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>

@interface SpecialRecipeViewController ()

@end

@implementation SpecialRecipeViewController

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
    if ([theNavbar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"navbar_blank.png"];
        [theNavbar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    UIImage *image = [UIImage imageNamed:@"recipebg"];
    
    NSString *thetext = [[NSString alloc]initWithFormat:@"Ingredients\n1/3 cup butter or margarine\n2 green onions, sliced\n4 large garlic cloves, minced\n1 tablespoon grated lemon rind\n1/2 cup fresh lemon juice\n1/2 teaspoon salt\n1 3/4 pounds large fresh shrimp, peeled and deveined\n1/2 cup chopped fresh parsley\n1/2 teaspoon hot sauce\n12 ounces angel hair pasta, cooked\n\nPreparation\nMelt butter in a large skillet over medium-high heat; add green onions, minced garlic, lemon rind, lemon juice, and salt; cook garlic mixture 2 to 3 minutes or until bubbly.\n\nReduce heat to medium; add shrimp, and cook, stirring constantly, 5 minutes or just until shrimp turn pink. Stir in parsley and hot sauce. Toss with hot pasta.\n\nPrep: 10 min., Cook: 8 min."];
    textView.text = thetext;
    
    NSString *filePath = @"http://www.markevansjr.com/video/video_recipe_of_the_day.m4v";
    NSURL *fileURL = [NSURL URLWithString:filePath];
    moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:fileURL];
    if (moviePlayer != nil)
    {
        [movieView addSubview:moviePlayer.view];
        moviePlayer.view.frame = CGRectMake(0.0f, 0.0f, movieView.frame.size.width, movieView.frame.size.height);
        moviePlayer.view.backgroundColor = [UIColor colorWithPatternImage:image];
        moviePlayer.fullscreen = false;
        moviePlayer.controlStyle = MPMovieControlStyleDefault;
        [moviePlayer play];
    }
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction)showaction
{
    popquery = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Print Recipe" otherButtonTitles:@"Email Recipe", @"Open in Safari", nil];
    popquery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popquery showFromBarButtonItem:actionButton animated:true];
}

- (IBAction)print
{
    UIPrintInteractionController *print = [UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    
    print.printInfo = printInfo;
    print.printFormatter = [self.view viewPrintFormatter];
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

- (void)pushSafari
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.myrecipes.com/recipe/speedy-scampi-10000000264365/"]];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSString *cancelTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
	if([title isEqualToString:@"Print Recipe"])
	{
        [self print];
    }
    else if([title isEqualToString:@"Email Recipe"])
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
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    if ([MFMailComposeViewController canSendMail])
    {
        //Setting up the Subject, recipients, and message body.
        NSString *formattMsg = [[NSString alloc]initWithFormat:@"Shrimp Scampi\n\nLink to Recipe:\nhttp://www.myrecipes.com/recipe/speedy-scampi-10000000264365/"];
        NSLog(@"%@", formattMsg);
        [mail setMessageBody:formattMsg isHTML:false];
        NSString *formatSub = [[NSString alloc]initWithFormat:@"Recipe: Shrimp Scampi"];
        [mail setSubject:formatSub];
        //[mail setToRecipients:[NSArray arrayWithObjects:@"mevansjr@gmail.com",nil]];
        //Present the mail view controller
        [self presentViewController:mail animated:true completion:nil];
        
        NSURL *picUrl = [NSURL URLWithString:@"http://img4-2.myrecipes.timeinc.net/i/recipes/sl/02/07/shrimp-scampi-sl-264365-l.jpg"];
        NSData *picData = [NSData dataWithContentsOfURL:picUrl];
        UIImage *pic = [[UIImage alloc] initWithData:picData];
        NSData *exportData = UIImageJPEGRepresentation(pic ,1.0);
        
        [mail addAttachmentData:exportData mimeType:@"image/jpeg" fileName:@"Picture.jpeg"];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:true completion:nil];
	if (result == MFMailComposeResultFailed)
    {
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

- (IBAction)onClose:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
    return YES;
}

@end
