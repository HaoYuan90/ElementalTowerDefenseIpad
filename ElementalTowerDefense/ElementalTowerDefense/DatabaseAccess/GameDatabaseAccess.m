//
//  GameDatabaseAccess.m
//  Game
//
//  Created by DINH TUAN NHU on 23/2/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "GameDatabaseAccess.h"

@implementation GameDatabaseAccess

- (id)init {
    
    self = [super init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *writableDBPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_NAME];
    
    // if the database does not exist, copy the default to the appropriate location.
    if (![[NSFileManager defaultManager] fileExistsAtPath:writableDBPath]) {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATABASE_NAME];
        
        // copy unsuccessfully
        if (![[NSFileManager defaultManager] copyItemAtPath:defaultDBPath toPath:writableDBPath error:nil]) {
            return nil;
        }
    }
    
    // init database
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:DATABASE_NAME];
    if (sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
        return self;
    } else {
        return nil;
    }
}

- (NSArray *)getLevelsWithStageId:(int)stageId {
    // EFFECTS: return a NSArray of all GameLevelModels of the stage whose id is stageId in the database.
    
    if (self) {
        const char *sql = [[NSString stringWithFormat: @"SELECT * FROM levels where stage_id = %d ORDER BY id", stageId] UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            NSMutableArray *gameLevelModels = [[NSMutableArray alloc] init];
            int count = 0;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                GameLevelModel *level = [[GameLevelModel alloc] initWithId:sqlite3_column_int(statement, 0) 
                                                                   stageId:sqlite3_column_int(statement, 1) 
                                                                      name:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] 
                                                                 initCoins:sqlite3_column_int(statement, 4)  
                                                                  initLife:sqlite3_column_int(statement, 3)  
                                                                 highScore:sqlite3_column_int(statement, 5)  
                                                                  fileName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] 
                                                                    dialog:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] 
                                                              disableCombo:sqlite3_column_int(statement, 8)];
                
                [gameLevelModels addObject:level];
                if (count != 0) {
                    [[gameLevelModels objectAtIndex:(count-1)] setNextLevelId:level.levelId];
                }
                count++;
            }
            return [[NSArray alloc] initWithArray:gameLevelModels];
        } else {
            return nil;
        }
    } else {
        return nil;
    }

}

- (GameLevelModel *)getLevelModelWithId:(int)levelId {
    // EFFECTS: return GameLevelModel with the levelId.
    
    if (self) {
        const char *sql = [[NSString stringWithFormat: @"SELECT * FROM levels where id >= %d LIMIT 2", levelId] UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            int count = 0;
            GameLevelModel *level;
            while (sqlite3_step(statement) == SQLITE_ROW) {
                if (count == 0) {
                    level = [[GameLevelModel alloc] initWithId:sqlite3_column_int(statement, 0) 
                                                       stageId:sqlite3_column_int(statement, 1) 
                                                          name:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] 
                                                     initCoins:sqlite3_column_int(statement, 4)  
                                                      initLife:sqlite3_column_int(statement, 3)  
                                                     highScore:sqlite3_column_int(statement, 5)  
                                                      fileName:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)] 
                                                        dialog:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] 
                                                  disableCombo:sqlite3_column_int(statement, 8)];
                } else {
                    [level setNextLevelId:sqlite3_column_int(statement, 0)];
                }
                count++;
            }
            sqlite3_finalize(statement);
            return level;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)updateHighScore:(int)newHighScore levelId:(int)levelId {
    // EFFECTS: update the new high score of level whose id is levelId.
    
    const char *sql = [[NSString stringWithFormat: @"UPDATE levels SET high_score = %d WHERE id = %d", newHighScore, levelId] UTF8String];
    sqlite3_exec(database, sql, NULL, NULL, NULL) ;
}


- (NSString *)getStageName:(int)stageId {
    // EFFECTS: return the name of the stage whose id is stageId.
    
    if (self) {
        const char *sql = [[NSString stringWithFormat: @"SELECT * FROM stages where id = %d", stageId] UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_step(statement);
            NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            sqlite3_finalize(statement);
            return name;
        } else {
            return nil;
        }
    } else {
        return nil;
    }

}
@end
