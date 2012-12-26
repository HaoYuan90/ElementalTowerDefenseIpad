#import <UIKit/UIKit.h>
#import "ETDProjectileDelegate.h"
#import "ETDCreep.h"

@interface ETDProjectile : UIViewController {
    CGPoint position;
    ETDCreep* target;
    CGFloat speed;
    CGFloat positionalOffset;
    int level;
    double damage;
    ElementalType projectileType;
    __weak id<ETDProjectileDelegate> delegate;
	BOOL hasSpecialEffect;
	int maxLevel;
}

//position related
@property (nonatomic, readonly) CGPoint position;
@property (nonatomic, strong) ETDCreep* target;
@property (nonatomic, readonly) CGFloat speed;
@property (nonatomic, readonly) CGFloat positionalOffset;

@property (nonatomic, readonly) int level;
@property (nonatomic, readonly) ElementalType projectileType;
@property (nonatomic, assign) double damage;
@property (nonatomic, assign) BOOL hasSpecialEffect;
@property (nonatomic, weak) id<ETDProjectileDelegate> delegate;
@property (nonatomic, assign) int maxLevel;

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar 
       projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del;


- (void)updateStatus;


- (void)performSpecialEffect;

- (NSDictionary*)loadGeneralDataFromDictionary:(NSDictionary*)generalDic;
//load general information of the projectile
//return the dictionary containing level information for childclass to further read from

//load data
+ (NSDictionary*)getDataForProjectileFromFile:(NSString*)fileName;

@end
