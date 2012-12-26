#import "ETDBuff.h"

@implementation ETDBuff
@synthesize type;
@synthesize duration;
@synthesize radius;
@synthesize factor;


- (id)initWithType:(BuffType)buffType duration:(int)time radius:(float)r factor:(CGFloat)f {
    // EFFECTS: constructs a ETDBuff.
    
    self = [super init];
    if (self) {
        type = buffType;
        duration = time;
        radius = r;
        factor = f;
    }
    return self;
}

- (void)update {
    // EFFECTS: update the duration.
    duration--;
}

@end
