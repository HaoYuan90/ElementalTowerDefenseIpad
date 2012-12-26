//
//  GameLevelModel.h
//  ElementalTowerDefense
//
//  Created by DINH TUAN NHU on 4/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameLevelModel : NSObject {
    int levelId;
    int stageId;
    NSString *name;
    int initCoins;
    int initLife;
    int highScore;
    NSString *fileName;
    NSArray *dialog;
    int nextLevelId;
    BOOL disableComboInterface;
}
@property (nonatomic, readonly) int levelId;
@property (nonatomic, readonly) int stageId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, readonly) int initCoins;
@property (nonatomic, readonly) int initLife;
@property (nonatomic, readwrite) int highScore;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSArray *dialogs;
@property (nonatomic, readwrite) int nextLevelId;
@property (nonatomic, readonly) BOOL disableComboInterface;

- (id)initWithId:(int)lId stageId:(int)sId name:(NSString *)levelName initCoins:(int)coins initLife:(int)life
       highScore:(int)score fileName:(NSString *)levelFileName dialog:(NSString *)dialogContents disableCombo:(BOOL)disableCombo;
// EFFECTS: Constructs a new GameLevelModel


@end