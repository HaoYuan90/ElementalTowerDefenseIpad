#import "WarningPopOverVC.h"

@implementation WarningPopOverVC

#define textContainerImageName (@"scroll.png")
#define buttonImageName (@"okButton.png")
#define textContainerFrame CGRectMake(210,100,600,450)
#define buttonFrame CGRectMake(460, 400, 100, 100)
#define descFrame CGRectMake(305, 150, 390, 250)
#define maskFrame CGRectMake(0,0,1024,768)

@synthesize type;
@synthesize desc;
@synthesize delegate;

- (id)initWithWarningType:(popoverWarningType)tp andDelegate:(id<WarningPopOverDelegate>)del
{
    self = [super init];
    if (self == nil){
        NSLog(@"malloc error at warning popover");
        return nil;
    }
    type = tp;
    delegate = del;
    
    return self;
}

- (void)loadView
{
    UIView *container = [[UIView alloc] initWithFrame: maskFrame];
    container.backgroundColor = [UIColor clearColor];
    self.view = container;
    UIView *mask = [[UIView alloc] initWithFrame:container.frame];
    mask.backgroundColor = [UIColor blackColor];
    mask.alpha = 0.4;
    [self.view addSubview:mask];
    UIImage *bg = [UIImage imageNamed:textContainerImageName];
    UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
    [bgView setUserInteractionEnabled:YES];
    bgView.frame = textContainerFrame;
    [self.view addSubview:bgView];
    UIButton *okeyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [UIImage imageNamed:buttonImageName];
    [okeyButton setImage:buttonImage forState:UIControlStateNormal];
    okeyButton.frame = buttonFrame;
    [okeyButton addTarget:self action:@selector(dismissWarning:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:okeyButton];
    desc = [[UILabel alloc] init];
    desc.frame = descFrame;
    desc.backgroundColor = [UIColor clearColor];
    desc.textColor = [UIColor grayColor];
    desc.font = [UIFont systemFontOfSize:50];
    desc.numberOfLines = 0;
    [self.view addSubview:desc];
}

- (IBAction)dismissWarning:(id)sender
{
    [delegate popOverSelfDestructed];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    switch (type){
        case selectedSameTowerComboWarning:
            [desc setText:@"Cannot select the same tower twice for a combo"];
            break;
        case selectedSameElementComboWarning:
            [desc setText:@"Cannot select the same element twice for a combo"];
            break;
        case comboContainingHighLevelTowerWarning:
            [desc setText:@"You can only combine elements in their most basic form"];
            break;
        case invalidComboWarning:
            [desc setText:@"You cannot combine these elements"];
            break;
        case notEnoughCoinsWarning:
            [desc setText:@"You need more coins"];
            break;
        case notBasicElementWarning:
            [desc setText:@"Element is not one of the 5 prime elements"];
            break;
        default:
            break;
    }
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
