//
//  CustomCell.h
//  app
//
//  Created by Mark Evans on 8/27/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLStarRatingControl.h"

@interface CustomCell : UITableViewCell <DLStarRatingDelegate>
{
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *sourceLabel;
    IBOutlet UIImageView *thumbnailPic;
    IBOutlet DLStarRatingControl *starControl;
}
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UIImageView *thumbnailPic;
@property (nonatomic, strong) DLStarRatingControl *starControl;

@end
