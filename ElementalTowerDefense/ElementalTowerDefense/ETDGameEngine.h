#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import "ETDCreep.h"
#import "ETDTowers.h"
#import "ETDProjectile.h"
#import "ETDWave.h"
#import "ETDGameEngineDelegate.h"

@interface ETDGameEngine : NSObject
//control booleans
@property (nonatomic, readonly) int currentWave;
@property (nonatomic, readonly, strong) NSArray *waves;
@property (nonatomic, readonly) BOOL isGeneratingCreeps;
@property (nonatomic, readonly) BOOL hasFinishedCurrentWave;
//game objects containers
@property (nonatomic, readonly, strong) NSMutableArray *creeps;
@property (nonatomic, readonly, strong) NSMutableArray *towers;
@property (nonatomic, readonly, strong) NSMutableArray *projectiles;

@property (nonatomic, readonly, strong) CADisplayLink *displayLink;
@property (nonatomic, readonly, weak) id<ETDGameEngineDelegate> delegate;

@property (nonatomic, strong) ETDCreep *targetCreep;

@property (nonatomic, readonly) BOOL shouldTerminate;

- (id)initWithWaves:(NSArray *)waves andDelegate:(id<ETDGameEngineDelegate>)del;
// EFFECTS: constructs a ETDGameEngine with the array of waves and the delegate.

- (void)addObjectToGameLogic:(id)object;
// REQUIRES: Object must be ETDCreep, ETDTower or ETDProjectile.
// EFFECTS: add the object to the respective array.

- (void)removeFromGameLogic:(id)object;
// REQUIRES: Object must be ETDCreep, ETDTower or ETDProjectile.
// EFFECTS: remove the object to the respective array.

- (void)update;
// EFFECTS: update statuses of all objects in game

- (double)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2;
// EFFECTS: returns the distance between points.

- (void)pause;
- (void)resume;
- (BOOL)startCreepWave;
- (void)removeFromRunLoop;

//methods dealing with target selection for specific functionalities
- (void)addBuffsToCreep:(ETDBuff *)buff position:(CGPoint)p;
- (NSArray *)selectTargetsForSplitAttack:(CGPoint)pos :(CGFloat)range :(int)numOfTargets :(NSMutableArray *)exclusion;

- (NSArray *)getCreepsInsideAreaDefinedByCenter:(CGPoint)cen andRadius:(double)rad;

- (NSArray *)getTowersInfo;

- (ETDCreep *)getNearestCreepToPosition:(CGPoint)pos excludeCreeps:(NSArray *)targets;

- (void)dealFireDamage:(double)damage toAreaDefinedByCenter:(CGPoint)center andRadius:(double)radius;
@end
