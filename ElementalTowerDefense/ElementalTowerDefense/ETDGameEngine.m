#import "ETDGameEngine.h"

@implementation ETDGameEngine

@synthesize creeps;
@synthesize towers;
@synthesize projectiles;
@synthesize waves;
@synthesize currentWave;
@synthesize displayLink;
@synthesize isGeneratingCreeps;
@synthesize delegate;
@synthesize targetCreep;
@synthesize hasFinishedCurrentWave;
@synthesize shouldTerminate;

- (void)startEngine {
    //run the game loop in another thread
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    displayLink.frameInterval = 1;
    [displayLink addToRunLoop:runLoop forMode:NSDefaultRunLoopMode];
    [runLoop run];
}

- (void)pause {
    displayLink.paused = YES;
}

- (void)resume {
    displayLink.paused = NO;
}

- (id)initWithWaves:(NSArray *)wvs andDelegate:(id<ETDGameEngineDelegate>)del {
    
    self = [super init];
    if (self) {
        // Initialize Arrays to keep the objects in game.
        creeps = [[NSMutableArray alloc] init];
        towers = [[NSMutableArray alloc] init];
        projectiles = [[NSMutableArray alloc] init];
        
        waves = wvs;
        currentWave = 0;
        isGeneratingCreeps = NO;
        hasFinishedCurrentWave = NO;
        delegate = del;
        shouldTerminate = NO;
        
        [self performSelectorInBackground:@selector(startEngine) withObject:nil];
    }
    return self;
}

- (void)addObjectToGameLogic:(id)object {
    // REQUIRES: Object must be ETDCreep, ETDTower or ETDProjectile.
    // EFFECTS: add the object to the respective array.
    
    if ([object isKindOfClass:[ETDCreep class]]) {
        [creeps addObject:object];
    } else if ([object isKindOfClass:[ETDTower class]]) {
        [towers addObject:object];
    } else if ([object isKindOfClass:[ETDProjectile class]]) {
        [projectiles addObject:object];
    }
}

- (void)removeFromGameLogic:(id)object {
    // REQUIRES: Object must be ETDCreep, ETDTower or ETDProjectile.
    // EFFECTS: remove the object to the respective array.
    
    if ([object isKindOfClass:[ETDCreep class]]) {
        [creeps removeObject:object];
    } else if ([object isKindOfClass:[ETDTower class]]) {
        [towers removeObject:object];
    } else if ([object isKindOfClass:[ETDProjectile class]]) {
        [projectiles removeObject:object];
    }
}

- (void)update {
    if (shouldTerminate){
        [displayLink invalidate];
        delegate = nil;
    } else {
        // NSLog(@"running");
        // update the status of creeps
        for (int i = creeps.count - 1; i >= 0; i--) {
            [[creeps objectAtIndex:i] updateStatus];
        }
        
        // update the status of all towers
        for (int i = towers.count - 1; i >= 0; i--) {
            [[towers objectAtIndex:i] updateStatus];
        }
        
        // update the status of all projectile
        for (int i = projectiles.count - 1; i >= 0; i--) {
            [[projectiles objectAtIndex:i] updateStatus];
        }
        
        /*
         * - check whether the tower is available to attack or not.
         * - if yes, find a creep inside the arrack range of tower and ask the tower to attack
         */
        
        for (int j = 0; j < towers.count; j++) {
            ETDTower *tower = [towers objectAtIndex:j];
            // if one creep is chose to be target creep, always consider it to attack first
            if (targetCreep && [tower canAttackCreep:targetCreep]) {
                if (tower.towerType == kWoodTower) {
                    [(ETDWoodTower *)tower addTarget:targetCreep];
                    continue;
                } else {
                    if (! tower.targetCreep.isTargetCreep)
                        tower.targetCreep = targetCreep;
                    continue;
                }
            } else {
                // if there's no target creep or the target creep cannot be attacked.
                double minDistanceToTower = INFINITY;
                int indexOfCreepToAttack = -1;
                for (int i = creeps.count - 1; i >= 0; i--) {
                    ETDCreep *creep = [creeps objectAtIndex:i];
                    if ([tower canAttackCreep:creep]) {
                        double distance = [self distanceBetweenPoint:tower.position 
                                                            andPoint:creep.position];
                        if (distance < minDistanceToTower) {
                            minDistanceToTower = distance;
                            indexOfCreepToAttack = i;
                        }
                    }
                }
                if (indexOfCreepToAttack != -1) {
                    tower.targetCreep = [creeps objectAtIndex:indexOfCreepToAttack];
                }
            }
        }
        
        // generating the creep from the current wave
        if (isGeneratingCreeps) {
            ETDWave *wave = [waves objectAtIndex:currentWave];
            [wave updateStatus];
            if ([wave hasCreep]) {
                if ([wave isAvailableToGen]) {
                    [[wave genCreep] addToGame];
                }
            } else {
                isGeneratingCreeps = NO;
                currentWave++;
            }
        } 
        else if (creeps.count == 0 && hasFinishedCurrentWave == NO) {
            [delegate didFinishCurrentWave];
            hasFinishedCurrentWave = YES;
        }
    }
}

- (BOOL)startCreepWave {
    if (isGeneratingCreeps || currentWave >= waves.count) {
        return NO;
    }
    isGeneratingCreeps = YES;
    hasFinishedCurrentWave = NO;
    return YES;
}

- (double)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    return sqrt ( pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2) );
}

- (void)removeFromRunLoop {
    shouldTerminate = YES;
}

#pragma mark - specific functions
// called from creep using delegate: creep --> tileMap -->engine
- (void)addBuffsToCreep:(ETDBuff *)buff position:(CGPoint)p {
    for (int i = creeps.count - 1; i >= 0; i--) {
        ETDCreep *creep = [creeps objectAtIndex:i];
        double distance = [self distanceBetweenPoint:p andPoint:creep.position];
        if (distance <= buff.radius) {
            [creep addBuff:[[ETDBuff alloc] initWithType:buff.type duration:buff.duration 
                                                  radius:buff.radius factor:buff.factor]];
        }
    }
}

// Perform special ability for Fire Projectile
- (void)dealFireDamage:(double)damage toAreaDefinedByCenter:(CGPoint)center andRadius:(double)radius {
	for (ETDCreep *creep in creeps) {
		if ([self distanceBetweenPoint:center andPoint:creep.position] <= radius)
			[creep hitByProjectileOfType:kFire andDamage:damage];
	}
}

//provide info for wood tower
- (NSArray *)selectTargetsForSplitAttack:(CGPoint)pos :(CGFloat)range :(int)numOfTargets :(NSMutableArray *)exclusion {
    //Effect: this function returns an array of targets for split attack 
    NSMutableArray *targets = [NSMutableArray array];
    int num = 0;

    for (int i = 0; i < creeps.count; i++) {
		ETDCreep *temp = (ETDCreep*)[creeps objectAtIndex:i];
        if (![exclusion containsObject:temp]) {
            if([self distanceBetweenPoint:temp.position andPoint:pos] <= range){
                [targets addObject:temp];
                num ++;
                if(num == numOfTargets)
                    break;
            }
        }
    }
    return [NSArray arrayWithArray:targets];
}

- (ETDCreep *)getNearestCreepToPosition:(CGPoint)pos excludeCreeps:(NSArray *)targets{
	double minDistanceToTower = INFINITY;
	int indexOfCreepToAttack = -1;
	for (int i = creeps.count - 1; i >= 0; i--) {
		ETDCreep *creep = [creeps objectAtIndex:i];
		
		if ([targets containsObject:creep])
			continue;
		
		double distance = [self distanceBetweenPoint:pos andPoint:creep.position];
		if (distance < minDistanceToTower) {
			minDistanceToTower = distance;
			indexOfCreepToAttack = i;
		}
	}
	
	if (indexOfCreepToAttack != -1) {
		return [creeps objectAtIndex:indexOfCreepToAttack];
	} else {
		return nil;
	}
}

//provide info for freeze special effect
- (NSArray *)getCreepsInsideAreaDefinedByCenter:(CGPoint)cen andRadius:(double)rad {
	NSMutableArray *returnList = [NSMutableArray arrayWithCapacity:0];
	for (int i = creeps.count - 1; i >= 0; i--) {
        ETDCreep* creep = (ETDCreep*)[creeps objectAtIndex:i];
		if ([self distanceBetweenPoint:creep.position andPoint:cen] <= rad) {
			[returnList addObject:creep];
		}
	}
	return [NSArray arrayWithArray:returnList];
}

//provide info for pushing to the backend
- (NSArray *)getTowersInfo{
    NSMutableArray *info_towers = [[NSMutableArray alloc] init];
    for (int i =0; i < towers.count; i++) {
        ETDTower *tower = [towers objectAtIndex:i];
        NSMutableArray *info_tower = [[NSMutableArray alloc] init];
        [info_tower addObject: [NSNumber numberWithInt:tower.towerType]]; // tower type
        [info_tower addObject: [NSNumber numberWithInt:tower.level]]; // tower level
        [info_tower addObject: [NSNumber numberWithInt:[delegate tileNumberOfPoint:tower.position]]]; // tower position
        [info_towers addObject: info_tower];
    }
    return info_towers;
}
@end

