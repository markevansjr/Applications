//
//  FirstViewController.h
//  app
//
//  Created by Mark Evans on 8/27/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
{
    IBOutlet UISearchBar *foodSearchBar;
    IBOutlet UITableView *foodTableView;
    IBOutlet UIButton *dimView;
    IBOutlet UIView *hideView;
    IBOutlet UIActivityIndicatorView *actview;
    NSURLConnection *conn;
    UIBarButtonItem *leftBtn;
    NSArray *searchDataArray;
    NSMutableArray *dataArray;
    NSDictionary *listItems;
    NSString *searchedStr;
    NSString *findRecipeStr;
    NSData *requestData;
    NSMutableArray *copydataArray;
    NSString *thumb;
    NSDictionary *countDict;
}
- (BOOL)connected;
- (IBAction)onClickRecipe:(id)sender;
- (IBAction)removekeyboard:(id)sender;
@property (nonatomic, retain) NSData *requestData;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSMutableArray *copydataArray;
@property (nonatomic, retain) NSArray *searchDataArray;
@property (nonatomic, retain) NSString *findRecipeStr;

@end
