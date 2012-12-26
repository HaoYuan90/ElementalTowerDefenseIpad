#import <UIKit/UIKit.h>

@interface ETDTowerRangeView : UIView

@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) CGFloat radius;
@property (nonatomic, strong, readonly) UIColor *color;

- (id)initWithCenter:(CGPoint)center andRadius:(CGFloat)rad;
- (id)initWithCenter:(CGPoint)center andRadius:(CGFloat)rad andColor:(UIColor *)c;

@end
