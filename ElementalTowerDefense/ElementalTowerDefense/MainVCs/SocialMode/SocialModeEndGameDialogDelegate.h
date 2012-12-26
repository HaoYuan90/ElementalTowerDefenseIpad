//
//  SocialModeEndGameDialogDelegate.h
//  ElementalTowerDefense
//
//  Created by Leon Qiao on 11/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SocialModeEndGameDialogDelegate <NSObject>
//  end game options
- (void)restartPressed;
- (void)goToMainMenuPressed;
- (void)goToLevelSelectionPressed;
//  used for scoring
- (int) getTotalNumberOfCreeps;
- (int) getNumberOfCreepsEscaped;

@end
