//
// DemoTableViewController.m
// Created by cocopon on 2012/05/15.
//
// Copyright (c) 2012 cocopon <cocopon@me.com>
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

#import "DemoTableViewController.h"
#import "SpecialRecipeViewController.h"
#import "CustomCell.h"
#import  <MediaPlayer/MediaPlayer.h>

#define kCellIdentifier  @"UITableViewCell"
#define kNavigationTitle @"Recipes of the Day"


@interface DemoTableViewController()

@property (nonatomic, readonly, retain) NSArray *texts;

+ (NSArray*)testData;

@end


@implementation DemoTableViewController {
@private
	NSArray *texts_;
}


- (void)dealloc {
	[texts_ release];
	[super dealloc];
}


#pragma mark -
#pragma mark Property


- (NSArray*)texts {
	if (texts_ == nil) {
		texts_ = [[DemoTableViewController testData] retain];
	}
	return texts_;
}


#pragma mark -


+ (NSArray*)testData {
	NSMutableArray *data = [[[NSMutableArray alloc] init] autorelease];
	
	NSString *entree = @"Shrimp Scampi";
    [data addObject:entree];
	
	return data;
}


#pragma mark -
#pragma mark UITableViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.texts count];
}


- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
    CustomCell *cell = (CustomCell *)[nib objectAtIndex:0];
    if (cell != nil)
    {
        UIImage *imgdefault = [UIImage imageNamed:@"shrimppic.png"];
        [cell.thumbnailPic setImage:imgdefault];
        //NSString *ratingNumber = [[NSString alloc]initWithFormat:@"99.998"];
        [cell.starControl setHidden:true];
        NSString *text = [self.texts objectAtIndex:[indexPath row]];
        cell.statusLabel.text = text;
        cell.sourceLabel.text = @"Southern Living";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.0f;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	[tableView deselectRowAtIndexPath:indexPath
							 animated:YES];
	//SpecialRecipeViewController *recipeOfTheDayView = [[SpecialRecipeViewController alloc]init];
    //[self presentModalViewController:recipeOfTheDayView animated:true];
    
    NSString *filePath = @"http://www.markevansjr.com/video/video_recipe_of_the_day.m4v";
    NSURL *fileURL = [NSURL URLWithString:filePath];
    movieViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:fileURL];
    [self presentMoviePlayerViewControllerAnimated:movieViewController];
}


#pragma mark -
#pragma mark UIViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	[self.navigationItem setTitle:kNavigationTitle];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	if (toInterfaceOrientation)
    {
        return UIInterfaceOrientationMaskLandscape;
    }
    return YES;
}


@end
