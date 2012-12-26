#import "CritTag.h"

@implementation CritTag

#define critTagWidth 90
#define critTagHeight 30
#define disappearTime 1.5

@synthesize damage;

-(id)initWithDmg:(double)dmg andPosition:(CGPoint)center
{
    self = [super initWithFrame:
            CGRectMake(center.x-critTagWidth/2.0, center.y-critTagHeight/2.0, critTagWidth, critTagHeight)];
    if(self == nil){
        NSLog(@"malloc error");
        return nil;
    }
    damage = dmg;
    self.opaque = NO;
    [UIView animateWithDuration:disappearTime animations:^(void){
        self.alpha = 0;
        self.center = CGPointMake(center.x, center.y-40);
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
    return self;
}

- (void)drawRect:(CGRect)rect
{
    UILabel *amtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, critTagWidth, critTagHeight)];
    [amtLabel setText:[NSString stringWithFormat:@"%.0f",damage]];
    amtLabel.opaque = NO;
    amtLabel.backgroundColor = [UIColor clearColor];
    amtLabel.textAlignment = UITextAlignmentCenter;
    amtLabel.textColor = [UIColor redColor];
    amtLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:amtLabel];
}

@end
