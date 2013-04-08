//
//  DetailsViewController.h
//  weddingsnap
//
//  Created by Mark Evans on 4/8/13.
//  Copyright (c) 2013 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
{
    NSURL *_theUrl;
    NSString *_theNumber;
    IBOutlet UIImageView *imageView;
}
-(void)passImageURL:(NSURL*)url passPosition:(NSString*)pos;

@property (nonatomic, retain) NSURL *_theUrl;
@property (nonatomic) NSString *_theNumber;

@end
