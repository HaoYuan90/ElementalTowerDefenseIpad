//
//  InGameOptionDelegate.h
//  ElementalTowerDefense
//
//  Created by Nhu Dinh Tuan on 4/8/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EndGameDialogDelegate <NSObject>

- (void)restartPressed;
// EFFECTS: restarts the game.

- (void)pushToServerPressed;
// EFFECTS: push the map information to server to challenge the friends.

- (void)goToNextLevelPressed;
// EFFECTS: goes to the next level.

- (void)goToLevelSelectionPressed;
// EFFECTS: goes to the list levels controllers.

- (void)goToMainMenuPressed;
// EFFECTS: goes to the main menu controllers.

@end
