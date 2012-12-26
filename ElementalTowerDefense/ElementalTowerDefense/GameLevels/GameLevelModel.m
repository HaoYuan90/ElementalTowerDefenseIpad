//
//  GameLevelModel.m
//  ElementalTowerDefense
//
//  Created by DINH TUAN NHU on 4/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import "GameLevelModel.h"

@implementation GameLevelModel
@synthesize levelId;
@synthesize stageId;
@synthesize name;
@synthesize initCoins;
@synthesize initLife;
@synthesize highScore;
@synthesize fileName;
@synthesize dialogs;
@synthesize nextLevelId;
@synthesize disableComboInterface;

- (id)initWithId:(int)lId stageId:(int)sId name:(NSString *)levelName initCoins:(int)coins initLife:(int)life
       highScore:(int)score fileName:(NSString *)levelFileName dialog:(NSString *)dialogContents disableCombo:(BOOL)disableCombo {
    levelId = lId;
    stageId = sId;
    name = levelName;
    initCoins = coins;
    initLife = life;
    highScore = score;
    fileName = levelFileName;
    dialogs = [dialogContents componentsSeparatedByString:@"||"];
    nextLevelId = 0;
    disableComboInterface = disableCombo;
    return self;
}

@end
