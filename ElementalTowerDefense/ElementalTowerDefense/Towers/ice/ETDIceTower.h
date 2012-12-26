//water + metal = ice
//special ability: freeze enemy in an area
//attack type is water

#import <UIKit/UIKit.h>
#import "ETDTower.h"

@interface ETDIceTower : ETDTower

@property (nonatomic, readonly) CGFloat areaOfEffect;
@property (nonatomic, readonly) double effectDuration;

+(NSArray*)getIceNormalAnimationImageArray;
+(NSArray*)getIceShootAnimationImageArray;
+(NSDictionary*)getInfoForIceTower;

- (void)displayAreaOfEffect;

@end
