#import "ETDFireTower.h"

static NSArray *normalImages;
static NSArray *shootImages;
static NSDictionary *fireTowerInfo;

@implementation ETDFireTower

//animations related
#define towerImageType @".PNG"
#define towerNormalPrefix @"fire_normal_"
#define towerNormalImageNum 3
#define towerShootPrefix @"fire_shoot_"
#define towerShootImageNum 9
#define towerCeasePrefix @"fire_cease_"
#define towerCeaseImageNum 4

#define normalAnimationDuration 0.1
#define shootAnimationDuration 0.1
//file related
#define fireTowerInfoPlistName (@"ETDFireTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl
{
	if (self = [super initWithDelegate:del withLevel:lvl]) 
    {
        towerType = kFireTower;
        elementType = kFire;
        NSDictionary *generalDic = [ETDFireTower getInfoForFireTower];
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
    NSDictionary *generalDic = [ETDFireTower getInfoForFireTower];
    [self loadDataFromDictionary:generalDic];
}


+(NSDictionary*)getInfoForFireTower
{
    if(fireTowerInfo == nil){
        fireTowerInfo = [ETDTower getDataForTowerFromFile:fireTowerInfoPlistName];
    }
    return fireTowerInfo;
}

+(NSArray*)getFireNormalAnimationImageArray
{
    if(normalImages == nil){
        normalImages = [ETDTower getNormalAnimationImageArray:towerNormalPrefix 
                                                             :towerImageType :towerNormalImageNum];
    }
    return normalImages;
}

+(NSArray*)getFireShootAnimationImageArray
{
    if(shootImages == nil){
       shootImages = [ETDTower getShootAnimationImageArray:towerShootPrefix :towerCeasePrefix 
                                                          :towerImageType :towerShootImageNum :towerCeaseImageNum];
    }
    return shootImages;
}

-(void)loadNormalAnimation
{

    [self loadNormalAnimationWithImageArray:[ETDFireTower getFireNormalAnimationImageArray] 
                                   Duration:normalAnimationDuration];
}

-(void)loadShootAnimation
{
    [self loadShootAnimationWithImageArray:[ETDFireTower getFireShootAnimationImageArray]  
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
