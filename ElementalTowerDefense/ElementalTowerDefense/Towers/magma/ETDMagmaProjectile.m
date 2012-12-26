#import "ETDMagmaProjectile.h"

static NSDictionary *magmaProjectileInfo;

@implementation ETDMagmaProjectile

#define ProjectileImageName (@"magma_projectile.PNG")
#define magmaProjectileInfoPlistName (@"ETDMagmaTowerInfo")
#define specialEffectDuration 5

@synthesize timer;
@synthesize timePast;

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    [self loadGeneralDataFromDictionary:generalDic];
}

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{
    if (self = [super initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del]) {
        projectileType = kFire;
        NSDictionary *generalDic = [ETDMagmaProjectile getInfoForMagmaProjectile];
        [self loadDataFromDictionary:generalDic];
		
		// This projectile has specialEffect by default
		hasSpecialEffect = YES;
    }
    return self;
}

- (void)performSpecialEffect {
	timePast = 1;
	[target addMaskToCreep:kBurning inDuration:0.8];
	[target hitByProjectileOfType:kFire andDamage:damage];
	timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dealDmgPerSec) userInfo:nil repeats:YES];
}

- (void)dealDmgPerSec {
	if (timePast == specialEffectDuration) {
		[timer invalidate];
		return;
	} else {
		timePast ++;
		[target hitByProjectileOfType:kFire andDamage:damage];
		[target addMaskToCreep:kBurning inDuration:0.8];
	}
}

+ (NSDictionary*) getInfoForMagmaProjectile
{
    if(magmaProjectileInfo == nil){
        magmaProjectileInfo = [ETDProjectile getDataForProjectileFromFile:magmaProjectileInfoPlistName];
    }
    return magmaProjectileInfo;
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    UIImage *projImage = [UIImage imageNamed:ProjectileImageName];
    UIImageView *proj = [[UIImageView alloc] initWithImage:projImage];
    self.view = proj;
}

@end

