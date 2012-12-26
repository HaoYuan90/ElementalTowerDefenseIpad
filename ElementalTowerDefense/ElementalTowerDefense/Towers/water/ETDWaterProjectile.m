#import "ETDWaterProjectile.h"
#import "ETDBuff.h"

static NSDictionary *waterProjectileInfo;

@implementation ETDWaterProjectile

#define ProjectileImageName (@"water_projectile.PNG")
#define waterProjectileInfoPlistName (@"ETDWaterTowerInfo")
#define levelToUnlockPower 2

@synthesize slowDuration;
@synthesize slowFactor;

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    NSDictionary *temp = [self loadGeneralDataFromDictionary:generalDic];
    slowFactor = [[temp valueForKey:projectileDeBuffFactor] doubleValue];
    slowDuration = [[temp valueForKey:projectileDebuffDuration] intValue];
}

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{
    if (self = [super initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del]) {
        projectileType = kWater;
        NSDictionary *generalDic = [ETDWaterProjectile getInfoForWaterProjectile];
        [self loadDataFromDictionary:generalDic];
		
		// Unlock special ability as projectile level has been maxed
		if (level >= levelToUnlockPower) {
			hasSpecialEffect = YES;
		}
    }
    return self;
}

- (void)performSpecialEffect {
	ETDBuff *slowBuff = [[ETDBuff alloc] initWithType:kSlowing duration:slowDuration radius:0 factor:slowFactor];
	[target addBuff:slowBuff];
    [target hitByProjectileOfType:projectileType andDamage:damage];
}

+ (NSDictionary*) getInfoForWaterProjectile
{
    if(waterProjectileInfo == nil){
        waterProjectileInfo = [ETDProjectile getDataForProjectileFromFile:waterProjectileInfoPlistName];
    }
    return waterProjectileInfo;
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    UIImage *projImage = [UIImage imageNamed:ProjectileImageName];
    UIImageView *proj = [[UIImageView alloc] initWithImage:projImage];
    self.view = proj;
}

@end
