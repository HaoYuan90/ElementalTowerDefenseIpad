//wood + fire = wind
//special ability: increase attack speed of nearby towers
//attack type is wood

#import <UIKit/UIKit.h>
#import "ETDTower.h"

@interface ETDWindTower : ETDTower

+(NSArray*)getWindNormalAnimationImageArray;
+(NSArray*)getWindShootAnimationImageArray;
+(NSDictionary*)getInfoForWindTower;

- (BOOL)isPositionInsideWindAura:(CGPoint)pos;

@end
