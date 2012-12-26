#import "ETDWoodProjectile.h"

static NSDictionary *woodProjectileInfo;

@implementation ETDWoodProjectile

#define ProjectileImageName (@"wood_projectile.PNG")
#define woodProjectileInfoPlistName (@"ETDWoodTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}


- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{

    if (self = [super initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del]) {
        projectileType = kWood;
        NSDictionary *generalDic = [ETDWoodProjectile getInfoForWoodProjectile];
        [self loadDataFromDictionary:generalDic];
        //speed dmg offset
    }
    return self;
}

/*
- (void) performSpecialEffect {
	// Attack multiple creeps
	[target hitByProjectileOfType:projectileType andDamage:damage];
}*/

+ (NSDictionary*) getInfoForWoodProjectile
{
    if(woodProjectileInfo == nil){
        woodProjectileInfo = [ETDProjectile getDataForProjectileFromFile:woodProjectileInfoPlistName];
    }
    return woodProjectileInfo;
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    UIImage *projImage = [UIImage imageNamed:ProjectileImageName];
    UIImageView *proj = [[UIImageView alloc] initWithImage:projImage];
    self.view = proj;
}

@end
