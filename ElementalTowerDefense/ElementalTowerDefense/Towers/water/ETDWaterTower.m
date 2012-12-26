#import "ETDWaterTower.h"

static NSArray *normalImages;
static NSArray *shootImages;
static NSDictionary *waterTowerInfo;

@implementation ETDWaterTower

//animations related
#define towerImageType @".PNG"
#define towerNormalPrefix @"water_normal_"
#define towerNormalImageNum 1
#define normalAnimationDuration 0.1
#define towerShootPrefix @"water_shoot_"
#define towerShootImageNum 1
#define towerCeasePrefix @"water_cease_"
#define towerCeaseImageNum 1
#define shootAnimationDuration 0.1
//file related
#define waterTowerInfoPlistName (@"ETDWaterTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl
{
	if (self = [super initWithDelegate:del withLevel:lvl]) 
    {
        towerType = kWaterTower;
        elementType = kWater;
        NSDictionary *generalDic = [ETDWaterTower getInfoForWaterTower];
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
    NSDictionary *generalDic = [ETDWaterTower getInfoForWaterTower];
    [self loadDataFromDictionary:generalDic];
}

+(NSDictionary*)getInfoForWaterTower
{
    if(waterTowerInfo == nil){
        waterTowerInfo = [ETDTower getDataForTowerFromFile:waterTowerInfoPlistName];
    }
    return waterTowerInfo;
}

+(NSArray*)getWaterNormalAnimationImageArray
{
    if(normalImages == nil){
        normalImages = [ETDTower getNormalAnimationImageArray:towerNormalPrefix 
                                                             :towerImageType :towerNormalImageNum];
    }
    return normalImages;
}

+(NSArray*)getWaterShootAnimationImageArray
{
    if(shootImages == nil){
        shootImages = [ETDTower getShootAnimationImageArray:towerShootPrefix :towerCeasePrefix 
                                                           :towerImageType :towerShootImageNum :towerCeaseImageNum];
    }
    return shootImages;
}

-(void)loadNormalAnimation
{

    [self loadNormalAnimationWithImageArray:[ETDWaterTower getWaterNormalAnimationImageArray] 
                                   Duration:normalAnimationDuration];

}

-(void)loadShootAnimation
{

    [self loadShootAnimationWithImageArray:[ETDWaterTower getWaterShootAnimationImageArray]  
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
