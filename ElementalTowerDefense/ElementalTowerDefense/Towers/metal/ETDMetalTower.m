#import "ETDMetalTower.h"


static NSArray *normalImages;
static NSArray *shootImages;
static NSDictionary *metalTowerInfo;

@implementation ETDMetalTower

//animations related
#define towerImageType @".PNG"
#define towerNormalPrefix @"metal_normal_"
#define towerNormalImageNum 1
#define normalAnimationDuration 0.1
#define towerShootPrefix @"metal_shoot_"
#define towerShootImageNum 1
#define towerCeasePrefix @"metal_cease_"
#define towerCeaseImageNum 1
#define shootAnimationDuration 0.1
//file related
#define metalTowerInfoPlistName (@"ETDMetalTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl
{
	if (self = [super initWithDelegate:del withLevel:lvl]) 
    {
        towerType = kMetalTower;
        elementType = kMetal;
        NSDictionary *generalDic = [ETDMetalTower getInfoForMetalTower];
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
    NSDictionary *generalDic = [ETDMetalTower getInfoForMetalTower];
    [self loadDataFromDictionary:generalDic];
}

+(NSDictionary*)getInfoForMetalTower
{
    if(metalTowerInfo == nil){
        metalTowerInfo = [ETDTower getDataForTowerFromFile:metalTowerInfoPlistName];
    }
    return metalTowerInfo;
}

+(NSArray*)getMetalNormalAnimationImageArray
{
    if(normalImages == nil){
        normalImages = [ETDTower getNormalAnimationImageArray:towerNormalPrefix 
                                                             :towerImageType :towerNormalImageNum];
    }
    return normalImages;
}

+(NSArray*)getMetalShootAnimationImageArray
{
    if(shootImages == nil){
        shootImages = [ETDTower getShootAnimationImageArray:towerShootPrefix :towerCeasePrefix 
                                                           :towerImageType :towerShootImageNum :towerCeaseImageNum];
    }
    return shootImages;
}

-(void)loadNormalAnimation
{
    [self loadNormalAnimationWithImageArray:[ETDMetalTower getMetalNormalAnimationImageArray] 
                                   Duration:normalAnimationDuration];
}

-(void)loadShootAnimation
{
    [self loadShootAnimationWithImageArray:[ETDMetalTower getMetalShootAnimationImageArray]  
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
