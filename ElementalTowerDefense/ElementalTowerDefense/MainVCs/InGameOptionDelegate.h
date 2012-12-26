//
//  InGameOptionDelegate.h
//  ElementalTowerDefense
//
//  Created by Nguyen Ngoc Trung on 4/8/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InGameOptionDelegate <NSObject>

- (void)restartPressed;
- (void)goToMainMenuPressed;
- (void)goToLevelSelectionPressed;
- (void)resumeGame;

@end
