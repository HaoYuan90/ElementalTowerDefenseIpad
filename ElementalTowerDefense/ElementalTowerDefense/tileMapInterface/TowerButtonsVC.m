#import "TowerButtonsVC.h"

@implementation TowerButtonsVC

#define sellButtonImageName (@"sellButton.png")
#define specialAbilityButtonImageName (@"specialAbility.png")
#define upgradeButtonImageName (@"upgradeButton.png")
#define grayedSellButtonImageName (@"grayedSellButton.png")
#define grayedUpgradeButtonImageName (@"grayedUpgradeButton.png")

@synthesize target;
@synthesize delegate;

- (id)initWithTower:(ETDTower*)tower andDelegate:(id<TowerButtonsDelegate>)del
{
    self = [super init];
    if (self == nil){
        NSLog(@"malloc error at buttons");
        return nil;
    }
    target = tower;
    delegate = del;
    return self;
}

- (void)loadView 
{
    CGRect towerFrame = target.view.frame;
    UIView *mask = [[UIView alloc] initWithFrame:towerFrame];
    //mask.backgroundColor = [UIColor clearColor];
    self.view = mask;
    [mask setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTapping = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(tapped:)];
    singleTapping.numberOfTapsRequired = 2;
    [mask addGestureRecognizer:singleTapping];

    // Left button = SELL BUTTON
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, towerFrame.size.height*2.0/3, 
                                  towerFrame.size.width*1.0/3, towerFrame.size.height*1.0/3);
    [leftButton setImage:[UIImage imageNamed:sellButtonImageName] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonPressed:) forControlEvents:UIControlEventTouchDown];
	[self.view addSubview:leftButton];
	
	// RIGHT BUTTON -> if level < maxLevel : UPGRADE BUTTON
	// RIGHT BUTTON -> if level = maxLevel : disabled UPGRADE BUTTON
    UIButton *rightButton =[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(towerFrame.size.width*2.0/3, towerFrame.size.height*2.0/3, 
                                   towerFrame.size.width*1.0/3, towerFrame.size.height*1.0/3);
	if (target.level == target.maxLevel) {
		[rightButton setImage:[UIImage imageNamed:grayedUpgradeButtonImageName] forState:UIControlStateNormal];
		rightButton.userInteractionEnabled = NO;
	} else {
        [rightButton setImage:[UIImage imageNamed:upgradeButtonImageName] forState:UIControlStateNormal];
		[rightButton addTarget:self action:@selector(upgradePressed:) forControlEvents:UIControlEventTouchDown];
	}
	[self.view addSubview:rightButton];
}

- (IBAction)leftButtonPressed:(id)sender
{
    [target sold];
    [delegate destroyTowerButtons];
}

- (IBAction)upgradePressed:(id)sender
{
	[target upgrade];
	[target.delegate didSelectTower:target];
}

- (void)tapped:(UITapGestureRecognizer*) gesture
{
    [target towerSelected:gesture];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
    interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
