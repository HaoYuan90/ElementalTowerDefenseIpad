#import "ETDBuffManager.h"

// Private Interface

@implementation ETDBuffManager

@synthesize buffs;
@synthesize velocityFactor;
@synthesize resistanceFactor;
@synthesize delegate;
@synthesize shouldFreezeCreep;

- (id)initWithDelegate:(id<ETDBuffManagerDelegate>)del {
    // EFFECTS: constructs a ETDBuffManager with the delegate.
    
    self = [super init];
    if (self) {
        delegate = del;
        buffs = [[NSMutableArray alloc] init];
        velocityFactor = 0;
        resistanceFactor = 0;
    }
    return self;
}

- (void)addBuff:(ETDBuff *)buff {
    // EFFECTS: adds buff to the array of buffs.
    
    [buffs addObject:buff];
}

- (void)update {
    // EFFECTS: updates the status of buffs.
    
    float maxHastening = 0;
    float maxStrengthening = 0;
    float maxSlowing = 0;
    shouldFreezeCreep = NO;
    for (int i = [buffs count] - 1; i >= 0; i--) {
        ETDBuff *buff = [buffs objectAtIndex:i];
        if (buff.type == kHastening && maxHastening < buff.factor) {
            maxHastening = buff.factor;
        } else if (buff.type == kStrengthening && maxStrengthening < buff.factor) {
            maxStrengthening = buff.factor;
        } else if (buff.type == kHealing) {
            [delegate increaseHPByFactor:buff.factor];
        } else if (buff.type == kSlowing && maxSlowing < buff.factor){
            maxSlowing = buff.factor;
        } else if (buff.type == kFreeze) {
            shouldFreezeCreep = YES;
        }
                   
        [buff update];
        if (buff.duration <= 0) {
            [buffs removeObject:buff];
        }
    }
    
    if (shouldFreezeCreep) {
        velocityFactor = 0;
    } else {
        velocityFactor = 1 + maxHastening - maxSlowing;
    }
    resistanceFactor = maxStrengthening;
}

@end
