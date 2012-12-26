#import "ETDEarthProjectile.h"

static NSDictionary *earthProjectileInfo;

@implementation ETDEarthProjectile

#define ProjectileImageName (@"earth_projectile.PNG")
#define earthProjectileInfoPlistName (@"ETDEarthTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{
    if (self = [super initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del]) {
        projectileType = kEarth;
        NSDictionary *generalDic = [ETDEarthProjectile getInfoForEarthProjectile];
        [self loadDataFromDictionary:generalDic];
    }
    return self;
}

+ (NSDictionary*) getInfoForEarthProjectile
{
    if(earthProjectileInfo == nil){
        earthProjectileInfo = [ETDProjectile getDataForProjectileFromFile:earthProjectileInfoPlistName];
    }
    return earthProjectileInfo;
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    UIImage *projImage = [UIImage imageNamed:ProjectileImageName];
    UIImageView *proj = [[UIImageView alloc] initWithImage:projImage];
    self.view = proj;
}

@end
