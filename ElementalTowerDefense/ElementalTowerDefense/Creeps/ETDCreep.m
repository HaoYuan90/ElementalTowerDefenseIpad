#import "ETDCreep.h"

@implementation ETDCreep
#define startingPositionIndicator 0
#define TARGET_ARROW_IMG @"targetArrow.png"

@synthesize toRemove;
@synthesize position;
@synthesize bounty;
@synthesize maxHP;
@synthesize currentHP;
@synthesize initVelocity;
@synthesize currentPositionIndicator;
@synthesize targetPoint;
@synthesize initResistance;
@synthesize createdBuff;
@synthesize delegate;
@synthesize normalImageName;
@synthesize deadImageName;
@synthesize hurtImageName;
@synthesize healthBar;
@synthesize currentSate;
@synthesize isTargetCreep;
@synthesize targetArrow;

- (void)loadCreatedBuffFromDictionary:(NSDictionary *)dic {
    
    BuffType type = [[dic valueForKey:creepBuffTypeTag] intValue];
    if (type != noBuff) {
        int duration = [[dic valueForKey:creepBuffDuraTag] intValue];
        double factor = [[dic valueForKey:creepBuffFactorTag] doubleValue];
        double rad = [[dic valueForKey:creepBuffRadTag] doubleValue];
        rad = [delegate getDataWRTMap:rad];
        createdBuff = [[ETDBuff alloc] initWithType:type duration:duration radius:rad factor:factor];
    } else {
        createdBuff = nil;
    }
}

- (void)loadGeneralDataFromDictionary:(NSDictionary *)dic {
    
    initVelocity = [[dic valueForKey:creepSpeedTag] doubleValue];
    initVelocity = [delegate getDataWRTMap:initVelocity];
    bounty = [[dic valueForKey:creepBountyTag] intValue];
    currentHP = [[dic valueForKey:hpTag] intValue];
    maxHP = currentHP;
    normalImageName = [dic valueForKey:normalImageNameTag];
    hurtImageName = [dic valueForKey:hurtImageNameTag];
    deadImageName = [dic valueForKey:deadImageNameTag];
    currentSate = 0;
    initResistance = [[ETDResistanceManager alloc] initWithDictionary:[dic valueForKey:creepResistanceTag]];
}

- (id)initFromDictionary:(NSDictionary *)dic WithDelegate:(id<ETDCreepDelegate>)del {
    // EFFECTS: constructs a ETDCreep with dictionary and the delegate.
    
    self = [super init];
    if (self == nil) {
        NSLog(@"malloc error");
        return nil;
    }
    toRemove = NO;
    delegate = del;
    currentPositionIndicator = startingPositionIndicator;
    targetPoint = [delegate waypoingPosition:currentPositionIndicator];
    position = targetPoint;
    [self loadGeneralDataFromDictionary:dic];
    buffManager = [[ETDBuffManager alloc] initWithDelegate:self];
    [self loadCreatedBuffFromDictionary:dic];
    return self;
}

- (void)removeFromGame {
    
    toRemove = YES;
    [delegate removeCreep:self];
    
    // remove all subviews
    for (UIView *temp in self.view.subviews) {
        [temp removeFromSuperview];
    }
    
    // animation when the creep dies.
    [UIView animateWithDuration:0.5 
                     animations:^(void) {self.view.alpha = 0.0;} 
                     completion:^(BOOL finished) {[self.view removeFromSuperview];}];
}

- (void)addToGame {
    [delegate addNewCreepOnMap:self];
}

- (void)updateTargetPoint {
    currentPositionIndicator ++;
    if(![delegate shouldExit:currentPositionIndicator]) {
        targetPoint = [delegate waypoingPosition:currentPositionIndicator];
    } else {
        [self removeFromGame];
    }
}

- (void)updateView {
    // creep die
    if (currentHP <= 0 && !toRemove) {
        //delegate method here for applying buff
        UIImage *creepImage = [UIImage imageNamed:deadImageName];
        [(UIImageView *)self.view setImage:creepImage];
        [self removeFromGame];
        currentSate = 2;
            
        // add buffs
        if (createdBuff) {
            [delegate addBuffsToCreep:createdBuff position:position];
        }
            
        //add bounty
        [delegate addCoins:bounty atPosition:self.position];
        
    } else if (currentHP <= maxHP/2 && currentSate!= 1) {
        // half HP -> hurt
        UIImage *creepImage = [UIImage imageNamed:hurtImageName];
        [(UIImageView *)self.view setImage:creepImage];
        currentSate = 1;
    }
    
}

- (void)updateStatus {
    
    // update buff manager
    [buffManager update];
    
    float currentVelocity = initVelocity * buffManager.velocityFactor;
    
    // Update position
    if ([self distanceBetweenPoint:position andPoint:targetPoint] < currentVelocity) {
        [self updateTargetPoint];
    }
    
    CGFloat xDist = (targetPoint.x - position.x);
    CGFloat yDist = (targetPoint.y - position.y);
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    CGFloat xUnit = xDist/distance;
    CGFloat yUnit = yDist/distance;
    position = CGPointMake(position.x + currentVelocity * xUnit, position.y+ currentVelocity * yUnit);
    
    [self updateView];
    [self.view setCenter:position];
}

- (void)hitByProjectileOfType:(ElementalType)type andDamage:(double)dmg {
    // EFFECTS: deducts the HP based on the projectile info, update the heath bar
    
    float resistanceValue = [initResistance resistanceFor:type] * (1 + buffManager.resistanceFactor);
    currentHP -= (1 - resistanceValue) * dmg;  
    
    //update heath bar
    double heightMultiplier = (1 - currentHP/maxHP);
    heightMultiplier = heightMultiplier < 1 ? heightMultiplier : 1;
    healthBar.frame = CGRectMake(creepHealthBarX, creepHealthBarY, creepHealthBarWidth, heightMultiplier*creepHealthBarMaxHeight);
}

- (void)addBuff:(ETDBuff *)buff {
    
    [buffManager addBuff:buff];
    switch (buff.type) {
        case kHealing:
            [delegate shouldDisplayArrowTagForBuff:kHealthChange :kIncrease At:position];
            break;
        case kStrengthening:
            [delegate shouldDisplayArrowTagForBuff:kResistanceChange :kIncrease At:position];
            break;
        case kHastening:
            [delegate shouldDisplayArrowTagForBuff:kSpeedChange :kIncrease At:position];
            break;
        default:
            break;
    }
}

- (void)increaseHPByFactor:(CGFloat)factor {
    
    currentHP *= (1 + factor);
    if (currentHP > maxHP) {
        currentHP = maxHP;
    }
    
    //update heath bar
    double heightMultiplier = (1 - currentHP/maxHP);
    heightMultiplier = heightMultiplier < 1 ? heightMultiplier : 1;
    healthBar.frame = CGRectMake(creepHealthBarX, creepHealthBarY, creepHealthBarWidth, heightMultiplier*creepHealthBarMaxHeight);
}

- (void)creepTapped {
    [delegate targetCreep:self];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)loadView {
    //Creep image
    UIImage *creepImage = [UIImage imageNamed:normalImageName];
    UIImageView *creep = [[UIImageView alloc] initWithImage:creepImage];
    self.view = creep;
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creepTapped)];
    [self.view addGestureRecognizer:tap];
    
    // Health bar image
    UIView *healthBarBackground = [[UIView alloc] initWithFrame:CGRectMake(creepHealthBarX, creepHealthBarY, creepHealthBarWidth, creepHealthBarMaxHeight)];
    healthBarBackground.backgroundColor = [UIColor greenColor];
    [self.view addSubview:healthBarBackground];
    healthBar = [[UIView alloc] initWithFrame:CGRectMake(creepHealthBarX, creepHealthBarY, creepHealthBarWidth, 0)];
    healthBar.backgroundColor = [UIColor redColor];
    [self.view addSubview:healthBar];
	
    // Create hidden target arrow
    targetArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TARGET_ARROW_IMG]];
    targetArrow.frame = CGRectMake(70, 0, 20, 30);
    [self.view addSubview:targetArrow];
    [self hideTargetArrow];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (double)distanceBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    return sqrt ( pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2) );
}

#pragma mark - Target arrow
- (void)showTargetArrow {
    targetArrow.hidden = NO;
}

- (void)hideTargetArrow {
    targetArrow.hidden = YES;
}

#pragma mark - Creep Mask
- (void)addMaskToCreep:(CreepMaskType)maskType inDuration:(double)dur {
    // EFFECTS: adds the animation images for freezng or burning
    
    UIImageView *mask;
    switch (maskType) {
        case kBurning:
            mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:creepBurningMaskImage]];
            break;
        case kFreezing:
            mask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:creepFreezingMaskImage]];
            break;
    }
    
    mask.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:mask];
    [UIView animateWithDuration:dur 
                     animations:^(void) {mask.alpha = 0;} 
                     completion:^(BOOL finished) {[mask removeFromSuperview];}];
}

@end
