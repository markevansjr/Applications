//
//  AltSecondViewController.h
//  Recipe It up!
//
//  Created by Mark Evans on 11/1/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CoreLocationController.h"
#import "MyAnnotation.h"

@interface AltSecondViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CoreLocationControllerDelegate, MKMapViewDelegate, NSURLConnectionDataDelegate, UIAlertViewDelegate>
{
    IBOutlet UISearchBar *theSearchBar;
    IBOutlet UITableView *mapTableView;
    IBOutlet MKMapView *theMapView;
    IBOutlet UIButton *dimView;
    IBOutlet UIView *hideView;
    IBOutlet UIActivityIndicatorView *actview;
    NSURLConnection *conn;
    UIBarButtonItem *rightBtn;
    UIBarButtonItem *leftBtn;
    NSArray *searchDataArray;
    NSMutableArray *dataArray;
    NSDictionary *mapItems;
    NSString *searchedStr;
    NSData *requestData;
    NSString *thumb;
    NSString *querySearchTitle;
    NSString *urlStr;
    CLLocationCoordinate2D thecoord;
    CoreLocationController *CLController;
    CLLocation *theLoc;
    NSString *thetitle;
    MKPinAnnotationView* pinView;
    MyAnnotation *loc;
}
- (BOOL)connected;
- (void)goToPinDetalView;
- (IBAction)removekeyboard:(id)sender;
@property (nonatomic, retain) CoreLocationController *CLController;
@property (nonatomic, retain) NSData *requestData;
@property (nonatomic, retain) NSMutableArray *dataArray;
@property (nonatomic, retain) NSArray *searchDataArray;
@property (nonatomic, retain) MKMapView *theMapView;
@property (nonatomic, retain) NSString *querySearchTitle;

@end
