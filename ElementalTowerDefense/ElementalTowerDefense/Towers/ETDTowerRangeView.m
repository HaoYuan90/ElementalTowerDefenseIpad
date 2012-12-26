#import "ETDTowerRangeView.h"

@implementation ETDTowerRangeView

#define rangeViewAlpha 0.2

@synthesize center;
@synthesize radius;
@synthesize color;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithCenter:(CGPoint)cen andRadius:(CGFloat)rad
{
	color = [UIColor blackColor];
    self = [self initWithFrame:CGRectMake(cen.x-rad, cen.y-rad, 2*rad, 2*rad)];
    self.opaque = NO;
    self.alpha = rangeViewAlpha;
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextFillEllipseInRect(context, self.bounds);
}

- (id)initWithCenter:(CGPoint)cen andRadius:(CGFloat)rad andColor:(UIColor *)c {
	color = c;
	self = [self initWithFrame:CGRectMake(cen.x-rad, cen.y-rad, 2*rad, 2*rad)];
    self.opaque = NO;
    self.alpha = rangeViewAlpha;
    return self;
}

@end
