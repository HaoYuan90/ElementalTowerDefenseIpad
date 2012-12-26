#import <UIKit/UIKit.h>
#import "ETDCreepDelegate.h"
#import "ETDBuffManager.h"
#import "ETDBuffManagerDelegate.h"

@interface ETDCreep : UIViewController<ETDBuffManagerDelegate>{
    CGPoint position;
    CGPoint targetPoint;
    int currentPositionIndicator;
    
    int bounty;
    double maxHP;
    double currentHP;
    CGFloat initVelocity;
    ETDResistanceManager *initResistance;
    
    BOOL toRemove; // in the removing processing or not
    BOOL isTargetCreep;
    int currentSate; // 0 is normal, 1 is the currentHP < max HP, 2 is dead
    
    ETDBuff *createdBuff; // buff create when the creep die, (null if creep doesn't create buff when it dies)
    
    __weak id<ETDCreepDelegate> delegate;
    
    ETDBuffManager *buffManager;
    
    NSString *normalImageName;
    NSString *hurtImageName;
    NSString *deadImageName;
    UIView *healthBar;
    UIImageView *targetArrow;
}

//creep status
@property (nonatomic, assign) BOOL isTargetCreep;
@property (nonatomic, readonly) int bounty;
@property (nonatomic, readonly) double maxHP;
@property (nonatomic, readonly) double currentHP;
@property (nonatomic, readonly) CGFloat initVelocity;
@property (nonatomic, readonly, strong) ETDResistanceManager *initResistance;

//creep position/path
@property (nonatomic, readonly) BOOL toRemove;
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, readonly) CGPoint targetPoint;
@property (nonatomic, readonly) int currentPositionIndicator;

//buff
@property (nonatomic, readonly) ETDBuff *createdBuff;

//delegate
@property (nonatomic, weak) id<ETDCreepDelegate> delegate;

//images
@property (nonatomic, readonly, strong) NSString *normalImageName;
@property (nonatomic, readonly, strong) NSString *hurtImageName;
@property (nonatomic, readonly, strong) NSString *deadImageName;
@property (nonatomic, readonly) int currentSate;
@property (nonatomic, strong) UIImageView *targetArrow;

//heath bar
@property (nonatomic, strong, readonly) UIView *healthBar;

- (id)initFromDictionary:(NSDictionary *)dic WithDelegate:(id<ETDCreepDelegate>) del;
// EFFECTS: constructs a ETDCreep with dictionary and the delegate.

- (void)updateStatus;
// EFFECTS: updates the status of creep (position, buff)

- (void)hitByProjectileOfType:(ElementalType)type andDamage:(double)dmg;
// EFFECTS: deducts the HP based on the projectile info, update the heath bar

- (void)addToGame;
// EFFECTS: adds the creep to the tile map.

- (void)addBuff:(ETDBuff *)buff;

- (double)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2;
// EFFECTS: returns the distance between two points p1 and p2

// Target arrow
- (void)showTargetArrow;
- (void)hideTargetArrow;

// Mask - freezing or burning
- (void)addMaskToCreep:(CreepMaskType)maskType inDuration:(double)dur;
// EFFECTS: adds the animation images for freezng or burning

@end
