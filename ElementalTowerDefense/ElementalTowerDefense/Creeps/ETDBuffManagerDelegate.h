#import <Foundation/Foundation.h>

/*
 * ETDCreep should adopt this protocol
 */

@protocol ETDBuffManagerDelegate <NSObject>

- (void)increaseHPByFactor:(CGFloat)factor;
// EFFECTS: update the HP = currentHP * (1 + factor)

@end
