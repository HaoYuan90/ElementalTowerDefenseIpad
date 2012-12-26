#import "ETDJadeProjectile.h"

static NSDictionary *jadeProjectileInfo;

@implementation ETDJadeProjectile

#define ProjectileImageName (@"jade_projectile.PNG")
#define jadeProjectileInfoPlistName (@"ETDJadeTowerInfo")

@synthesize multiplier;
@synthesize rewardChance;

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    NSDictionary* info = [self loadGeneralDataFromDictionary:generalDic];
    multiplier = [[info valueForKey:@"multiplier"]doubleValue];
    rewardChance = [[info valueForKey:@"rewardChance"]doubleValue];
}

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{
    if (self = [super initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del]) {
        projectileType = kEarth;
        NSDictionary *generalDic = [ETDJadeProjectile getInfoForJadeProjectile];
        [self loadDataFromDictionary:generalDic];
		
		int r = rand();
        if (r % 100 < 100 * rewardChance){
            double additionalCoins = target.bounty * multiplier;
			[delegate addCoins:(int)additionalCoins atPosition:position];
        }
    }
    return self;
}

+ (NSDictionary*) getInfoForJadeProjectile
{
    if(jadeProjectileInfo == nil){
        jadeProjectileInfo = [ETDProjectile getDataForProjectileFromFile:jadeProjectileInfoPlistName];
    }
    return jadeProjectileInfo;
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    UIImage *projImage = [UIImage imageNamed:ProjectileImageName];
    UIImageView *proj = [[UIImageView alloc] initWithImage:projImage];
    self.view = proj;
}

@end

