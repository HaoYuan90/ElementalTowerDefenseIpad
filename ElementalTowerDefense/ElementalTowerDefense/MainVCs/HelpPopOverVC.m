//
//  HelpPopOverVC.m
//  ElementalTowerDefense
//
//  Created by Nguyen Ngoc Trung on 4/9/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import "HelpPopOverVC.h"

@implementation HelpPopOverVC

#define loreFrame CGRectMake(0, 25, 1024, 700)
#define loreBookImage @"LoreBook.png"

@synthesize delegate;
@synthesize scrollView;

- (void)closeHelp {
	[delegate closeHelp];
	[self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (id)initWithDelegate:(id<HelpPopOverDelegate>)del {
	if (self = [super init]) {
		delegate = del;
	}
	return self;
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:loreBookImage]];
	scrollView = [[UIScrollView alloc] init];
	scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
	scrollView.contentSize = imageView.frame.size;
	scrollView.frame = loreFrame;
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	[scrollView addSubview:imageView];
	self.scrollView.userInteractionEnabled = YES;
	[self.view addSubview:scrollView];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeHelp)];
	tap.numberOfTapsRequired = 2;
	[self.view addGestureRecognizer:tap];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
