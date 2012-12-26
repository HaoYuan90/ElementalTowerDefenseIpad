#import <Foundation/Foundation.h>
#import "ETDProjectiles.h"

@interface ETDProjectileFactory : NSObject

+ (ETDProjectile *)createProjectileOfType:(TowerType)type 
                          initialPosition:(CGPoint)point withTarget:(ETDCreep *)tar 
                          projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del;

@end
