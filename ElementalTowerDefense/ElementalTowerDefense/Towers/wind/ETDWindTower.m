#import "ETDWindTower.h"

static NSArray *normalImages;
static NSArray *shootImages;
static NSDictionary *windTowerInfo;

@implementation ETDWindTower

//animations related
#define towerImageType @".PNG"
#define towerNormalPrefix @"wind_normal_"
#define towerNormalImageNum 1
#define normalAnimationDuration 0.1
#define towerShootPrefix @"wind_shoot_"
#define towerShootImageNum 1
#define towerCeasePrefix @"wind_cease_"
#define towerCeaseImageNum 1
#define shootAnimationDuration 0.1
//file related
#define windTowerInfoPlistName (@"ETDWindTowerInfo")

- (BOOL)isPositionInsideWindAura:(CGPoint)pos {
	if (sqrt(pow(self.position.x - pos.x, 2) + pow(self.position.y - pos.y, 2)) <= self.attackRadius) {
		return YES;
	} else {
		return NO;
	}
}

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl
{
	if (self = [super initWithDelegate:del withLevel:lvl]) 
    {
        towerType = kWindTower;
        elementType = noElement;
        NSDictionary *generalDic = [ETDWindTower getInfoForWindTower];
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
    NSDictionary *generalDic = [ETDWindTower getInfoForWindTower];
    [self loadDataFromDictionary:generalDic];
}

+(NSDictionary*)getInfoForWindTower
{
    if(windTowerInfo == nil){
        windTowerInfo = [ETDTower getDataForTowerFromFile:windTowerInfoPlistName];
    }
    return windTowerInfo;
}

+(NSArray*)getWindNormalAnimationImageArray
{
    if(normalImages == nil){
        normalImages = [ETDTower getNormalAnimationImageArray:towerNormalPrefix 
                                                             :towerImageType :towerNormalImageNum];
    }
    return normalImages;
}

+(NSArray*)getWindShootAnimationImageArray
{
    if(shootImages == nil){
        shootImages = [ETDTower getShootAnimationImageArray:towerShootPrefix :towerCeasePrefix 
                                                           :towerImageType :towerShootImageNum :towerCeaseImageNum];
    }
    return shootImages;
}

-(void)loadNormalAnimation
{
    [self loadNormalAnimationWithImageArray:[ETDWindTower getWindNormalAnimationImageArray] 
                                   Duration:normalAnimationDuration];
}

-(void)loadShootAnimation
{
    [self loadShootAnimationWithImageArray:[ETDWindTower getWindShootAnimationImageArray]  
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
