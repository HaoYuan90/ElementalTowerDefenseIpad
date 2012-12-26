#import <Foundation/Foundation.h>
#import "ETDTowers.h"

@interface ETDTowerFactory : NSObject

+ (ETDTower*)createNewTowerOfType:(TowerType)type withDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)delegate;

+ (ETDTower*)createNewTowerOfType:(TowerType)type withDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)delegate withLevel:(int)lvl;

@end
