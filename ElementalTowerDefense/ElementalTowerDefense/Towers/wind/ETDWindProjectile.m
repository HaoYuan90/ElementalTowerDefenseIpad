#import "ETDWindProjectile.h"

static NSDictionary *windProjectileInfo;

@implementation ETDWindProjectile

#define ProjectileImageName (@"wind_projectile.PNG")
#define windProjectileInfoPlistName (@"ETDWindTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{
    if (self = [super initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del]) {
        projectileType = kWood;
        NSDictionary *generalDic = [ETDWindProjectile getInfoForWindProjectile];
        [self loadDataFromDictionary:generalDic];
    }
    return self;
}

+ (NSDictionary*) getInfoForWindProjectile
{
    if(windProjectileInfo == nil){
        windProjectileInfo = [ETDProjectile getDataForProjectileFromFile:windProjectileInfoPlistName];
    }
    return windProjectileInfo;
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    UIImage *projImage = [UIImage imageNamed:ProjectileImageName];
    UIImageView *proj = [[UIImageView alloc] initWithImage:projImage];
    self.view = proj;
}

@end
