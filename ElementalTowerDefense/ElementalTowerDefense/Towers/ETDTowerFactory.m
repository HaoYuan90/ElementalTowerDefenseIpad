#import "ETDTowerFactory.h"

@implementation ETDTowerFactory

+ (ETDTower*) createNewTowerOfType:(TowerType)type withDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)delegate
{
    ETDTower *temp;
    switch (type) {
        case kMetalTower:
            temp = [[ETDMetalTower alloc] initWithDelegate:delegate withLevel:1];
            break;
        case kFireTower:
            temp = [[ETDFireTower alloc] initWithDelegate:delegate withLevel:1];
            break;
        case kEarthTower:
            temp = [[ETDEarthTower alloc] initWithDelegate:delegate withLevel:1];
            break;
        case kWoodTower:
            temp = [[ETDWoodTower alloc] initWithDelegate:delegate withLevel:1];
            break;
        case kWaterTower:
            temp = [[ETDWaterTower alloc] initWithDelegate:delegate withLevel:1];
            break;
        case kIceTower:
            temp = [[ETDIceTower alloc] initWithDelegate:delegate withLevel:1];
            break;
        case kMagmaTower:
            temp = [[ETDMagmaTower alloc] initWithDelegate:delegate withLevel:1];
            break;
        case kWindTower:
            temp = [[ETDWindTower alloc] initWithDelegate:delegate withLevel:1];
            break;
        case kJadeTower:
            temp = [[ETDJadeTower alloc] initWithDelegate:delegate withLevel:1];
            break;
            //9 towers of first version :D
        default:
            break;
    }
    return temp;
}

+ (ETDTower*) createNewTowerOfType:(TowerType)type withDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)delegate withLevel:(int)lvl
{
    ETDTower *temp;
    switch (type) {
        case kMetalTower:
            temp = [[ETDMetalTower alloc] initWithDelegate:delegate withLevel:lvl];
            break;
        case kFireTower:
            temp = [[ETDFireTower alloc] initWithDelegate:delegate withLevel:lvl];
            break;
        case kEarthTower:
            temp = [[ETDEarthTower alloc] initWithDelegate:delegate withLevel:lvl];
            break;
        case kWoodTower:
            temp = [[ETDWoodTower alloc] initWithDelegate:delegate withLevel:lvl];
            break;
        case kWaterTower:
            temp = [[ETDWaterTower alloc] initWithDelegate:delegate withLevel:lvl];
            break;
        case kIceTower:
            temp = [[ETDIceTower alloc] initWithDelegate:delegate withLevel:lvl];
            break;
        case kMagmaTower:
            temp = [[ETDMagmaTower alloc] initWithDelegate:delegate withLevel:lvl];
            break;
        case kWindTower:
            temp = [[ETDWindTower alloc] initWithDelegate:delegate withLevel:lvl];
            break;
        case kJadeTower:
            temp = [[ETDJadeTower alloc] initWithDelegate:delegate withLevel:lvl];
            break;
            //9 towers of first version :D
        default:
            break;
    }
    return temp;
}

@end
