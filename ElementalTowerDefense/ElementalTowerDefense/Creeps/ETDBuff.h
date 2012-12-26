#import <Foundation/Foundation.h>

@interface ETDBuff : NSObject {
    BuffType type;
    int duration;
    float radius;
    CGFloat factor; // a float between 0 to 1, percent of increasing or decreasing
}
@property (nonatomic, readonly) BuffType type;
@property (nonatomic, readonly) int duration;
@property (nonatomic, readonly) float radius;
@property (nonatomic, readonly) CGFloat factor;

- (id)initWithType:(BuffType)buffType duration:(int)time radius:(float)r factor:(CGFloat)f;
// EFFECTS: constructs a ETDBuff.

- (void)update;
// EFFECTS: update the duration.

@end
