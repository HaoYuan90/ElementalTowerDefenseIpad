#import "ETDProjectile.h"

@interface ETDWaterProjectile : ETDProjectile

@property (nonatomic, readonly) int slowDuration;
@property (nonatomic, readonly) float slowFactor;

+(NSDictionary*)getInfoForWaterProjectile;

@end
