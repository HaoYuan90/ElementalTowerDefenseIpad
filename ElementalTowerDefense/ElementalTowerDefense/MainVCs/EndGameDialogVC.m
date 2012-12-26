//
//  InGameOptionVC.m
//  ElementalTowerDefense
//
//  Created by Nhu Dinh Tuan on 4/8/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import "EndGameDialogVC.h"
#define TEXT_HIGH_SCORE @"HIGH SCORE!"
@implementation EndGameDialogVC
@synthesize backgroundFrame;
@synthesize delegate;

- (id)initWithDelegate:(id<EndGameDialogDelegate>)del {
    // EFFECTS: constructs an EndGameDialog with the delegate.
    
    if (self = [super init]) {
        delegate = del;
        self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPAD_LANDSCAPE_MAX_WIDTH, IPAD_LANDSCAPE_MAX_HEIGHT)];
        // background
        backgroundFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:SCROLL_IMG]];
        backgroundFrame.frame = CGRectMake(IPAD_LANDSCAPE_MAX_WIDTH/2 - 200, IPAD_LANDSCAPE_MAX_HEIGHT/2 - 175, 400, 380);
    }
    return self;
}

#pragma mark - View lifecycle

- (void)showWinDialogWithStar:(int)stars isHighScore:(BOOL)isHighScore nextLevelId:(int)nextLevelId {
    // EFFECTS: shows the dialog when user clears the level.
    
    // remove all subviews.
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    
    // add background.
    [self.view addSubview:backgroundFrame];
    
    // add star rating images.
    UIImage *img = [UIImage imageNamed:[STARS_IMAGES objectAtIndex:stars]];
    UIImageView *starsView = [[UIImageView alloc] initWithImage:img];
    starsView.frame = CGRectMake(backgroundFrame.frame.origin.x + 120, backgroundFrame.frame.origin.y + 40, 162, 42);
    [self.view addSubview:starsView];

    int init_gap = 100;
    
    // create a label to show the high score of game level
    if (isHighScore) {
        UILabel *highScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(backgroundFrame.frame.origin.x + 75, backgroundFrame.frame.origin.y + 85, 250, 35)];
        highScoreLabel.text = TEXT_HIGH_SCORE;
        highScoreLabel.textAlignment =  UITextAlignmentCenter;
        highScoreLabel.backgroundColor =[UIColor clearColor];
        highScoreLabel.textColor = [UIColor whiteColor];
        highScoreLabel.font = [UIFont fontWithName:@"Arial" size:(30.0)];
        [self.view addSubview:highScoreLabel];
        init_gap += 20;
    }
    
    // option to share the map with friends
    UIImageView *optionShare = [[UIImageView alloc] initWithImage:[UIImage imageNamed:OPTION_SHARE_IMG]];
    optionShare.frame = CGRectMake(backgroundFrame.frame.origin.x + 75, backgroundFrame.frame.origin.y + init_gap, 250, 50);
    optionShare.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToServerPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [optionShare addGestureRecognizer:singleTap];
    [self.view addSubview:optionShare];
    
    int gap = 50; // the distance between the labels
    int number_gap = 1; 
    
    // option next level
    if (nextLevelId > 0) {        
        UIImageView *optionGoToNextLevel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:OPTION_NEXT_LEVEL_IMG]];
        optionGoToNextLevel.frame = CGRectOffset(optionShare.frame, 0, number_gap * gap);
        optionGoToNextLevel.userInteractionEnabled = YES;
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToNextLevelPressed:)];
        singleTap.numberOfTapsRequired = 1;
        [optionGoToNextLevel addGestureRecognizer:singleTap];
        [self.view addSubview:optionGoToNextLevel];
        number_gap++;
    }
    
    // option restart
    UIImageView *optionRestart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:OPTION_RESTART_IMG]];
    optionRestart.frame = CGRectOffset(optionShare.frame, 0, number_gap * gap);
    optionRestart.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [optionRestart addGestureRecognizer:singleTap];
    [self.view addSubview:optionRestart];
    number_gap++;
    
    // option level selection
    UIImageView *optionGoToLevelSelection = [[UIImageView alloc] initWithImage:[UIImage imageNamed:OPTION_LEVEL_SELECTION_IMG]];
    optionGoToLevelSelection.frame = CGRectOffset(optionShare.frame, 0, number_gap * gap);
    optionGoToLevelSelection.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLevelSelectionPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [optionGoToLevelSelection addGestureRecognizer:singleTap];
    [self.view addSubview:optionGoToLevelSelection];
}

- (void)showLevelFailDialog {
    // EFFECTS: shows the dialog when user fails the level.
    
    // remove all subviews.
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    
    // add background
    [self.view addSubview:backgroundFrame];
    
    int gap = 60; // the distance between the labels
    int number_gap = 1; 
    
    UILabel *levelFailLabel = [[UILabel alloc] initWithFrame:CGRectMake(backgroundFrame.frame.origin.x + 75, backgroundFrame.frame.origin.y + number_gap * gap, 250, 50)];
    levelFailLabel.text = @"LEVEL FAILED!";
    levelFailLabel.textAlignment =  UITextAlignmentCenter;
    levelFailLabel.backgroundColor =[UIColor clearColor];
    levelFailLabel.textColor = [UIColor whiteColor];
    levelFailLabel.font = [UIFont fontWithName:@"Arial" size:(30.0)];
    [self.view addSubview:levelFailLabel];
    number_gap++;
    
    // option restart
    UIImageView *optionRestart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:OPTION_RESTART_IMG]];
    optionRestart.frame = CGRectMake(backgroundFrame.frame.origin.x + 75, backgroundFrame.frame.origin.y + number_gap * gap, 250, 50);
    optionRestart.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restartPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [optionRestart addGestureRecognizer:singleTap];
    [self.view addSubview:optionRestart];
    number_gap++;
    
    // option level selection
    UIImageView *optionGoToLevelSelection = [[UIImageView alloc] initWithImage:[UIImage imageNamed:OPTION_LEVEL_SELECTION_IMG]];
    optionGoToLevelSelection.frame = CGRectMake(backgroundFrame.frame.origin.x + 75, backgroundFrame.frame.origin.y + number_gap * gap, 250, 50);
    optionGoToLevelSelection.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToLevelSelectionPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [optionGoToLevelSelection addGestureRecognizer:singleTap];
    [self.view addSubview:optionGoToLevelSelection];
    number_gap++;
    
    // option main menu
    UIImageView *optionGoToMainMenu = [[UIImageView alloc] initWithImage:[UIImage imageNamed:OPTION_MAIN_MENUE_IMG]];
    optionGoToMainMenu.frame = CGRectMake(backgroundFrame.frame.origin.x + 75, backgroundFrame.frame.origin.y + number_gap * gap, 250, 50);
    optionGoToMainMenu.userInteractionEnabled = YES;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToMainMenuPressed:)];
    singleTap.numberOfTapsRequired = 1;
    [optionGoToMainMenu addGestureRecognizer:singleTap];
    [self.view addSubview:optionGoToMainMenu];
    number_gap++;
}

- (void)restartPressed:(UITapGestureRecognizer *) gesture {
    [self.view removeFromSuperview];
    [delegate restartPressed];
}

- (void)pushToServerPressed:(UITapGestureRecognizer *) gesture {
    [delegate pushToServerPressed];
}

- (void)goToNextLevelPressed:(UITapGestureRecognizer *) gesture {
    [delegate goToNextLevelPressed];
}

- (void)goToLevelSelectionPressed:(UITapGestureRecognizer *) gesture {
    [self.view removeFromSuperview];
    [delegate goToLevelSelectionPressed];
}

- (void)goToMainMenuPressed:(UITapGestureRecognizer *) gesture {
    [self.view removeFromSuperview];
    [delegate goToMainMenuPressed];
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

@end
