#import "ETDIceTower.h"

static NSArray *normalImages;
static NSArray *shootImages;
static NSDictionary *iceTowerInfo;

@implementation ETDIceTower

//animations related
#define towerImageType @".PNG"
#define towerNormalPrefix @"ice_normal_"
#define towerNormalImageNum 1
#define normalAnimationDuration 0.1
#define towerShootPrefix @"ice_shoot_"
#define towerShootImageNum 1
#define towerCeasePrefix @"ice_cease_"
#define towerCeaseImageNum 1
#define shootAnimationDuration 0.1
//file related
#define iceTowerInfoPlistName (@"ETDIceTowerInfo")
// animation
#define rangeViewAnimationFadeTime 1.5

@synthesize areaOfEffect;
@synthesize effectDuration;

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    NSDictionary *levelInfo = [self loadGeneralDataFromDictionary:generalDic];
	// Special ability for all levels
	specialAbilityCD = [[levelInfo valueForKey:specialAbilityCooldownTag] doubleValue];
	areaOfEffect = [[levelInfo valueForKey:towerAOETag] floatValue];
	areaOfEffect = [delegate getDataWRTMap:areaOfEffect];
	effectDuration = [[levelInfo valueForKey:effectDurationTag] doubleValue];
	specialAbilityCDState = specialAbilityCD;
	DLog(@"%g", effectDuration);
}

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl
{
	if (self = [super initWithDelegate:del withLevel:lvl]) 
    {
        towerType = kIceTower;
        elementType = noElement;
        NSDictionary *generalDic = [ETDIceTower getInfoForIceTower];
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
    NSDictionary *generalDic = [ETDIceTower getInfoForIceTower];
    [self loadDataFromDictionary:generalDic];
}

+(NSDictionary*)getInfoForIceTower
{
    if(iceTowerInfo == nil){
        iceTowerInfo = [ETDTower getDataForTowerFromFile:iceTowerInfoPlistName];
    }
    return iceTowerInfo;
}

+(NSArray*)getIceNormalAnimationImageArray
{
    if(normalImages == nil){
        normalImages = [ETDTower getNormalAnimationImageArray:towerNormalPrefix 
                                                             :towerImageType :towerNormalImageNum];
    }
    return normalImages;
}

+(NSArray*)getIceShootAnimationImageArray
{
    if(shootImages == nil){
        shootImages = [ETDTower getShootAnimationImageArray:towerShootPrefix :towerCeasePrefix 
                                                           :towerImageType :towerShootImageNum :towerCeaseImageNum];
    }
    return shootImages;
}

-(void)loadNormalAnimation
{
    [self loadNormalAnimationWithImageArray:[ETDIceTower getIceNormalAnimationImageArray] 
                                   Duration:normalAnimationDuration];
}

-(void)loadShootAnimation
{
    [self loadShootAnimationWithImageArray:[ETDIceTower getIceShootAnimationImageArray]  
                                  Duration:shootAnimationDuration];
}

- (void)invokeSpecialAbility {
	[self displayAreaOfEffect];
	[delegate freezeCreepsInsideAreaDefinedByCenter:self.position andRadius:areaOfEffect andDuration:effectDuration];
}

- (void)displayAreaOfEffect {
	ETDTowerRangeView *range = [[ETDTowerRangeView alloc] initWithCenter:position andRadius:attackRadius andColor:[UIColor blueColor]];
    [self.view.superview insertSubview:range atIndex:0];
    [UIView animateWithDuration:rangeViewAnimationFadeTime animations:^(void){
        range.alpha = 0;
    } completion:^(BOOL finished){
        [range removeFromSuperview];
    }];
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
