#import "SocialModeGameVC.h"
#import "UserDataFetcher.h"

@implementation SocialModeGameVC

//top left states
#define buttonPauseTitle (@"Pause")
#define pauseButtonImageName (@"pauseButton.png")
#define buttonPlayTitle (@"Play")
#define playButtonImageName (@"playButton.png")
#define buttonNextTitle (@"Next")
#define nextButtonImageName (@"nextButton.png")
#define dmgLabel (@"Damage:")

@synthesize gameArea;
@synthesize mask;
@synthesize multiStateButton;
@synthesize tileMap;
@synthesize DmgLabel;
@synthesize DmgNum;
@synthesize desc;
@synthesize friendMapInfo;
@synthesize creepSequence;
@synthesize isInPreviewMode;
@synthesize optionViewforSocial;
@synthesize endGameDialog;
@synthesize startGameDialog;

-(void)clearInfoPane
{
    [DmgLabel setText:@""];
    [DmgNum setText:@""];
    [desc setText:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - StartGameDialog delegate

- (void) startGame{
    [self setButtonStatePause];
    [tileMap.engine startCreepWave];
    [tileMap resumeGame];

}

#pragma mark - InGameOptions methods & EndGame methods

- (void) showInGameOptionsView {
    if(optionViewforSocial == nil)
    optionViewforSocial = [[InGameOptionVC alloc] initWithDelegate:self];
    else optionViewforSocial.view.hidden = NO;
    [self.view addSubview:optionViewforSocial.view];
}

- (void)restartPressed {
    [tileMap resumeGame];
    [tileMap.engine removeFromRunLoop];
    [self clearInfoPane];
    [optionViewforSocial.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goToMainMenuPressed {
    [tileMap resumeGame];
    [tileMap.engine removeFromRunLoop];
	[self.presentingViewController.presentingViewController.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)goToLevelSelectionPressed {
    //  go to friend select
    [tileMap resumeGame];
    [tileMap.engine removeFromRunLoop];
	[optionViewforSocial.view removeFromSuperview];
	[self.presentingViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)resumeGame {
    NSLog(@"resumeGame pressed");
	[optionViewforSocial.view removeFromSuperview];
    optionViewforSocial.view.hidden = YES;
	[tileMap resumeGame];
	mask.hidden = YES;
}

- (int) getTotalNumberOfCreeps{
    return [self.creepSequence count];
}

- (int) getNumberOfCreepsEscaped{
    return self.tileMap.totalEscapedCreeps;
}

#pragma mark - btmBar items

-(void)displayTowerInfo:(ETDTower*) tower
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [DmgLabel setText:dmgLabel];
    [DmgNum setText:[NSString stringWithFormat:@"%.1f",tower.damage]];
    [desc setText:tower.desc];
}

#pragma mark - topLeft control items

-(IBAction)homeButtonPressed:(UIButton*)sender
{
    //popover to ask if restart level or go back to main menu
    if(self.isInPreviewMode){
        tileMap = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [tileMap pauseGame];
        mask.hidden = NO;
        [self showInGameOptionsView];
    }
  
}

- (void) setButtonStatePause
{
    UIImage* pauseImage = [UIImage imageNamed:pauseButtonImageName];
    [multiStateButton setImage:pauseImage forState:UIControlStateNormal];
    [multiStateButton setTitle:buttonPauseTitle forState:UIControlStateNormal];
}
- (void) setButtonStatePlay
{
    UIImage* playImage = [UIImage imageNamed:playButtonImageName];
    [multiStateButton setImage:playImage forState:UIControlStateNormal];
    [multiStateButton setTitle:buttonPlayTitle forState:UIControlStateNormal];
}
- (void) setButtonStateNext
{
    UIImage* nextImage = [UIImage imageNamed:nextButtonImageName];
    [multiStateButton setImage:nextImage forState:UIControlStateNormal];
    [multiStateButton setTitle:buttonNextTitle forState:UIControlStateNormal];
}

- (IBAction)multiStateButtonPressed:(UIButton*)sender
{
      
    if([[sender titleForState:UIControlStateNormal] isEqualToString:buttonPauseTitle])
    {
        [tileMap pauseGame];
        [self setButtonStatePlay];
        mask.hidden = NO;
        [tileMap.view setUserInteractionEnabled:NO];
    }
    else if([[sender titleForState:UIControlStateNormal] isEqualToString:buttonPlayTitle])
    {
        [tileMap resumeGame];
        mask.hidden = YES;
        [self setButtonStatePause];
        [tileMap.view setUserInteractionEnabled:YES];
    }
    else if([[sender titleForState:UIControlStateNormal] isEqualToString:buttonNextTitle])
    {
        if(self.startGameDialog == nil)
        {
            self.startGameDialog = [[StartGameConfirmDialog alloc] initWithDelegate: self];
            self.startGameDialog.view.frame = CGRectMake(IPAD_LANDSCAPE_MAX_WIDTH/2 - 150, IPAD_LANDSCAPE_MAX_HEIGHT/2 - 100, 300, 200);
            [self.view addSubview: self.startGameDialog.view ];
        } else {
            [self.view addSubview: self.startGameDialog.view ];
        }
    }
}


#pragma mark - TileMapDelegate

- (UIView *)getSuperView 
{
    return self.view;
}
-(void)setInitLife:(int)life andCoin:(int)coin
{
    return;
}
-(void)didChangeLifeLeft:(int)life
{
    return;
}
-(void)didChangeCoin:(int)coin
{
    return;
}
-(void)didLostGame
{
    return;
}
-(void)didPlaceComboTower
{
    return;
}
-(void)handleTowerSelection:(ETDTower*)tower
{
    [self displayTowerInfo:tower];
}
-(void)didFinishCurrentWave:(float)percentage
{
    return;
}

- (void)showWarningOfType:(popoverWarningType)tp 
{
    return;
}

-(void)didFinishGame
{
    //determine win/lose
    if(!isInPreviewMode){
        endGameDialog = [[SocialModeEndGameDialog alloc] initWithDelegate:self];
        if([self.creepSequence count] != 0 )
        [endGameDialog showWinDialogWithStar:(self.tileMap.totalEscapedCreeps/([self.creepSequence count]))*3];
        else
             [endGameDialog showWinDialogWithStar:0];
        [self.view addSubview:endGameDialog.view];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // friendMapInfo is set by prepareSeques in SocialModeGameVC.m
    tileMap = [[TileMapViewController alloc] initSocialModeWithMapInfo:friendMapInfo CreepSequence:creepSequence Delegate:self];
    
    [gameArea addSubview:tileMap.view];
    [gameArea setContentSize:CGSizeMake(tileMap.width, tileMap.height)];
    
    [self setButtonStateNext];
    if(isInPreviewMode){
        multiStateButton.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [self setGameArea:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
    interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}


@end
