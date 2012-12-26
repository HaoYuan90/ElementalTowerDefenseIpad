#import "ETDProjectileFactory.h"

@implementation ETDProjectileFactory


// Create a new Projectile object using the information given:
// - TowerType: The type of the tower firing the projectile
// - initialPosition: The starting position for the projectile
// - Target: The targeted creep as the destination
// - projectileLevel: The level of the projectile which is the level of the tower firing this projectile.
// - delegate: This is to set delegate to handle needed operation
+ (ETDProjectile *)createProjectileOfType:(TowerType)type 
                          initialPosition:(CGPoint)point withTarget:(ETDCreep *)tar 
                          projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del 
{
    switch (type) {
        case kFireTower:
            return [[ETDFireProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
        case kWaterTower:
            return [[ETDWaterProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
        case kWoodTower:
            return [[ETDWoodProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
        case kMetalTower:
            return [[ETDMetalProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
        case kEarthTower:
            return [[ETDEarthProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
            
        case kIceTower:
            return [[ETDIceProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
        case kWindTower:
            return [[ETDWindProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
        case kMagmaTower:
            return [[ETDMagmaProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
        case kJadeTower:
            return [[ETDJadeProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
        
        default:
            return [[ETDProjectile alloc] initWithPosition:point withTarget:tar projectileLevel:lvl Delegate:del];
    }
}

@end
