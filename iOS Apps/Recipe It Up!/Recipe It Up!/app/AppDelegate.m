//
//  AppDelegate.m
//  app
//
//  Created by Mark Evans on 8/27/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import "AppDelegate.h"
#import "SavedRecipesViewController.h"
#import "FirstViewController.h"
#import "AltSecondViewController.h"

@implementation AppDelegate
@synthesize products, currentProduct, allcurrentProduct, allproducts;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setupTabBarController];
	[self.window makeKeyAndVisible];
	return YES;
}

-(void)setupTabBarController
{
    CRTabBarController *tabBarController = [[CRTabBarController alloc] init];
    NSMutableArray* viewControllers = [[NSMutableArray alloc] init];
    
    UIViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    UIViewController *viewController2 = [[AltSecondViewController alloc] initWithNibName:@"AltSecondViewController" bundle:nil];
    UIViewController *viewController3 = [[SavedRecipesViewController alloc] initWithNibName:@"SavedRecipesViewController" bundle:nil];
    
    UINavigationController *savedNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController1];
    UITabBarItem* savedTabBarItem = [[UITabBarItem alloc] init];
    [savedTabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"search_on"]
                   withFinishedUnselectedImage: [UIImage imageNamed: @"search"]];
    [savedNavigationController setTabBarItem: savedTabBarItem];
    [viewControllers addObject:savedNavigationController];
    
    UINavigationController *searchNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController2];
    UITabBarItem* searchTabBarItem = [[UITabBarItem alloc] init];
    [searchTabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"locate_on"]
                    withFinishedUnselectedImage: [UIImage imageNamed: @"locate"]];
    [searchNavigationController setTabBarItem: searchTabBarItem];
    [viewControllers addObject:searchNavigationController];
    
    UINavigationController *recentNavigationProductsController = [[UINavigationController alloc] initWithRootViewController:viewController3];
    UITabBarItem* recentTabBarItem = [[UITabBarItem alloc] init];
    [recentTabBarItem  setFinishedSelectedImage: [UIImage imageNamed: @"fav_on"]
                    withFinishedUnselectedImage: [UIImage imageNamed: @"fav"]];
    [recentNavigationProductsController setTabBarItem: recentTabBarItem];
    [viewControllers addObject:recentNavigationProductsController];
    
	tabBarController.delegate = self;
	tabBarController.viewControllers = viewControllers;
    
    [self.window addSubview:[tabBarController view]];
    self.window.rootViewController = tabBarController;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
