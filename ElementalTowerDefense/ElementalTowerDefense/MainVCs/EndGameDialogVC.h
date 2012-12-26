//
//  InGameOptionVC.h
//  ElementalTowerDefense
//
//  Created by Nhu Dinh Tuan on 4/8/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EndGameDialogDelegate.h"

@interface EndGameDialogVC : UIViewController

@property (nonatomic, strong) UIImageView *backgroundFrame;
@property (nonatomic, weak) id <EndGameDialogDelegate> delegate;

- (id)initWithDelegate:(id<EndGameDialogDelegate>)del;
// EFFECTS: constructs an EndGameDialog with the delegate.

- (void)showWinDialogWithStar:(int)stars isHighScore:(BOOL)isHighScore nextLevelId:(int)nextLevelId;
// EFFECTS: shows the dialog when user clears the level.

- (void)showLevelFailDialog;
// EFFECTS: shows the dialog when user fails the level.
@end
