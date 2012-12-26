#import "ETDIceProjectile.h"

static NSDictionary *iceProjectileInfo;

@implementation ETDIceProjectile

#define ProjectileImageName (@"ice_projectile.PNG")
#define iceProjectileInfoPlistName (@"ETDIceTowerInfo")

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{
    if (self = [super initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del]) {
        projectileType = kWater;
        NSDictionary *generalDic = [ETDIceProjectile getInfoForIceProjectile];
        [self loadDataFromDictionary:generalDic];
    }
    return self;
}

+ (NSDictionary*) getInfoForIceProjectile
{
    if(iceProjectileInfo == nil){
        iceProjectileInfo = [ETDProjectile getDataForProjectileFromFile:iceProjectileInfoPlistName];
    }
    return iceProjectileInfo;
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    UIImage *projImage = [UIImage imageNamed:ProjectileImageName];
    UIImageView *proj = [[UIImageView alloc] initWithImage:projImage];
    self.view = proj;
}

@end
