//
//  SavedRecipesViewController.h
//  app
//
//  Created by Mark Evans on 8/28/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedRecipesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *savedRecipesTable;
    IBOutlet UIButton *actBtn;
    IBOutlet UIImageView *savedimg;
    IBOutlet UIActivityIndicatorView *actView;
    IBOutlet UIImageView *bgimg;
    NSMutableArray *savedArray;
    NSMutableArray *test;
    NSDictionary *savedDictionary;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
}
- (BOOL)connected;
- (IBAction)clear:(id)sender;
@property (nonatomic, readonly) UITableView *savedRecipesTable;
@property (nonatomic, retain) NSMutableArray *savedArray;
@property (nonatomic, retain) NSDictionary *savedDictionary;
@property (nonatomic, retain) UIButton *actBtn;
@property (nonatomic, retain) UIActivityIndicatorView *actView;
@property (nonatomic, retain) UIImageView *bgimg;

@end
