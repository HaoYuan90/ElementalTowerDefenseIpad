#import "ETDComboChecker.h"

static NSDictionary* comboList;

@implementation ETDComboChecker

#define comboListStoreName (@"TowerComboList")
#define comboDicTag (@"combos")
#define comboEnabledTag (@"enabled")
#define comboTypeTag (@"type")

+(NSDictionary*)getComboList
{
    if(comboList == nil){
        NSString *bundle = [[NSBundle mainBundle] pathForResource:comboListStoreName ofType:@"plist"]; 
        NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:bundle];
        NSString *errorDesc = nil;
        NSPropertyListFormat format;
        NSDictionary* temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
        if (!temp)
            NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        comboList = [temp valueForKey:comboDicTag];
    }
    return comboList;
}

+(int)getKeyFor:(ElementalType)sel
{
    switch (sel) {
        case kMetal:
            return 16;
        case kWood:
            return 8;
        case kWater:
            return 4;
        case kFire:
            return 2;
        case kEarth:
            return 1;
        default:
            return 0;
    }
}

+(TowerType)getComboOf:(ElementalType)sel1 :(ElementalType)sel2 :(ElementalType)sel3
{
    NSDictionary *comboDic = [ETDComboChecker getComboList];
    int key = 0;
    key += [ETDComboChecker getKeyFor:sel1];
    key += [ETDComboChecker getKeyFor:sel2];
    key += [ETDComboChecker getKeyFor:sel3];
    NSString *keyString = [NSString stringWithFormat:@"%d",key];
    NSDictionary *tower = [comboDic valueForKey:keyString];
    if (tower == nil || ![[tower valueForKey:comboEnabledTag] boolValue])
        return noTower;
    else 
        return [[tower valueForKey:comboTypeTag] intValue];
}

@end
