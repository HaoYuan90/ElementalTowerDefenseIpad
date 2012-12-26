#import "ETDProjectile.h"

@interface ETDMetalProjectile : ETDProjectile

@property (nonatomic, readonly) CGFloat critChance;
@property (nonatomic, readonly) float multiplier;

+(NSDictionary*)getInfoForMetalProjectile;

@end
