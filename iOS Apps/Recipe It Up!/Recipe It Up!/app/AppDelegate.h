//
//  AppDelegate.h
//  app
//
//  Created by Mark Evans on 8/27/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CRTabBarControllerDelegate>
{
    NSMutableArray *products;
	NSInteger currentProduct;
    NSMutableArray *allproducts;
	NSInteger allcurrentProduct;
}

@property (nonatomic, retain) NSMutableArray *products;

@property (nonatomic, assign) NSInteger currentProduct;

@property (nonatomic, retain) NSMutableArray *allproducts;

@property (nonatomic, assign) NSInteger allcurrentProduct;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSString *webURL;

@property (strong, nonatomic) NSString *theLat;

@property (strong, nonatomic) NSString *theLon;

@property (strong, nonatomic) NSString *querySearch;

@property (strong, nonatomic) NSMutableArray *savedRecipes;

@end
