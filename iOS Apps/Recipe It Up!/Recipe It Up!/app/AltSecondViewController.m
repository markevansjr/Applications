//
//  AltSecondViewController.m
//  Recipe It up!
//
//  Created by Mark Evans on 11/1/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import "AltSecondViewController.h"
#import "CustomCell2.h"
#import "DetailsViewController.h"
#import "AppDelegate.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#import "Reachability.h"
#import "AJNotificationView.h"

@interface AltSecondViewController ()

@end

@implementation AltSecondViewController
@synthesize requestData, searchDataArray, dataArray, CLController, theMapView, querySearchTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Locate Food";
        self.tabBarItem.image = [UIImage imageNamed:@"searchicon.png"];
    }
    return self;
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

- (void)viewWillAppear:(BOOL)animated
{
    [dimView setHidden:true];
    [theMapView removeAnnotations:theMapView.annotations];
    [theSearchBar setText:nil];
    CLController = [[CoreLocationController alloc] init];
    CLController.delegate = self;
    [CLController.locMgr startUpdatingLocation];
    [mapTableView setHidden:true];
}

- (IBAction)removekeyboard:(id)sender
{
    [dimView setHidden:true];
    [theSearchBar resignFirstResponder];
}

- (void)viewDidLoad
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:@"navbar_blank.png"];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    [CLController.locMgr stopUpdatingLocation];
    
    UIImage *image = [UIImage imageNamed:@"newsearchheader.png"];
    [theSearchBar setBackgroundImage:image];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.0039 green:0.5176 blue:0.5725 alpha:0.78]];
    MKCoordinateRegion newRegion;
    newRegion.center.latitude =[theLoc coordinate].latitude;
    newRegion.center.longitude = [theLoc coordinate].longitude;
    newRegion.span.latitudeDelta = 20.191933;
    newRegion.span.longitudeDelta = 20.191933;
    self.theMapView.mapType = MKMapTypeStandard;
    self.theMapView.delegate = self;
    
    [self.theMapView setRegion:newRegion animated:YES];
    [super viewDidLoad];
}

- (void)locationUpdate:(CLLocation *)location
{
	NSLog(@"Lat- %f Lon- %f",location.coordinate.latitude, location.coordinate.longitude);
    theLoc = [CLController.locMgr location];
}

- (void)locationError:(NSError *)error {
	NSLog(@"%@", [error description]);
}

- (void)viewDidUnload
{
    urlStr = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)validateFieldsBeforeCommit
{
	if ([[theSearchBar text] isEqualToString:@" "] || [[theSearchBar text] isEqualToString:@""] )
    {
        [AJNotificationView showNoticeInView:self.view
                                        type:AJNotificationTypeRed
                                       title:@"Empty Search.. Please enter a food item or recipe!"
                             linedBackground:AJLinedBackgroundTypeAnimated
                                   hideAfter:4.5f];
		return NO;
	}
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar == theSearchBar)
    {
        if (![self validateFieldsBeforeCommit])
        {
            return;
        }
        
        actview = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        leftBtn = [[UIBarButtonItem alloc] initWithCustomView:actview];
        [self navigationItem].leftBarButtonItem = leftBtn;
        [actview startAnimating];
        
        [self searchResults];
        
        [mapTableView setHidden:false];
        [CLController.locMgr stopUpdatingLocation];
        NSLog(@"Search Button pressed.");
        
        MKCoordinateRegion newRegion;
        newRegion.center.latitude =[theLoc coordinate].latitude;
        newRegion.center.longitude = [theLoc coordinate].longitude;
        newRegion.span.latitudeDelta = 0.021933;
        newRegion.span.longitudeDelta = 0.021933;
        self.theMapView.delegate = self;
        [self.theMapView setRegion:newRegion animated:YES];
    }
    [dimView setHidden:true];
    [theSearchBar resignFirstResponder];
}

- (void)searchResults
{
    searchedStr = [theSearchBar text];
    NSString *formatStr = [searchedStr stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSLog(@"thelat- %f, thelong- %f",theLoc.coordinate.latitude, theLoc.coordinate.longitude);
    NSString *addSearchedStrURL = [[NSString alloc]initWithFormat:@"http://api.infochimps.com/geo/location/foursquare/places/search?g.radius=10000&g.latitude=%f&g.longitude=%f&f.q=%@&apikey=mevansjr-zZPAzjzWAbpBP86FTOcKt54jZ69", theLoc.coordinate.latitude, theLoc.coordinate.longitude, formatStr];
    NSURL *urlSearch = [NSURL URLWithString:addSearchedStrURL];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:urlSearch];
    if (request !=nil)
    {
        requestData = [[NSData alloc]initWithContentsOfURL:urlSearch];
        NSError *jsonError = nil;
        dataArray = [NSJSONSerialization JSONObjectWithData:requestData options:NSJSONReadingAllowFragments error:&jsonError];
        NSLog(@"%@", dataArray.description);
        mapItems = [dataArray valueForKey:@"results"];
        
        [mapTableView reloadData];
        
        if (mapItems.count < 1)
        {
            [theMapView setHidden:true];
            [AJNotificationView showNoticeInView:self.view
                                            type:AJNotificationTypeRed
                                           title:@"Sorry no search results!"
                                 linedBackground:AJLinedBackgroundTypeAnimated
                                       hideAfter:4.0f];
        }
        
        [theMapView removeAnnotations:theMapView.annotations]; //Removes all Annotations
        for (int i = 0; mapItems.count > i; i++)
        {
            NSArray *theName = [mapItems valueForKey:@"name"];
            NSArray *theCoords = [mapItems valueForKey:@"coordinates"];
            
            NSArray *blah = [theCoords objectAtIndex:i]; //Loops through and re-adds locations in array
            NSString *nlong = [blah objectAtIndex:0];
            NSString *nlat = [blah objectAtIndex:1];
            
            CLLocationCoordinate2D theCoordinate1;
            theCoordinate1.latitude = nlat.doubleValue;
            theCoordinate1.longitude = nlong.doubleValue;
            
            loc = [[MyAnnotation alloc]init];
            loc.title = [theName objectAtIndex:i];
            loc.coordinate = theCoordinate1;
            [loc.mapItem.placemark setCoordinate:theCoordinate1];
            
            [theMapView addAnnotation:loc];
        }
        conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar == theSearchBar)
    {
        [theSearchBar resignFirstResponder];
        [dimView setHidden:true];
        [mapTableView setHidden:true];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [CLController.locMgr stopUpdatingLocation];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == conn)
    {
        NSLog(@"All Received!");
        [actview stopAnimating];
        [actview setHidden:true];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    pinView = (MKPinAnnotationView*)[self.theMapView dequeueReusableAnnotationViewWithIdentifier:@"MyAnnotation"];
    
    if (!pinView)
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotation"];
    else
        pinView.annotation = annotation;
    //pinView.animatesDrop = YES;
    pinView.canShowCallout = YES;
    pinView.enabled = YES;
    pinView.image=[UIImage imageNamed:@"pin.png"];
    //pinView.pinColor = MKPinAnnotationColorPurple;
    
    UIButton *btnViewVenue = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pinView.rightCalloutAccessoryView = btnViewVenue;
    pinView.multipleTouchEnabled = NO;
    [btnViewVenue addTarget:self action:@selector(goToPinDetalView) forControlEvents:UIControlEventAllEvents];
    
    return pinView;
}

- (void)goToPinDetalView
{
    //
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar == theSearchBar)
    {
        [mapTableView setHidden:true];
        theSearchBar.showsCancelButton = YES;
        if(![self connected])
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Internet Connection Lost. Please check your connection. This application requires an active internet connect." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
            
            NSLog(@"Not Connected to internet");
            [alert show];
            [theSearchBar resignFirstResponder];
        }
        else
        {
            [theMapView setHidden:true];
            hideView.bounds = CGRectMake(0.0f, 23.0f, 320.0f, 367.0f);
        }
        [dimView setHidden:false];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    theSearchBar.showsCancelButton = NO;
    hideView.bounds = CGRectMake(0.0f, 0.0f, 320.0f, 367.0f);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return mapItems.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSString *savedStr = [[NSString alloc]initWithFormat:@"Searched Locations (%i)", mapItems.count];
        return savedStr;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell2" owner:self options:nil];
    CustomCell2 *cell = (CustomCell2 *)[nib objectAtIndex:0];
    if (cell != nil)
    {
        NSArray *theName = [mapItems valueForKey:@"name"];
        NSArray *theCoords = [mapItems valueForKey:@"coordinates"];
        
        NSArray *blah = [theCoords objectAtIndex:indexPath.row]; //Loops through and re-adds locations in array
        NSString *nlong = [blah objectAtIndex:0];
        NSString *nlat = [blah objectAtIndex:1];
        
        CLLocationCoordinate2D theCoordinate1;
        theCoordinate1.latitude = nlat.doubleValue;
        theCoordinate1.longitude = nlong.doubleValue;
        
        CLLocation *userLoc = [CLController.locMgr location];
        CLLocation *poiLoc = [[CLLocation alloc] initWithLatitude:nlat.doubleValue longitude:nlong.doubleValue];
        
        double dist = [userLoc distanceFromLocation:poiLoc] / 1000;
        
        NSString *theCoordsStr = [NSString stringWithFormat:@"%2f Miles", dist];
        
        if (theName != nil)
        {
            cell.statusLabel.text = [theName objectAtIndex:indexPath.row];
            cell.sourceLabel.text = theCoordsStr;
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *theCoords = [mapItems valueForKey:@"coordinates"];
    
    NSArray *blah = [theCoords objectAtIndex:indexPath.row]; //Loops through and re-adds locations in array
    NSString *nlong = [blah objectAtIndex:0];
    NSString *nlat = [blah objectAtIndex:1];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Do you want to open the location in iOS Maps?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    urlStr = [NSString stringWithFormat:@"http://maps.apple.com?q=%f,%f", nlat.doubleValue, nlong.doubleValue];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if([title isEqualToString:@"Yes"])
        {
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:urlStr]];
        }
        else
        {
            // Cancel
        }

}

@end
