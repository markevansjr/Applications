//
//  AltDetailsViewController.h
//  app
//
//  Created by Mark Evans on 8/28/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AltDetailsViewController : UIViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    NSString *titleStr;
    NSString *sourceStr;
    NSString *thumbStr;
    NSString *linkStr;
    NSString *ratingStr;
    IBOutlet UIImageView *thumbImageView;
    IBOutlet UITextView *ingTextView;
    IBOutlet UITextField *myTextField;
    IBOutlet UILabel *theTitle;
    UIActionSheet *popquery;
    UIBarButtonItem *rightButton;
}
- (BOOL)connected;
-(IBAction)pushEmail;
- (IBAction)webView:(id)sender;
@property (nonatomic, retain) NSString *titleStr;
@property (nonatomic, retain) NSString *sourceStr;
@property (nonatomic, retain) NSString *thumbStr;
@property (nonatomic, retain) NSString *linkStr;
@property (nonatomic, retain) NSString *ratingStr;

@end