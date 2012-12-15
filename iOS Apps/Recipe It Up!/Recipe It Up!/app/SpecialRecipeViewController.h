//
//  SpecialRecipeViewController.h
//  Recipe It up!
//
//  Created by Mark Evans on 9/2/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>

@interface SpecialRecipeViewController : UIViewController <UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
{
    MPMoviePlayerController *moviePlayer;
    IBOutlet UINavigationBar *theNavbar;
    IBOutlet UIView *movieView;
    IBOutlet UITextView *textView;
    IBOutlet UIBarButtonItem *actionButton;
    UIActionSheet *popquery;
}
- (IBAction)showaction;
- (IBAction)print;
- (IBAction)pushEmail;
- (IBAction)onClose:(id)sender;

@end
