#import "ETDWoodTower.h"

static NSArray *normalImages;
static NSArray *shootImages;
static NSDictionary *woodTowerInfo;

@implementation ETDWoodTower

@synthesize targets;
@synthesize targetLimit;

//animations related
#define towerImageType @".PNG"
#define towerNormalPrefix @"wood_normal_"
#define towerNormalImageNum 1
#define normalAnimationDuration 0.1
#define towerShootPrefix @"wood_shoot_"
#define towerShootImageNum 1
#define towerCeasePrefix @"wood_cease_"
#define towerCeaseImageNum 1
#define shootAnimationDuration 0.1
//file related
#define woodTowerInfoPlistName (@"ETDWoodTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    NSDictionary* temp = [self loadGeneralDataFromDictionary:generalDic];
    targetLimit = [[temp objectForKey:splitAttackTargetNumber] intValue];
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl
{
	if (self = [super initWithDelegate:del withLevel:lvl]) 
    {
        towerType = kWoodTower;
        elementType = kWood;
        NSDictionary *generalDic = [ETDWoodTower getInfoForWoodTower];
        targets = [NSMutableArray array];
        [self loadDataFromDictionary:generalDic];
		if (level == 1) {
			towerValue = buildCost;
		}
	}
	return self;
}

- (void)upgrade
{
    [super upgrade];
    NSDictionary *generalDic = [ETDWoodTower getInfoForWoodTower];
    [self loadDataFromDictionary:generalDic];
}

+(NSDictionary*)getInfoForWoodTower
{
    if(woodTowerInfo == nil){
        woodTowerInfo = [ETDTower getDataForTowerFromFile:woodTowerInfoPlistName];
    }
    return woodTowerInfo;
}

+(NSArray*)getWoodNormalAnimationImageArray
{
    if(normalImages == nil){
        normalImages = [ETDTower getNormalAnimationImageArray:towerNormalPrefix 
                                                             :towerImageType :towerNormalImageNum];
    }
    return normalImages;
}

+(NSArray*)getWoodShootAnimationImageArray
{
    if(shootImages == nil){
        shootImages = [ETDTower getShootAnimationImageArray:towerShootPrefix :towerCeasePrefix 
                                                           :towerImageType :towerShootImageNum :towerCeaseImageNum];
    }
    return shootImages;
}

-(void)loadNormalAnimation
{
    [self loadNormalAnimationWithImageArray:[ETDWoodTower getWoodNormalAnimationImageArray] 
                                   Duration:normalAnimationDuration];
}

-(void)loadShootAnimation
{
    [self loadShootAnimationWithImageArray:[ETDWoodTower getWoodShootAnimationImageArray]  
                                  Duration:shootAnimationDuration];
}

#pragma mark - Split attack

- (void)addTarget:(ETDCreep *)creep {
	if ([targets containsObject:creep]) {
		return;
	}
	//
	if (self.targets.count < targetLimit) {
		[self.targets addObject:creep];
	} else {
		[self.targets removeObjectAtIndex:0];
		[self.targets addObject:creep];
	}
}

- (void)attackCreep:(ETDCreep *)target 
{
    [self loadShootAnimation];
    cdState = cooldown;
    if (![targets containsObject:target]){
        //new target being added, attack new target only
        [targets addObject:target];
        ETDProjectile *proj = [ETDProjectileFactory createProjectileOfType:towerType initialPosition:position withTarget:target projectileLevel:level Delegate:delegate];
        [delegate addProjectileToGame:proj];
    }
    else {
        //no new targets being added, attack all targets 
        for(ETDCreep* temp in targets){
            ETDProjectile *proj = [ETDProjectileFactory createProjectileOfType:towerType initialPosition:position withTarget:temp projectileLevel:level Delegate:delegate];
            [delegate addProjectileToGame:proj];
        }
    }
}

- (void)getTargetsForSplitAttack 
{
    // wood tower will handle the target selection himself
    if ((cdState == cooldown || cdState == 0) && targets.count <targetLimit)
    {
//        NSArray *tars = [delegate selectTargetsForSplitAttack:position 
//                                                             :attackRadius :(targetLimit-targets.count) :targets];
		while (targets.count < targetLimit) {
			ETDCreep *creep = [delegate getNearestCreepToPosition:position excludeCreeps:targets];
			if (creep && [self canAttackCreep:creep]) {
				[targets addObject:creep];
				[self attackCreep:creep];
			} else {
				break;
			}
		}
//        for (ETDCreep* temp in tars)
//            if (temp != nil)
//                [self attackCreep:temp];
    }
}

- (void)updateStatus {
    BOOL canAttack = NO;
    NSMutableArray *toSwap = [NSMutableArray array];
    if (cdState > 0)
        cdState -= 1;
    if (targets.count > 0 && cdState == 0) {
        //if indeed can attack, remove those the tower cannot reach to facilitate 
        //addition of targets later. 
        for (ETDCreep* temp in targets){
            if ([self canAttackCreep: temp]){
                [toSwap addObject:temp];
                canAttack = YES;
            }
        }
        targets = toSwap;
    }
    [self getTargetsForSplitAttack];
    if (cdState == 0 && targets.count > 0)
        [self attackCreep:[targets objectAtIndex:0]];
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    [self loadNormalAnimation];
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
}

@end
