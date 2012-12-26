#import "ETDProjectile.h"

@interface ETDFireProjectile : ETDProjectile

@property (nonatomic, readonly) CGFloat aoe;

+(NSDictionary*)getInfoForFireProjectile;

@end
