#import "GameTestViewController.h"

@implementation GameTestViewController

@synthesize gameArea;
@synthesize tileMap;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	tileMap = [[TileMapViewController alloc] initTestInterfaceFromFile:@"stage1_level4"];
    [gameArea addSubview:tileMap.view];
    [gameArea setContentSize:CGSizeMake(tileMap.width, tileMap.height)];
}

- (void)viewDidUnload
{
    [self setGameArea:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction) spawnCreep:(id)sender
{
    [tileMap.engine startCreepWave];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
