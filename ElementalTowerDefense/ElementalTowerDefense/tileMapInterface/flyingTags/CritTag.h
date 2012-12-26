#import <UIKit/UIKit.h>

@interface CritTag : UIView

@property (nonatomic, readonly) double damage;

-(id)initWithDmg:(double)dmg andPosition:(CGPoint)center;

@end
