#import "ETDJadeTower.h"

static NSArray *normalImages;
static NSArray *shootImages;
static NSDictionary *jadeTowerInfo;

@implementation ETDJadeTower

//animations related
#define towerImageType @".PNG"
#define towerNormalPrefix @"jade_normal_"
#define towerNormalImageNum 1
#define normalAnimationDuration 0.1
#define towerShootPrefix @"jade_shoot_"
#define towerShootImageNum 1
#define towerCeasePrefix @"jade_cease_"
#define towerCeaseImageNum 1
#define shootAnimationDuration 0.1
//file related
#define jadeTowerInfoPlistName (@"ETDJadeTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl
{
	if (self = [super initWithDelegate:del withLevel:lvl]) 
    {
        towerType = kJadeTower;
        elementType = noElement;
        NSDictionary *generalDic = [ETDJadeTower getInfoForJadeTower];
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
    NSDictionary *generalDic = [ETDJadeTower getInfoForJadeTower];
    [self loadDataFromDictionary:generalDic];
}

+(NSDictionary*)getInfoForJadeTower
{
    if(jadeTowerInfo == nil){
        jadeTowerInfo = [ETDTower getDataForTowerFromFile:jadeTowerInfoPlistName];
    }
    return jadeTowerInfo;
}

+(NSArray*)getJadeNormalAnimationImageArray
{
    if(normalImages == nil){
        normalImages = [ETDTower getNormalAnimationImageArray:towerNormalPrefix 
                                                             :towerImageType :towerNormalImageNum];
    }
    return normalImages;
}

+(NSArray*)getJadeShootAnimationImageArray
{
    if(shootImages == nil){
        shootImages = [ETDTower getShootAnimationImageArray:towerShootPrefix :towerCeasePrefix 
                                                           :towerImageType :towerShootImageNum :towerCeaseImageNum];
    }
    return shootImages;
}

-(void)loadNormalAnimation
{
    [self loadNormalAnimationWithImageArray:[ETDJadeTower getJadeNormalAnimationImageArray] 
                                   Duration:normalAnimationDuration];
}

-(void)loadShootAnimation
{
    [self loadShootAnimationWithImageArray:[ETDJadeTower getJadeShootAnimationImageArray]  
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
