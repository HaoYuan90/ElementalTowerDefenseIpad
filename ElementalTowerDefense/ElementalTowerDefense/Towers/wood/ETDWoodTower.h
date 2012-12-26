#import "ETDTower.h"

@interface ETDWoodTower : ETDTower

@property (nonatomic, readonly, strong) NSMutableArray *targets;
@property (nonatomic, readonly) int targetLimit;

+(NSArray*)getWoodNormalAnimationImageArray;
+(NSArray*)getWoodShootAnimationImageArray;
+(NSDictionary*)getInfoForWoodTower;

- (void)addTarget:(ETDCreep *)creep;

@end
