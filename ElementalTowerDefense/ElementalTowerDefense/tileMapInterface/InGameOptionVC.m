//
//  InGameOptionVC.m
//  ElementalTowerDefense
//
//  Created by Nguyen Ngoc Trung on 4/8/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import "InGameOptionVC.h"

#define backgroundImageFrame CGRectMake(310,150,400,450)
#define backgroundImage @"scroll"
#define restartImage @"optionRestart"
#define mainMenuImage @"optionMainMenu"
#define levelSelectionImage @"optionLevelSelection"
#define resumeImage @"optionResume"

@implementation InGameOptionVC

@synthesize optionRestart;
@synthesize optionGoToMainMenu;
@synthesize optionGoToLevelSelection;
@synthesize backgroundFrame;
@synthesize dismissButton;
@synthesize delegate;

- (id)initWithDelegate:(id<InGameOptionDelegate>)del {
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
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPAD_LANDSCAPE_MAX_WIDTH, IPAD_LANDSCAPE_MAX_HEIGHT)];
	// background
	backgroundFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:backgroundImage]];
	backgroundFrame.frame = backgroundImageFrame;
	[self.view addSubview:backgroundFrame];
	
	// option restart
	optionRestart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:restartImage]];
	optionRestart.frame = CGRectMake(backgroundFrame.frame.origin.x + 75, backgroundFrame.frame.origin.y + 75, 250, 50);
	optionRestart.userInteractionEnabled = YES;
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartPressed:)];
	singleTap.numberOfTapsRequired = 1;
	[optionRestart addGestureRecognizer:singleTap];
	[self.view addSubview:optionRestart];
	
	// option main menu
	optionGoToMainMenu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:mainMenuImage]];
	optionGoToMainMenu.frame = CGRectOffset(optionRestart.frame, 0, 75);
	optionGoToMainMenu.userInteractionEnabled = YES;
	singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMainMenuPressed:)];
	singleTap.numberOfTapsRequired = 1;
	[optionGoToMainMenu addGestureRecognizer:singleTap];
	[self.view addSubview:optionGoToMainMenu];
	
	// option level selection
	optionGoToLevelSelection = [[UIImageView alloc] initWithImage:[UIImage imageNamed:levelSelectionImage]];
	optionGoToLevelSelection.frame = CGRectOffset(optionGoToMainMenu.frame, 0, 75);
	optionGoToLevelSelection.userInteractionEnabled = YES;
	singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLevelSelectionPressed:)];
	singleTap.numberOfTapsRequired = 1;
	[optionGoToLevelSelection addGestureRecognizer:singleTap];
	[self.view addSubview:optionGoToLevelSelection];
	
	// dismiss button
	dismissButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:resumeImage]];
	dismissButton.frame = CGRectOffset(optionGoToLevelSelection.frame, 0, 75);
	dismissButton.userInteractionEnabled = YES;
	singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissButtonPressed:)];
	singleTap.numberOfTapsRequired = 1;
	[dismissButton addGestureRecognizer:singleTap];
	[self.view addSubview:dismissButton];
}

- (void)restartPressed:(UITapGestureRecognizer*) gesture {
	[delegate restartPressed];
}

- (void)goToMainMenuPressed:(UITapGestureRecognizer*) gesture {
	[delegate goToMainMenuPressed];
}

- (void)goToLevelSelectionPressed:(UITapGestureRecognizer*) gesture {
	[delegate goToLevelSelectionPressed];
}

- (void)dismissButtonPressed:(UITapGestureRecognizer*) gesture {
	[delegate resumeGame];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
