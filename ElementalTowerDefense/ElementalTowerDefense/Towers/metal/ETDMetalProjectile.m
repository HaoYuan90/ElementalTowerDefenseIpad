#import "ETDMetalProjectile.h"
//#include <stdlib.h>

static NSDictionary *metalProjectileInfo;

@implementation ETDMetalProjectile

#define ProjectileImageName (@"metal_projectile.PNG")
#define metalProjectileInfoPlistName (@"ETDMetalTowerInfo")
#define levelToUnlockPower 2

@synthesize critChance;
@synthesize multiplier;

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    NSDictionary *temp = [self loadGeneralDataFromDictionary:generalDic];
    critChance = [[temp valueForKey:projectileCritChanceTag] doubleValue];
    multiplier = [[temp valueForKey:projectileCritMultTag] doubleValue];
}

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{
    if (self = [super initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del]) {
        projectileType = kMetal;
        NSDictionary *generalDic = [ETDMetalProjectile getInfoForMetalProjectile];
        [self loadDataFromDictionary:generalDic];
        if(level >= levelToUnlockPower){
            int r = rand();
            if (r % 100 < 100 * critChance){
                damage = damage*multiplier;
                [delegate didScoreCritAt:point dmg:damage];
            }
        }
    }
    return self;
}

+ (NSDictionary*) getInfoForMetalProjectile
{
    if(metalProjectileInfo == nil){
        metalProjectileInfo = [ETDProjectile getDataForProjectileFromFile:metalProjectileInfoPlistName];
    }
    return metalProjectileInfo;
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    UIImage *projImage = [UIImage imageNamed:ProjectileImageName];
    UIImageView *proj = [[UIImageView alloc] initWithImage:projImage];
    self.view = proj;
}

@end
