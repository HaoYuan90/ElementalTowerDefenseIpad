#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ArrowTag : UIView

@property (nonatomic, readonly) arrowTagType arrowType;
@property (nonatomic, readonly) arrowTagState state;

-(id)initWithType:(arrowTagType)tp andState:(arrowTagState)st at:(CGPoint)center;

@end
