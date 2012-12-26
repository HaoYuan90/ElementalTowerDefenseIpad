#import "ETDMagmaTower.h"

static NSArray *normalImages;
static NSArray *shootImages;
static NSDictionary *magmaTowerInfo;

@implementation ETDMagmaTower

//animations related
#define towerImageType @".PNG"
#define towerNormalPrefix @"magma_normal_"
#define towerNormalImageNum 1
#define normalAnimationDuration 0.1
#define towerShootPrefix @"magma_shoot_"
#define towerShootImageNum 1
#define towerCeasePrefix @"magma_cease_"
#define towerCeaseImageNum 1
#define shootAnimationDuration 0.1
//file related
#define magmaTowerInfoPlistName (@"ETDMagmaTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl
{
	if (self = [super initWithDelegate:del withLevel:lvl]) 
    {
        towerType = kMagmaTower;
        elementType = noElement;
        NSDictionary *generalDic = [ETDMagmaTower getInfoForMagmaTower];
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
    NSDictionary *generalDic = [ETDMagmaTower getInfoForMagmaTower];
    [self loadDataFromDictionary:generalDic];
}

+(NSDictionary*)getInfoForMagmaTower
{
    if(magmaTowerInfo == nil){
        magmaTowerInfo = [ETDTower getDataForTowerFromFile:magmaTowerInfoPlistName];
    }
    return magmaTowerInfo;
}

+(NSArray*)getMagmaNormalAnimationImageArray
{
    if(normalImages == nil){
        normalImages = [ETDTower getNormalAnimationImageArray:towerNormalPrefix 
                                                             :towerImageType :towerNormalImageNum];
    }
    return normalImages;
}

+(NSArray*)getMagmaShootAnimationImageArray
{
    if(shootImages == nil){
        shootImages = [ETDTower getShootAnimationImageArray:towerShootPrefix :towerCeasePrefix 
                                                           :towerImageType :towerShootImageNum :towerCeaseImageNum];
    }
    return shootImages;
}

-(void)loadNormalAnimation
{
    [self loadNormalAnimationWithImageArray:[ETDMagmaTower getMagmaNormalAnimationImageArray] 
                                   Duration:normalAnimationDuration];
}

-(void)loadShootAnimation
{
    [self loadShootAnimationWithImageArray:[ETDMagmaTower getMagmaShootAnimationImageArray]  
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
