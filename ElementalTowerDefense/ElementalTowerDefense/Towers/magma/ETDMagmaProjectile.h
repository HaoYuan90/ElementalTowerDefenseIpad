#import "ETDProjectile.h"

@interface ETDMagmaProjectile : ETDProjectile

+(NSDictionary*)getInfoForMagmaProjectile;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int timePast;

@end
