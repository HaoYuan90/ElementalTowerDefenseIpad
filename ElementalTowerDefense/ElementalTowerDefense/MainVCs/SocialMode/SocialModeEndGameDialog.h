//
//  SocialModeEndGameDialog.h
//  ElementalTowerDefense
//
//  Created by Leon Qiao on 11/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//  Modified From EndGameDialogVC

//  Overview
//  A end-game dialog to show a score to user
//  and provide options to "restart", "go to main menu" or "choose another friend"
#import <UIKit/UIKit.h>
#import "SocialModeEndGameDialogDelegate.h"

@interface SocialModeEndGameDialog : UIViewController

@property (nonatomic, strong) UIImageView *backgroundFrame;
@property (nonatomic, weak) id <SocialModeEndGameDialogDelegate> delegate;

- (id)initWithDelegate:(id<SocialModeEndGameDialogDelegate>)del;
- (void)showWinDialogWithStar:(int)stars;
@end