//
//  ViewController.h
//  weddingsnap
//
//  Created by Mark Evans on 4/8/13.
//  Copyright (c) 2013 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMGridView.h"

@interface ViewController : UIViewController <GMGridViewDataSource, GMGridViewActionDelegate>
{
    GMGridView *_gmGridView;
    NSMutableArray *_data;      
    NSMutableArray  *photoURLsSmallImage;
    NSMutableArray  *photoURLsLargeImage; 
    UIActivityIndicatorView *activityIndicator;
}

@end
