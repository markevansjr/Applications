//
//  CustomCell2.h
//  app
//
//  Created by Mark Evans on 8/27/12.
//  Copyright (c) 2012 Mark Evans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell2 : UITableViewCell
{
    IBOutlet UILabel *statusLabel;
    IBOutlet UILabel *sourceLabel;
    IBOutlet UIImageView *thumbnailPic;
}
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *sourceLabel;
@property (nonatomic, strong) UIImageView *thumbnailPic;

@end