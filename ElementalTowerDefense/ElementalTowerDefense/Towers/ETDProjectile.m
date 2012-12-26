#import "ETDProjectile.h"

@implementation ETDProjectile

@synthesize position;
@synthesize target;
@synthesize speed;
@synthesize positionalOffset;
@synthesize level;
@synthesize damage;
@synthesize delegate;
@synthesize projectileType;
@synthesize hasSpecialEffect;
@synthesize maxLevel;

- (NSDictionary*)loadGeneralDataFromDictionary:(NSDictionary*)generalDic
{
    maxLevel = [[generalDic valueForKey:maxLevelTag] intValue];
    NSString *levelKey = [NSString stringWithFormat:@"%@%d", levelPrefix, level];
    NSDictionary *levelInfo = [generalDic valueForKey:levelKey];
    speed = [[levelInfo valueForKey:projectileSpeedTag] doubleValue];
    speed = [delegate getDataWRTMap:speed];
    positionalOffset = projectilePositionalOffset*speed;
    damage = [[levelInfo valueForKey:dmgTag] doubleValue];
    return levelInfo;
}

- (id)initWithPosition:(CGPoint)point withTarget:(ETDCreep *)tar 
       projectileLevel:(int)lvl Delegate:(id<ETDProjectileDelegate>)del
{
    // EFFECTS: constructs a new projectile.
    level = lvl;
    position = point;
    target = tar;
    delegate = del;
	
	// NO Special Effect by default
	hasSpecialEffect = NO;
	
    // add animation when hitting the creep
    
    return self;
}

- (void)updateStatus 
{
    // update the position based on the _target positon
    CGFloat xDist = (target.position.x - position.x);
    CGFloat yDist = (target.position.y - position.y);
    
    // check whether the projectile hits the creep or not
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
    if (distance <= positionalOffset) {
		if (hasSpecialEffect) {
			[self performSpecialEffect];
		} else {
			[target hitByProjectileOfType:projectileType andDamage:damage];
		}
        [delegate destructProjectile:self];
        // show animation when hitting the creep
        
        return;
    }
    CGFloat xUnit = xDist/distance;
    CGFloat yUnit = yDist/distance;
    CGFloat angle = acos(fabs(yDist)/distance);
    if(yUnit<=0 && xUnit<=0)
        angle = -angle;
    else if(yUnit<=0 && xUnit>=0)
        angle = angle;
    else if(yUnit>=0 && xUnit>=0)
        angle = M_PI-angle;
    else 
        angle = angle-M_PI;
    position = CGPointMake(position.x + speed * xUnit, position.y+ speed * yUnit);
    
    [self.view setCenter:position];
    self.view.transform = CGAffineTransformMakeRotation(angle);
}

- (void)performSpecialEffect 
{
	[target hitByProjectileOfType:projectileType andDamage:damage];
}

#pragma mark - Loading related class methods

+ (NSDictionary*)getDataForProjectileFromFile:(NSString*)fileName
{
    NSString *bundle = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]; 
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:bundle];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSDictionary* temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!temp)
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    return [temp valueForKey:projectileInfoTag];

}

#pragma mark - View lifecycle

- (void)viewDidLoad 
{
    [super viewDidLoad];
}


@end
