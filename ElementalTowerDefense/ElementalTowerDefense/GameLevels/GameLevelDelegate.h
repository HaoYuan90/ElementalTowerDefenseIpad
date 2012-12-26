//
//  GameLevelDelegate.h
//  ElementalTowerDefense
//
//  Created by DINH TUAN NHU on 4/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameLevelDelegate <NSObject>
- (void)playGame:(GameLevelModel *)levelModel;
@end
