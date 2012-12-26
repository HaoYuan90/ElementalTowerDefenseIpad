//implemented to control projectile life cycle mainly
#import <Foundation/Foundation.h>

@protocol ETDProjectileDelegate <NSObject>

-(CGFloat)getDataWRTMap:(CGFloat)data; 
//get the actual game distance based on map

// destroy projectile
-(void)destructProjectile:(id)proj;

// Display crit tag - Metad projectile special effect
-(void)didScoreCritAt:(CGPoint)position dmg:(double)damage;

// Add coins - Jade projectile special effect
- (void)addCoins:(int)numOfCoins atPosition:(CGPoint)pos;

// deal damage to an area - Fire projectile special effect
- (void)dealFireDamage:(double)damage toAreaDefinedByCenter:(CGPoint)center andRadius:(double)radius;

@end
