#import "ETDEarthTower.h"

static NSArray *normalImages;
static NSArray *shootImages;
static NSDictionary *earthTowerInfo;

@implementation ETDEarthTower

//animations related
#define towerImageType @".PNG"
#define towerNormalPrefix @"earth_normal_"
#define towerNormalImageNum 1
#define normalAnimationDuration 0.1
#define towerShootPrefix @"earth_shoot_"
#define towerShootImageNum 1
#define towerCeasePrefix @"earth_cease_"
#define towerCeaseImageNum 1
#define shootAnimationDuration 0.1
//file related
#define earthTowerInfoPlistName (@"ETDEarthTowerInfo")
#define levelToUnlockPower 5

@synthesize cooldownBar;

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    NSDictionary *levelInfo = [self loadGeneralDataFromDictionary:generalDic];
	if (level >= levelToUnlockPower) {
		specialAbilityCD = [[levelInfo valueForKey:specialAbilityCooldownTag] doubleValue];
	}
    specialAbilityCDState = specialAbilityCD;
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl
{
	if (self = [super initWithDelegate:del withLevel:lvl]) 
    {
        towerType = kEarthTower;
        elementType = kEarth;
        NSDictionary *generalDic = [ETDEarthTower getInfoForEarthTower];
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
    NSDictionary *generalDic = [ETDEarthTower getInfoForEarthTower];
    [self loadDataFromDictionary:generalDic];
	if (level == maxLevel) {
//		// create CooldownBar backgroup
//		UIView *cooldownBarBackground = [[UIView alloc] initWithFrame:CGRectMake(self.rightButton.frame.origin.x + self.rightButton.frame.size.width - 10, 20, 10, 60)];
//		cooldownBarBackground.backgroundColor = [UIColor grayColor];
//		[self.view addSubview:cooldownBarBackground];
//		//
//		cooldownBar = [[UIView alloc] initWithFrame:CGRectMake(cooldownBarBackground.frame.origin.x, cooldownBarBackground.frame.origin.y, cooldownBarBackground.frame.size.width, 0)];
//		cooldownBar.backgroundColor = [UIColor blueColor];
//		[self.view addSubview:cooldownBar];
	}
}

- (void)invokeSpecialAbility {
	[delegate chooseNewPositionForEarthTower:self];
}

+(NSDictionary*)getInfoForEarthTower
{
    if(earthTowerInfo == nil){
        earthTowerInfo = [ETDTower getDataForTowerFromFile:earthTowerInfoPlistName];
    }
    return earthTowerInfo;
}

+(NSArray*)getEarthNormalAnimationImageArray
{
    if(normalImages == nil){
        normalImages = [ETDTower getNormalAnimationImageArray:towerNormalPrefix 
                                                             :towerImageType :towerNormalImageNum];
    }
    return normalImages;
}

+(NSArray*)getEarthShootAnimationImageArray
{
    if(shootImages == nil){
        shootImages = [ETDTower getShootAnimationImageArray:towerShootPrefix :towerCeasePrefix 
                                                           :towerImageType :towerShootImageNum :towerCeaseImageNum];
    }
    return shootImages;
}

-(void)loadNormalAnimation
{
    [self loadNormalAnimationWithImageArray:[ETDEarthTower getEarthNormalAnimationImageArray] 
                                   Duration:normalAnimationDuration];
}

-(void)loadShootAnimation
{
    [self loadShootAnimationWithImageArray:[ETDEarthTower getEarthShootAnimationImageArray]  
                                  Duration:shootAnimationDuration];
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
