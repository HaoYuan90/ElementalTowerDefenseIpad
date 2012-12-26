//delegate mainly to handle tower's projectile
#import <Foundation/Foundation.h>

@protocol ETDTowerDelegate <NSObject>

-(CGFloat)getDataWRTMap:(CGFloat)data; 
// get the actual game distance based on map

-(void)addProjectileToGame:(id) proj;
-(void)didSelectTower:(id)tower;

- (BOOL)canUpgradeTower:(id)tower;
- (void)didUpgradeTower:(id)tower;

// wood tower target selection
-(NSArray*)selectTargetsForSplitAttack:(CGPoint)pos:(CGFloat)range:(int)numOfTargets:(NSMutableArray*)exclusion;
- (id)getNearestCreepToPosition:(CGPoint)pos excludeCreeps:(NSArray *)targets;

// remove tower from map as SELL button was pressed
- (void)soldTower:(id)tower;

// Special ability for towers
- (void)chooseNewPositionForEarthTower:(id)tower;
- (void)freezeCreepsInsideAreaDefinedByCenter:(CGPoint)cen andRadius:(double)rad andDuration:(double)dur;
@end
