//
//  SocialModeEndGameDialog.m
//  ElementalTowerDefense
//
//  Created by Leon Qiao on 11/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import "SocialModeEndGameDialog.h"

@implementation SocialModeEndGameDialog



@synthesize backgroundFrame;
@synthesize delegate;

- (id)initWithDelegate:(id<SocialModeEndGameDialogDelegate>)del {
    if (self = [super init]) {
        delegate = del;
    }
    return self;
}

#pragma mark - View lifecycle


- (void)showWinDialogWithStar:(int)stars{
        
    
    [super viewDidLoad];
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPAD_LANDSCAPE_MAX_WIDTH, IPAD_LANDSCAPE_MAX_HEIGHT)];
    // background
    backgroundFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scroll"]];
    backgroundFrame.frame = CGRectMake(IPAD_LANDSCAPE_MAX_WIDTH/2 - 200, IPAD_LANDSCAPE_MAX_HEIGHT/2 - 175, 400, 380);
    [self.view addSubview:backgroundFrame];
    
    
    UIImage *img = [UIImage imageNamed:[STARS_IMAGES objectAtIndex:stars]];
    UIImageView *starsView = [[UIImageView alloc] initWithImage:img];
    starsView.frame = CGRectMake(backgroundFrame.frame.origin.x + 120, backgroundFrame.frame.origin.y + 40, 162, 42);
    [self.view addSubview:starsView];
    
    
    // create a label to show the creep count and stars
   
    UILabel *highScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(backgroundFrame.frame.origin.x + 75,backgroundFrame.frame.origin.y + 80, 250, 50)];
    highScoreLabel.text = [NSString stringWithFormat:@"%d/%d creeps pass!",[delegate getNumberOfCreepsEscaped],[delegate getTotalNumberOfCreeps]];
    highScoreLabel.textAlignment =  UITextAlignmentCenter;
    highScoreLabel.backgroundColor =[UIColor clearColor];
    highScoreLabel.textColor = [UIColor whiteColor];
    highScoreLabel.font = [UIFont fontWithName:@"Arial" size:(30.0)];
    [self.view addSubview:highScoreLabel];
    
    
    // try again option
    UIImageView *tryAgainButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"optionRestart"]];
    tryAgainButton.frame = CGRectMake(backgroundFrame.frame.origin.x + 75, backgroundFrame.frame.origin.y + 130, 250, 50);
    tryAgainButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [tryAgainButton addGestureRecognizer:singleTap];
    [self.view addSubview:tryAgainButton];
    
    // back to levels
    UIImageView *optionGoToLevelSelection = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"optionLevelSelection"]];
    optionGoToLevelSelection.frame = CGRectOffset(tryAgainButton.frame, 0, 60);
    optionGoToLevelSelection.userInteractionEnabled = YES;
    singleTap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLevelSelectionPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [optionGoToLevelSelection addGestureRecognizer:singleTap];
    [self.view addSubview:optionGoToLevelSelection];
    
    // back to main menu
    
    UIImageView *mainMenuButton = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"optionMainMenu"]];
    mainMenuButton.frame = CGRectOffset(optionGoToLevelSelection.frame, 0, 60);
    mainMenuButton.userInteractionEnabled = YES;
    singleTap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMainMenuPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [mainMenuButton addGestureRecognizer:singleTap];
    [self.view addSubview:mainMenuButton];
    
        
    
    
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
