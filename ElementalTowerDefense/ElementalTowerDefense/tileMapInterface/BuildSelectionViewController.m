#import "BuildSelectionViewController.h"

@implementation BuildSelectionViewController

#define selectionPanelImageName (@"selectionPanel.PNG")
#define initWidth 10
#define initHeight 10
#define Width 250
#define Height 250

#define purple CGRectMake(90,0,70,60)
#define red CGRectMake(0,60,60,70)
#define green CGRectMake(35,180,65,70)
#define yellow CGRectMake(190,70,60,60)
#define blue CGRectMake(155,180,65,70)

@synthesize center;
@synthesize tileNumber;
@synthesize delegate;

- (id)initWithCenter:(CGPoint)ct tileNumber:(int)tileNum Delegate: (id<BuildSelectionDelegate>) del
{
    self = [super init];
    if (self==nil) {
        NSLog(@"malloc error at BuildSelectionVC");
        return nil;
    }
    tileNumber = tileNum;
    center = ct;
    delegate = del;
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)singleTap:(UITapGestureRecognizer *)gesture
{   
    //determine user's choice and build corresponding tower on tile.
    CGPoint temp = [gesture locationInView:self.view];
    if(temp.x > purple.origin.x && temp.x < purple.origin.x+purple.size.width 
       && temp.y > purple.origin.y && temp.y < purple.origin.y+purple.size.height)
        [delegate didSelect:kMetalTower At:tileNumber];
    else if(temp.x > red.origin.x && temp.x < red.origin.x+red.size.width 
       && temp.y > red.origin.y && temp.y < red.origin.y+red.size.height)
        [delegate didSelect:kFireTower At:tileNumber];
    else if(temp.x > yellow.origin.x && temp.x < yellow.origin.x+yellow.size.width 
       && temp.y > yellow.origin.y && temp.y < yellow.origin.y+yellow.size.height)
        [delegate didSelect:kEarthTower At:tileNumber];
    else if(temp.x > green.origin.x && temp.x < green.origin.x+green.size.width 
       && temp.y > green.origin.y && temp.y < green.origin.y+green.size.height)
        [delegate didSelect:kWoodTower At:tileNumber];
    else if(temp.x > blue.origin.x && temp.x < blue.origin.x+blue.size.width 
       && temp.y > blue.origin.y && temp.y < blue.origin.y+blue.size.height)
        [delegate didSelect:kWaterTower At:tileNumber];
    else
        [delegate destroySelectionPanel];
}

#pragma mark - View lifecycle

- (void)loadView
{
    UIImage *selectionPanelImage = [UIImage imageNamed:selectionPanelImageName];
    UIImageView *selectionPanel = [[UIImageView alloc] initWithImage:selectionPanelImage];
    [selectionPanel setUserInteractionEnabled:YES];
    selectionPanel.frame = CGRectMake(center.x-initWidth/2, center.y-initHeight/2, initWidth, initHeight);
    self.view = selectionPanel;
    [UIView animateWithDuration:0.4 animations:^(void){
        selectionPanel.frame = CGRectMake(center.x-Width/2, center.y-Height/2, Width, Height);
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *singleTapping = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(singleTap:)];
    singleTapping.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapping];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
