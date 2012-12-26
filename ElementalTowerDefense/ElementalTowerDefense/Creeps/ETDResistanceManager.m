#import "ETDResistanceManager.h"

@implementation ETDResistanceManager

@synthesize resistance;

- (id)initWithDictionary:(NSDictionary *)res {
    // EFFECTS: constructs ETDResistanceManager with the dictionary.
    
    self = [super init];
    if (self == nil){
        NSLog(@"malloc error");
        return nil;
    }
    resistance = [[NSDictionary alloc] initWithDictionary:res];
    return self;
}

- (float)resistanceFor:(ElementalType)type {
    // EFFECTS: returns the resistance for the elemental type.
    
    double temp;
    switch (type) {
        case kFire:
            temp = [[resistance valueForKey:creepFireResistTag] doubleValue];
            break;
        case kWater:
            temp = [[resistance valueForKey:creepWaterResistTag] doubleValue];
            break;
        case kEarth:
            temp = [[resistance valueForKey:creepEarthResistTag] doubleValue];
            break;
        case kMetal:
            temp = [[resistance valueForKey:creepMetalResistTag] doubleValue];
            break;
        case kWood:
            temp = [[resistance valueForKey:creepWoodResistTag] doubleValue];
            break;
        default:
            break;
    }
    return temp;
}

@end
