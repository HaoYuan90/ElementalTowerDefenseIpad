#import "ETDTower.h"

@interface ETDEarthTower : ETDTower

+(NSArray*)getEarthNormalAnimationImageArray;
+(NSArray*)getEarthShootAnimationImageArray;
+(NSDictionary*)getInfoForEarthTower;

@property (nonatomic, strong) UIView *cooldownBar;

@end
