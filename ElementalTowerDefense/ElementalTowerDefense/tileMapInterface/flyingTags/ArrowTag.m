#import "ArrowTag.h"

@implementation ArrowTag

#define hpArrowName (@"hpArrow.png")
#define hpLabel (@"HP")
#define resistArrowName (@"resistArrow.png")
#define resistLabel (@"RES")
#define speedArrowName (@"speedArrow.png")
#define speedLabel (@"SPD")
#define arrowTagWidth 60
#define arrowTagHeight 30
#define disappearTime 1.5

@synthesize arrowType;
@synthesize state;

-(id)initWithType:(arrowTagType)tp andState:(arrowTagState)st at:(CGPoint)center
{
    self = [super initWithFrame:
            CGRectMake(center.x-arrowTagWidth/2.0, center.y-arrowTagHeight/2.0, arrowTagWidth, arrowTagHeight)];
    if(self == nil){
        NSLog(@"malloc error");
        return nil;
    }
    arrowType = tp;
    state = st;
    self.opaque = NO;
    [UIView animateWithDuration:disappearTime animations:^(void){
        self.alpha = 0;
        self.center = CGPointMake(center.x, center.y-20);
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, arrowTagWidth/2.0, arrowTagHeight)];
    UIImage *arrow;
    switch (arrowType) {
        case kHealthChange:
            arrow = [UIImage imageNamed:hpArrowName];
            [descLabel setText:hpLabel];
            descLabel.textColor = [UIColor greenColor];
            break;
        case kSpeedChange:
            arrow = [UIImage imageNamed:speedArrowName];
            [descLabel setText:speedLabel];
            descLabel.textColor = [UIColor redColor];
            break;
        case kResistanceChange:
            arrow = [UIImage imageNamed:resistArrowName];
            [descLabel setText:resistLabel];
            descLabel.textColor = [UIColor yellowColor];
            break;
        default:
            break;
    }
    descLabel.opaque = NO;
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.textAlignment = UITextAlignmentRight;
    descLabel.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:descLabel];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrow];
    arrowView.frame = CGRectMake(arrowTagWidth/2.0, 0, arrowTagWidth/2.0, arrowTagHeight);
    switch (state) {
        case kIncrease:
            arrowView.transform = CGAffineTransformMakeRotation(M_PI/2);
            break;
        case kDecrease:
            arrowView.transform = CGAffineTransformMakeRotation(M_PI/2);
            break;
        default:
            break;
    }
    [self addSubview:arrowView];
}

@end
