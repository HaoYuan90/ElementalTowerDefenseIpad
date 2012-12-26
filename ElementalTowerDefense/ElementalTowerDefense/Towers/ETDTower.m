#import "ETDTower.h"

@implementation ETDTower

#define rangeViewAnimationFadeTime 1

@synthesize towerType;
@synthesize elementType;
@synthesize position;
@synthesize level;
@synthesize maxLevel;
@synthesize attackRadius;
@synthesize cooldown;
@synthesize cdState;
@synthesize targetCreep;
@synthesize specialAbilityCD;
@synthesize specialAbilityCDState;
@synthesize delegate;
@synthesize damage;
@synthesize desc;
@synthesize currentCooldownRate;
@synthesize upgradeCost;
@synthesize towerValue;
@synthesize buildCost;
@synthesize sellingValue;

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    NSLog(@"loadDataFromDictionary is called");
    NSLog(@"this is an abstract method used for tower subclasses to load their specific data");
}

- (NSDictionary*)loadGeneralDataFromDictionary:(NSDictionary*)generalDic
{
	buildCost = [[generalDic valueForKey:towerBuildCostTag] intValue];
    //check if maxlevel is ald initialised
    if (maxLevel == 0)
        maxLevel = [[generalDic valueForKey:maxLevelTag] intValue];
    desc = [generalDic valueForKey:descTag];
    NSString *levelKey = [NSString stringWithFormat:@"%@%d", levelPrefix, level];
    NSDictionary *levelInfo = [generalDic valueForKey:levelKey];
    attackRadius = [[levelInfo valueForKey:attackRadiusTag] doubleValue];
    attackRadius = [delegate getDataWRTMap:attackRadius];
    damage = [[levelInfo valueForKey:dmgTag] doubleValue];
    cooldown = [[levelInfo valueForKey:attackCooldownTag] doubleValue];
	upgradeCost = [[levelInfo valueForKey:towerUpgradeCostTag] intValue];
	sellingValue = [[levelInfo valueForKey:towerSellingValueTag] intValue];
    return levelInfo;
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl {
	if (self = [super init]) {
        position = CGPointMake(0, 0);
        level = lvl;
        cdState = 0;
        //do not have special ability
        specialAbilityCD = -1;
        specialAbilityCDState = specialAbilityCD;
        currentCooldownRate = DEFAULT_TOWER_ATTACK_COOLDOWN;
        delegate = del;
    }
    return self;
}

- (void)upgrade
{
//    NSLog(@"upgrade is called");
//    NSLog(@"this is an abstract method used for tower to level up and load new data from respective plist");
	assert(level < maxLevel);
	if ([delegate canUpgradeTower:self]) {
		// increase Tower value
		towerValue += upgradeCost;
		[delegate didUpgradeTower:self];
		//
		level ++;
	}
}

- (void)invokeSpecialAbility {
	DLog(@"This is an abstract method and should be implemented in subclasses");
}

- (BOOL)canAttackCreep:(ETDCreep*)creep 
{
    float dx = position.x - creep.position.x;
    float dy = position.y - creep.position.y;
    float distance = sqrtf(dx * dx + dy * dy);
    return distance < attackRadius && !creep.toRemove;
}

- (void)loadNormalAnimation
{
    NSLog(@"loadNormalAnimation invoked");
    NSLog(@"this method should be overriden by childclass implementation");
}

- (void)loadShootAnimation
{
    NSLog(@"loadShootAnimation invoked");
    NSLog(@"this method should be overriden by childclass implementation");
}

- (void)attackCreep:(ETDCreep *)target 
{
    [self loadShootAnimation];
    targetCreep = target;
    cdState = cooldown;
    ETDProjectile *proj = [ETDProjectileFactory createProjectileOfType:towerType initialPosition:position withTarget:targetCreep projectileLevel:level Delegate:delegate];
    [delegate addProjectileToGame:proj];
}

- (void)updateStatus {
    if (cdState > 0)
        cdState -= currentCooldownRate;
    else if (targetCreep && [self canAttackCreep:targetCreep]) {
        [self attackCreep:targetCreep];
    }
    if(specialAbilityCD > 0){
        //has special ability
        if (specialAbilityCDState > 0){
            self.specialAbilityCDState --;
            [[NSNotificationCenter defaultCenter] postNotificationName:towerSACDStateTag object:self];
        }
    }
}

- (void)sold
{
    [delegate soldTower:self];
}

//this method for creep targetting is no longer in use
/*
- (BOOL)shouldSwitchTarget 
{
    // check if the tower should switch target.
    if (cdState) {
        return NO;
    }
    else if (targetCreep) {
        if ([self canAttackCreep:targetCreep])
            return NO;
    }
    // Passed all checking conditions
    return YES;
}*/

#pragma mark - Load animations

-(void)loadNormalAnimationWithImageArray:(NSArray*)images Duration:(NSTimeInterval)dura;
{
    if (!self.isViewLoaded){
        UIImage *defaultImage = (UIImage*)[images objectAtIndex:0];
        UIImageView *normalTower = [[UIImageView alloc] initWithImage:defaultImage];
        normalTower.animationImages = images;
        normalTower.animationDuration = dura;
        self.view = normalTower;
        [self enableTouchGesture];
        [normalTower startAnimating];
    } else {
        UIImageView *temp = (UIImageView*)self.view;
        temp.animationImages = images;
        temp.animationDuration = dura;
        [temp startAnimating];
    }
}

-(void)loadShootAnimationWithImageArray:(NSArray*)images Duration:(NSTimeInterval)dura;
{
    UIImageView *temp = (UIImageView*)self.view;
    temp.animationImages = images;
    temp.animationDuration = dura;
    [temp startAnimating];
    [self performSelector:@selector(loadNormalAnimation) withObject:nil afterDelay:dura];
}

#pragma mark - Loading related class methods

+ (NSDictionary*)getDataForTowerFromFile:(NSString*)fileName
{
    NSString *bundle = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]; 
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:bundle];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSDictionary* temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp)
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    return [temp valueForKey:towerInfoTag];
}

+ (NSArray*)getNormalAnimationImageArray:(NSString *)prefix :(NSString *)type :(int)imageNum
{
    NSMutableArray *temp = [NSMutableArray array];
    for(int i=0;i<imageNum;i++){
        NSString *imageName = [NSString stringWithFormat:@"%@%d%@",prefix,i,type];
        UIImage *normalImage = [UIImage imageNamed:imageName];
        [temp addObject:normalImage];
    }
   return [NSArray arrayWithArray:temp];
}

+ (NSArray*)getShootAnimationImageArray:(NSString *)shootPrefix :(NSString *)ceasePrefix 
                                       :(NSString *)type :(int)shootImageNum :(int)ceaseImageNum
{
    NSMutableArray *temp = [NSMutableArray array];
    for(int i=0;i<shootImageNum;i++){
        NSString *imageName = [NSString stringWithFormat:@"%@%d%@",shootPrefix,i,type];
        UIImage *shootImage = [UIImage imageNamed:imageName];
        [temp addObject:shootImage];
    }
    for(int i=0;i<ceaseImageNum;i++){
        NSString *imageName = [NSString stringWithFormat:@"%@%d%@",ceasePrefix,i,type];
        UIImage *ceaseImage = [UIImage imageNamed:imageName];
        [temp addObject:ceaseImage];
    }
    return [NSArray arrayWithArray:temp];
}

#pragma mark - Touch Gesture

- (void)enableTouchGesture
{
    [self.view setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapping = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(towerSelected:)];
    singleTapping.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapping];
}

- (void)displayRange
{
    ETDTowerRangeView *range = [[ETDTowerRangeView alloc] initWithCenter:position andRadius:attackRadius];
    [self.view.superview insertSubview:range atIndex:0];
    [UIView animateWithDuration:rangeViewAnimationFadeTime animations:^(void){
        range.alpha = 0;
    } completion:^(BOOL finished){
        [range removeFromSuperview];
    }];
}

- (void)towerSelected:(UITapGestureRecognizer*) gesture
{
    [self displayRange];
    [delegate didSelectTower:self];
}

#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

#pragma mark - Aura
- (void)addWindAuraEffect {
	self.currentCooldownRate *= WIND_AURA_MULTIPLIER;
}

- (void)removeWindAuraEffect {
	self.currentCooldownRate /= WIND_AURA_MULTIPLIER;
}

@end
