#import <UIKit/UIKit.h>
#import "ETDTowerDelegate.h"
#import "ETDTowerRangeView.h"
#import "ETDProjectileDelegate.h"
#import "ETDCreep.h"
#import "ETDProjectile.h"
#import "ETDProjectileFactory.h"

@interface ETDTower : UIViewController{
    TowerType towerType;
    ElementalType elementType;
    CGPoint position;
    int level;
    int maxLevel;
    int cooldown;
    int cdState;
    CGFloat attackRadius;
    ETDCreep *targetCreep;
    
    int specialAbilityCD;
    int specialAbilityCDState;
    
    __weak id<ETDTowerDelegate,ETDProjectileDelegate> delegate;
    
    double damage;
    NSString *desc;
	
	int upgradeCost;
	int towerValue;
	int buildCost;
	int sellingValue;
}

@property (nonatomic, readonly) TowerType towerType;
@property (nonatomic, readonly) ElementalType elementType;
@property (nonatomic) CGPoint position;
@property (nonatomic, readonly) int level;
@property (nonatomic) int maxLevel;
//attack related
@property (nonatomic, readonly) int cooldown;
@property (nonatomic, readonly) int cdState;
@property (nonatomic, readonly) CGFloat attackRadius;
@property (nonatomic, strong) ETDCreep *targetCreep;
@property (nonatomic, weak) id<ETDTowerDelegate,ETDProjectileDelegate> delegate;
//special ability 
@property (nonatomic, readonly) int specialAbilityCD;
@property (nonatomic) int specialAbilityCDState;
//displayed properties
@property (nonatomic, readonly) double damage;
@property (nonatomic, readonly, strong) NSString* desc;

// sell/upgrade
@property (nonatomic, assign) double currentCooldownRate;
@property (nonatomic, assign) int upgradeCost;
@property (nonatomic, assign) int towerValue;
@property (nonatomic, assign) int buildCost;
@property (nonatomic, assign) int sellingValue;

//init related
- (NSDictionary*)loadGeneralDataFromDictionary:(NSDictionary*)generalDic;
//load general information of the tower
//return the dictionary containing level information for childclass to further read from

- (id)initWithDelegate:(id<ETDTowerDelegate,ETDProjectileDelegate>)del withLevel:(int)lvl;

- (void)upgrade;

//attack related
- (void)loadShootAnimation;
//- (BOOL)shouldSwitchTarget; 
- (BOOL)canAttackCreep:(ETDCreep*)creep;
- (void)attackCreep:(ETDCreep *)target;

//update states
- (void)updateStatus;
- (void)sold;

//touch related
- (void)enableTouchGesture;

//load animations
-(void)loadNormalAnimationWithImageArray:(NSArray*)images Duration:(NSTimeInterval)dura;
-(void)loadShootAnimationWithImageArray:(NSArray*)images Duration:(NSTimeInterval)dura;

+ (NSArray*)getNormalAnimationImageArray:(NSString*)prefix:(NSString*)type:(int)imageNum;
//imageNum must be valid for this method
+ (NSArray*)getShootAnimationImageArray:(NSString*)shootPrefix:(NSString*)ceasePrefix
                                       :(NSString*)type:(int)shootImageNum:(int)ceaseImageNum;

//load data
+ (NSDictionary*)getDataForTowerFromFile:(NSString*)fileName;

// Aura
- (void)addWindAuraEffect;
- (void)removeWindAuraEffect;

// Special Ability
- (void)invokeSpecialAbility;

// gesture recognizer
- (void)towerSelected:(UITapGestureRecognizer*) gesture;

@end
