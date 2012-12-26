#import "CoinTag.h"

@implementation CoinTag

#define coinTagWidth 80
#define coinTagHeight 20
#define disappearTime 1.5

@synthesize amount;

-(id)initWithAmt:(int)amt andPosition:(CGPoint)center
{
    self = [super initWithFrame:
            CGRectMake(center.x-coinTagWidth/2.0, center.y-coinTagHeight/2.0, coinTagWidth, coinTagHeight)];
    if(self == nil){
        NSLog(@"malloc error");
        return nil;
    }
    amount = amt;
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
    UILabel *amtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, coinTagWidth*1.8/3.0, coinTagHeight)];
    [amtLabel setText:[NSString stringWithFormat:@"%+d",amount]];
    amtLabel.opaque = NO;
    amtLabel.backgroundColor = [UIColor clearColor];
    amtLabel.textAlignment = UITextAlignmentRight;
    amtLabel.textColor = [UIColor yellowColor];
    [self addSubview:amtLabel];
    UIImage *coin = [UIImage imageNamed:@"coin.png"];
    UIImageView *coinView = [[UIImageView alloc] initWithImage:coin];
    coinView.frame = CGRectMake(coinTagWidth*2.0/3.0, 0, coinTagWidth/3.0, coinTagHeight);
    [self addSubview:coinView];
}

@end
