#import <UIKit/UIKit.h>

@interface CoinTag : UIView

@property (nonatomic, readonly) int amount;

-(id)initWithAmt:(int)amt andPosition:(CGPoint)center;

@end
