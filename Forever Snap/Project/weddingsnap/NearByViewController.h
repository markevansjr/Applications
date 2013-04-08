//
//  NearByViewController.h
//  weddingsnap
//
//  Created by Mark Evans on 4/8/13.
//  Copyright (c) 2013 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"

@interface NearByViewController : UIViewController <CoreLocationControllerDelegate, UIWebViewDelegate>
{
    CLLocationCoordinate2D thecoord;
    CoreLocationController *CLController;
    CLLocation *theLoc;
    IBOutlet UIWebView *theWebView;
    NSString *loadURL;
    IBOutlet UIBarButtonItem *backButton;
}
- (IBAction)back:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)refresh:(id)sender;

@end
