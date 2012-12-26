#import "ETDFireProjectile.h"

static NSDictionary *fireProjectileInfo;

@implementation ETDFireProjectile

#define ProjectileImageName (@"fire_projectile.png")
#define fireProjectileInfoPlistName (@"ETDFireTowerInfo")
#define levelToUnlockPower 2

@synthesize aoe;

- (void)loadDataFromDictionary:(NSDictionary*)generalDic
{
    NSDictionary* info = [self loadGeneralDataFromDictionary:generalDic];
    aoe = [[info valueForKey:projectileAOETag] floatValue];
    aoe = [delegate getDataWRTMap:aoe];
}

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{
    if (self = [super initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del]) {
        projectileType = kFire;
        NSDictionary *generalDic = [ETDFireProjectile getInfoForFireProjectile];
        [self loadDataFromDictionary:generalDic];
		
		// Unlock special ability as projectile level has been maxed
		if (level >= levelToUnlockPower) {
			hasSpecialEffect = YES;
		}
    }
    return self;
}

- (void)performSpecialEffect {
	// Hit target creep and deal damage in an AOE
	[target hitByProjectileOfType:projectileType andDamage:damage];
	[delegate dealFireDamage:damage/4 toAreaDefinedByCenter:target.position andRadius:aoe];
}

+ (NSDictionary*) getInfoForFireProjectile
{
    if(fireProjectileInfo == nil){
        fireProjectileInfo = [ETDProjectile getDataForProjectileFromFile:fireProjectileInfoPlistName];
    }
    return fireProjectileInfo;
}

#pragma mark - View lifecycle

- (void)loadView 
{	
    UIImage *projImage = [UIImage imageNamed:ProjectileImageName];
    UIImageView *proj = [[UIImageView alloc] initWithImage:projImage];
    self.view = proj;
}

@end
