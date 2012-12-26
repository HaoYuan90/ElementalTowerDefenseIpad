#import <Foundation/Foundation.h>

@protocol ETDGameEngineDelegate <NSObject>

- (void)didFinishCurrentWave;
- (int)tileNumberOfPoint:(CGPoint)point;
@end
