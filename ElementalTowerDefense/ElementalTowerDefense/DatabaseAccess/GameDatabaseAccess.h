//
//  GameDatabaseAccess.h
//  Game
//
//  Created by DINH TUAN NHU on 1/4/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GameLevelModel.h"

@interface GameDatabaseAccess : NSObject {
    sqlite3 *database;
}

- (id)init;

- (NSArray *)getLevelsWithStageId:(int)stageId;
// EFFECTS: return a NSArray of all GameLevelModels of the stage whose id is stageId in the database.

- (GameLevelModel *)getLevelModelWithId:(int)levelId;
// EFFECTS: return GameLevelModel with the levelId.

- (void)updateHighScore:(int)newHighScore levelId:(int)levelId;
// EFFECTS: update the new high score of level whose id is levelId.

- (NSString *)getStageName:(int)stageId;
// EFFECTS: return the name of the stage whose id is stageId.

@end
