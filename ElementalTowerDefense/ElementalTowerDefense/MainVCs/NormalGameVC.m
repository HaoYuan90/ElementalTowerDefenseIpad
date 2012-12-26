#import "NormalGameVC.h"

@implementation NormalGameVC

//top left states
#define buttonPauseTitle (@"Pause")
#define pauseButtonImageName (@"pauseButton.png")
#define buttonPlayTitle (@"Play")
#define playButtonImageName (@"playButton.png")
#define buttonNextTitle (@"Next")
#define nextButtonImageName (@"nextButton.png")
#define pointerEndPosition 4.37
//btm bar states
#define defaultSphereAlpha 0.8
#define sphereSelectedAlpha 1
#define dmgLabel (@"Damage:")
#define levelLabelPrefix (@"lvl")
#define upgradeCostLabelPrefix (@"Next Level costs:")
#define voidSphereImageName (@"voidSphere.png")
#define metalSphereImageName (@"metalSphere.png")
#define woodSphereImageName (@"woodSphere.png")
#define waterSphereImageName (@"waterSphere.png")
#define fireSphereImageName (@"fireSphere.png")
#define earthSphereImageName (@"earthSphere.png")

@synthesize model;
@synthesize gameArea;
@synthesize mask;
@synthesize icon;
@synthesize multiStateButton;
@synthesize pointer;
@synthesize lifeLabel;
@synthesize coinLabel;
@synthesize homeButton;
@synthesize clearButton;
@synthesize comboButton;
@synthesize tileMap;
@synthesize sphere1;
@synthesize sphere2;
@synthesize sel1;
@synthesize sel2;
@synthesize selection;
@synthesize DmgLabel;
@synthesize DmgNum;
@synthesize desc;
@synthesize levelLabel;
@synthesize upgradeCostLabel;
@synthesize invokeButton;
@synthesize CDMask;
@synthesize observedTower;
@synthesize isFirstWave;
@synthesize optionView;
@synthesize dialog;
@synthesize endGameView;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

// Hide the spheres as well as the Clear and Combo buttons
- (void)hideComboInterface {
    sphere1.hidden = YES;
    sphere2.hidden = YES;
    clearButton.hidden = YES;
    comboButton.hidden = YES;
}

// Show the spheres as well as the Clear and Combo buttons
- (void)showComboInterface {
    sphere1.hidden = NO;
    sphere2.hidden = NO;
    clearButton.hidden = NO;
    comboButton.hidden = NO;
}

// This method construct a new tileMap to start a new game
- (void)startGame {
    
    tileMap = [[TileMapViewController alloc] initNormalGameFromFile:model.fileName withDelegate:self totalCoins:model.initCoins totalLife:model.initLife];
    
    // show introduction dialog
    [self showIntroductionDialog];
    
    [gameArea addSubview:tileMap.view];
    [gameArea setContentSize:CGSizeMake(tileMap.width, tileMap.height)];
    [self clearElementSelection];
    [sphere1 setUserInteractionEnabled:YES];
    [sphere2 setUserInteractionEnabled:YES];
    icon.hidden = YES;
    CDMask.hidden = YES;
    invokeButton.hidden = YES;
    invokeButton.enabled = NO;
    
    UITapGestureRecognizer *singleTapping = [[UITapGestureRecognizer alloc]
                                             initWithTarget:self action:@selector(sphere1Selected:)];
    singleTapping.numberOfTapsRequired = 1;
    [sphere1 addGestureRecognizer:singleTapping];
    singleTapping = [[UITapGestureRecognizer alloc]
					 initWithTarget:self action:@selector(sphere2Selected:)];
    singleTapping.numberOfTapsRequired = 1;
    [sphere2 addGestureRecognizer:singleTapping];
    
    [self setButtonStateNext];
    isFirstWave = YES;
	
    mask.hidden = YES;
    
    pointer.transform = CGAffineTransformMakeRotation(0);
    
    if (model.disableComboInterface)
        [self hideComboInterface];
    else 
        [self showComboInterface];
}

// Show introduction dialog, freeze game until player has read through all the dialogs or player clicks Skip button
- (void)showIntroductionDialog {
    dialog = [[ETDDialog alloc] initWithSuperView:self.view];
    [dialog freezeScreen];
    [dialog showDialogs:model.dialogs];
}

#pragma mark - Help Button

// Handle when the user press the Help button
- (IBAction)helpButtonPressed:(id)sender {
    [self showHelp];
}

// Show help when user press Help Button
- (void)showHelp {
    [tileMap pauseGame];
    mask.hidden = NO;
    HelpPopOverVC *popover = [[HelpPopOverVC alloc] initWithDelegate:self];
    [self addChildViewController:popover];
    [self.view addSubview:popover.view];
}

// Close help and resume the game automatically
- (void)closeHelp {
    mask.hidden = YES;
    [tileMap resumeGame];
}

#pragma mark - InGameOptions methods

// Show in-game options where player can restart/go to main menu/go to level selection/resume the game.
- (void)showInGameOptionsView {
    optionView = [[InGameOptionVC alloc] initWithDelegate:self];
    [self.view addSubview:optionView.view];
}

// Handle when restart option is chose
- (void)restartPressed {
    [tileMap.engine removeFromRunLoop];
    [tileMap resumeGame];
    [self clearInfoPane];
    [optionView.view removeFromSuperview];
    [self startGame];
}

// Handle when go to main menu option is chose
- (void)goToMainMenuPressed {
    [tileMap.engine removeFromRunLoop];
    [tileMap resumeGame];
    [self.presentingViewController.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
}

// Handle when go to level selection is chose
- (void)goToLevelSelectionPressed {
    [tileMap.engine removeFromRunLoop];
    [tileMap resumeGame];
    [optionView.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Resume game when resume option is chose
- (void)resumeGame {
    [optionView.view removeFromSuperview];
    [tileMap resumeGame];
    mask.hidden = YES;
}

#pragma mark - handle warning popups
// Show a warning popup to help player get familiar with the gameplay
- (void)showWarningOfType:(popoverWarningType)tp {
    [tileMap pauseGame];
    WarningPopOverVC *popover = [[WarningPopOverVC alloc] initWithWarningType:tp andDelegate:self];
    [self addChildViewController:popover];
    [self.view addSubview:popover.view];
}

// Destruct the pop over warning
- (void)popOverSelfDestructed {
    [tileMap resumeGame];
}

#pragma mark - icon controls

-(void)animateIcon {
    if(icon.hidden == NO) {
        icon.alpha = 0.5;
        [UIView animateWithDuration:1 
                         animations:^(void){icon.alpha = 0;}
                         completion:^(BOOL finished){[self animateIcon];}];
    }
}

#pragma mark - btmBar items
// Reset two spheres to theirs default alpha
-(void)resetSpheresAlpha {
    sphere1.alpha = defaultSphereAlpha;
    sphere2.alpha = defaultSphereAlpha;
}

// Reset two spheres to their default image
-(void)resetSpheresImage {
    UIImage *voidSphere = [UIImage imageNamed:voidSphereImageName];
    sphere1.image = voidSphere;
    sphere2.image = voidSphere;
}

// Clear all user selection for combo, reset the two spheres to theirs default
-(void)clearElementSelection {
    [self resetSpheresAlpha];
    [self resetSpheresImage];
    sel1 = nil;
    sel2 = nil;
    selection = 0;
}

// Clear the Info Pane
-(void)clearInfoPane {
    CDMask.hidden = YES;
    invokeButton.hidden = YES;
    invokeButton.enabled = NO;
    [DmgLabel setText:@""];
    [DmgNum setText:@""];
    [desc setText:@""];
    [levelLabel setText:@""];
    [upgradeCostLabel setText:@""];
}

// Handle when the combo button is pressed
// If it is an INVALID combo -> show an warning
// If it is a VALID combo -> contruct a respective tower -> clean up
- (IBAction)comboButtonPressed:(UIButton *)sender {
    [self clearInfoPane];
    [tileMap destroyTowerButtons];
    
    ElementalType tp1 = noElement;
    if(sel1 != nil)
        tp1 = sel1.elementType;
    ElementalType tp2 = noElement;
    if(sel2 != nil)
        tp2 = sel2.elementType;

    TowerType towerType = [ETDComboChecker getComboOf:tp1 :tp2 :noElement];
    
    if (towerType != noTower) {
        ETDTower *temp = [ETDTowerFactory createNewTowerOfType:towerType withDelegate:tileMap];
        [tileMap shouldPlaceTowerOnNextTap:temp];
        //create the flashing icon
        [temp.view setFrame:CGRectMake(0, 0, icon.frame.size.width, icon.frame.size.height)];
        [icon addSubview:temp.view];
        icon.alpha = 0.5;
        icon.hidden = NO;
        [self animateIcon];
    
        //remove all towers and selection
        [tileMap removeTower:sel1];
        [tileMap removeTower:sel2];
        [self clearElementSelection];
    } else {
        [self showWarningOfType:invalidComboWarning];
    }
}

// Handle when clear button is pressed
- (IBAction)clearButtonPressed:(UIButton *)sender {
    [self clearElementSelection];
}

// Handle when sphere 1 is selected
- (void)sphere1Selected:(UITapGestureRecognizer *)gesture {
    // remove the tower buttons
    [tileMap destroyTowerButtons]; 
    [self resetSpheresAlpha];
    sphere1.alpha = sphereSelectedAlpha;
    selection = 1;
}

// Handle when sphere 2 is selected
- (void)sphere2Selected:(UITapGestureRecognizer *)gesture {
    // remove the tower buttons
    [tileMap destroyTowerButtons]; 
    [self resetSpheresAlpha];
    sphere2.alpha = sphereSelectedAlpha;
    selection = 2;
}

// Determine to show or hide the Invoke Button based on the tower's information
// If tower has special ability -> show Invoke button with mask reflecting tower cooddownState
// Otherwise -> hide Invoke button
- (void)changeInvokeButtonAndMaskState:(ETDTower *)tower {
 
    if(tower.specialAbilityCDState == 0) {
        CDMask.hidden = YES;
        //do something to init the special ability and ready for invoke
        invokeButton.enabled = YES;
    } else {
        CGPoint maskFrameOrigin = CDMask.frame.origin;
        CGFloat maskFrameHeight = CDMask.frame.size.height;
        CGFloat maskFrameWidth = invokeButton.frame.size.width * tower.specialAbilityCDState/tower.specialAbilityCD;
        [CDMask setFrame:CGRectMake(maskFrameOrigin.x, maskFrameOrigin.y, maskFrameWidth, maskFrameHeight)];
    }
}

// Handle when the invoke button pressed -> perform tower special ability
- (IBAction)invokeButtonPressed:(UIButton *)sender {
    if (observedTower == nil) {
        [self clearInfoPane];
    } else {
        //unleash special ability
        [observedTower invokeSpecialAbility];
        observedTower.specialAbilityCDState = observedTower.specialAbilityCD;
        CDMask.hidden = NO;
        invokeButton.enabled = NO;
        [self changeInvokeButtonAndMaskState:observedTower];
    }
}

// Display tower's information in the information pane
- (void)displayTowerInfo:(ETDTower *)tower {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [DmgLabel setText:dmgLabel];
    [DmgNum setText:[NSString stringWithFormat:@"%.1f",tower.damage]];
    [desc setText:tower.desc];
    [levelLabel setText:[NSString stringWithFormat:@"%@%d",levelLabelPrefix, tower.level]];
    if (tower.level<tower.maxLevel){
        upgradeCostLabel.hidden = NO;
        [upgradeCostLabel setText:[NSString stringWithFormat:@"%@%d",upgradeCostLabelPrefix, tower.upgradeCost]];
    } else {
        upgradeCostLabel.hidden = YES;
    }
    
    if (tower.specialAbilityCD != -1) {
        observedTower = tower;
        CDMask.hidden = NO;
        invokeButton.hidden = NO;
        [self changeInvokeButtonAndMaskState:tower];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(specialAbilityCDChanged:) name:towerSACDStateTag object:tower];
    } else {
        observedTower = nil;
        CDMask.hidden = YES;
        invokeButton.hidden = YES;
        invokeButton.enabled = NO;
    }
}

// Handle the change in tower's special ability cooldown
- (void)specialAbilityCDChanged:(NSNotification *)notification {
    [self changeInvokeButtonAndMaskState:notification.object];
}

// Handle when combo tower has been placed to the map -> hide the icon in bottom right corner
- (void)didPlaceComboTower {
    icon.hidden = YES;
}

// Handle when player select a specific tower
// In every case: Display tower's info
// Based on the sphere selected, the response may vary
- (void)handleTowerSelection:(ETDTower *)tower {
    [self displayTowerInfo:tower];
    
    //no sphere is selected
    if (selection == 0) {
        return;
    }
    
    [tileMap destroyTowerButtons];
    
    if(tower.level != 1) {
        [self showWarningOfType:comboContainingHighLevelTowerWarning];
        [self resetSpheresAlpha];
        selection = 0;
        return;
    }
    if(sel1 == tower || sel2 == tower) {
        [self showWarningOfType:selectedSameTowerComboWarning];
        [self resetSpheresAlpha];
        selection = 0;
        return;
    }
	
    ElementalType type = tower.elementType;
    
    if (type == noElement) {
		[self showWarningOfType:notBasicElementWarning];
    } else {
        if(sel1.elementType == type || sel2.elementType == type) {
            [self showWarningOfType:selectedSameElementComboWarning];
        } else {
            UIImage* sphere;
            switch (type) {
                case kMetal:
                    sphere = [UIImage imageNamed:metalSphereImageName];
                    break;
                case kWood:
                    sphere = [UIImage imageNamed:woodSphereImageName];
                    break;
                case kFire:
                    sphere = [UIImage imageNamed:fireSphereImageName];
                    break;
                case kWater:
                    sphere = [UIImage imageNamed:waterSphereImageName];
                    break;
                case kEarth:
                    sphere = [UIImage imageNamed:earthSphereImageName];
                    break;
                default:
                    break;
            }
            switch (selection) {
                case 1:
                    sphere1.image = sphere;
                    sel1 = tower;
                    break;
                case 2:
                    sphere2.image = sphere;
                    sel2 = tower;
                    break;
                default:
                    break;
            }
        }
    }
    [self resetSpheresAlpha];
    selection = 0;
}

#pragma mark - topLeft control items

// Handle when home button is pressed
- (IBAction)homeButtonPressed:(UIButton *)sender {
    //popover to ask if restart level or go back to main menu
    [tileMap pauseGame];
    mask.hidden = NO;
    [self showInGameOptionsView];
}

// Make the circular button become pause button
- (void)setButtonStatePause {
    UIImage *pauseImage = [UIImage imageNamed:pauseButtonImageName];
    [multiStateButton setImage:pauseImage forState:UIControlStateNormal];
    [multiStateButton setTitle:buttonPauseTitle forState:UIControlStateNormal];
    homeButton.enabled = YES;
}

// Make the circular button become play button
- (void)setButtonStatePlay {
    UIImage *playImage = [UIImage imageNamed:playButtonImageName];
    [multiStateButton setImage:playImage forState:UIControlStateNormal];
    [multiStateButton setTitle:buttonPlayTitle forState:UIControlStateNormal];
    homeButton.enabled = NO;
}

// Make the circular button become next button
- (void)setButtonStateNext {
    UIImage *nextImage = [UIImage imageNamed:nextButtonImageName];
    [multiStateButton setImage:nextImage forState:UIControlStateNormal];
    [multiStateButton setTitle:buttonNextTitle forState:UIControlStateNormal];
    [tileMap pauseGame];
}

// Handle when the multi state button is pressed
// If it is in PAUSE state: pause the game
// If it is in PLAY state: resume the game
// If it is in NEXT state: send the next creep wave
- (IBAction)multiStateButtonPressed:(UIButton *)sender {
    
    if([[sender titleForState:UIControlStateNormal] isEqualToString:buttonPauseTitle]) {
        [tileMap pauseGame];
        [self setButtonStatePlay];
        mask.hidden = NO;
        [tileMap.view setUserInteractionEnabled:NO];
    } else if([[sender titleForState:UIControlStateNormal] isEqualToString:buttonPlayTitle]) {
        [tileMap resumeGame];
        mask.hidden = YES;
        [self setButtonStatePause];
        [tileMap.view setUserInteractionEnabled:YES];
    } else if([[sender titleForState:UIControlStateNormal] isEqualToString:buttonNextTitle]) {
        //send in the next wave
        isFirstWave = NO;
        //block all signals until first wave is sent
        [self setButtonStatePause];
        [tileMap.engine startCreepWave];
        [tileMap resumeGame];
    }
}

#pragma mark - TileMapDelegate

- (UIView *)getSuperView {
    return self.view;
}

// Initialize the game with the given life and coin from the tileMapVC
- (void)setInitLife:(int)life andCoin:(int)coin {
    [lifeLabel setText:[NSString stringWithFormat:@"%d",life]];
    [coinLabel setText:[NSString stringWithFormat:@"%d",coin]];
}

// Update the lives left when being notified that a creep passed through the field
- (void)didChangeLifeLeft:(int)life {
    if (life < 0) {
        life = 0;
    }
    [lifeLabel setText:[NSString stringWithFormat:@"%d",life]];
}

// Change coin to a specific amount upon being notified when a creep get killed or a tower has been built/upgraded
- (void)didChangeCoin:(int)coin {
    assert(coin>=0);
    [coinLabel performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%d",coin] waitUntilDone:NO];
    //[coinLabel setText:[NSString stringWithFormat:@"%d",coin]];
}

// Handle when being notified that a creep wave has finished
- (void)didFinishCurrentWave {
    [tileMap resumeGame];
    mask.hidden = YES;
    [self setButtonStatePause];
    [tileMap.view setUserInteractionEnabled:YES];
    [self setButtonStateNext];
}

// Handle when being notified that a creep wave has finished with a percentage
- (void)didFinishCurrentWave:(float)percentage {
    if (isFirstWave) {
        return;
    }
    [self performSelector:@selector(didFinishCurrentWave) withObject:nil afterDelay:2.0];
    pointer.transform = CGAffineTransformMakeRotation(percentage*pointerEndPosition);
}


#pragma mark - finish games

// Handle when the player won the game -> clear level
- (void)didFinishGame {
    [self performSelector:@selector(levelCleared) withObject:nil afterDelay:1.0];
}

// Clear level, display needed information and prompt player for next action
- (void)levelCleared {
    int lifeLeft = [lifeLabel.text intValue];
    if (lifeLeft <= 0) {
        return;
    }
    BOOL isNewHighScore = lifeLeft > model.highScore;
    if (isNewHighScore) {
        // save new high score
        [[[GameDatabaseAccess alloc] init] updateHighScore:lifeLeft levelId:model.levelId];
        model.highScore = lifeLeft;
    }
    
    if (!endGameView) {
        endGameView = [[EndGameDialogVC alloc] initWithDelegate:self];
    }
    
    [endGameView showWinDialogWithStar:round(3.0*lifeLeft/model.initLife) 
                           isHighScore:isNewHighScore 
                           nextLevelId:model.nextLevelId];
    [self.view addSubview:endGameView.view];
}

// Handle when player lost the game
- (void)didLostGame {
    [self performSelector:@selector(levelFail) withObject:nil afterDelay:1.0];
}

// Level fail -> Display neened information, ask player for next action
- (void)levelFail {
    if (!endGameView) {
        endGameView = [[EndGameDialogVC alloc] initWithDelegate:self];
    }
    
    [endGameView showLevelFailDialog];
    [self.view addSubview:endGameView.view];
}

// Handle go to next level button pressed
- (void)goToNextLevelPressed {
    // EFFECTS: goes to the next level.
    
    [endGameView.view removeFromSuperview];
    if (model.nextLevelId > 0) {
        model = [[[GameDatabaseAccess alloc] init] getLevelModelWithId:model.nextLevelId];
    }
    [self startGame];
}

// Handle push to server button pressed
- (void)pushToServerPressed {
    // EFFECTS: push the map information to server to challenge the friends.
    
    // check the internet
    NSError *error = nil;
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.google.com"];
    NSString *URLString = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    if(URLString == NULL) {
        [[[UIAlertView alloc] initWithTitle:@"NETWORK PROBLEM" 
                                    message:@"The Internet connection is unavailable!" 
                                   delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles: nil] show];
        return;
    }
    
    // check the user_fb_id available
    NSString *user_fb_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if ([user_fb_id length] == 0) {
        [self requireUserLoginFB];
        return;
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self  name:@"ReceivedUserId" object:nil];
    };
    
    NSArray *info_towers = tileMap.engine.getTowersInfo;
    BOOL check = [UserDataFetcher putMapWithUserId:user_fb_id 
                                             stage:[NSString stringWithFormat:@"%d", model.levelId ] 
                                              wave:@"0"  
                                            towers:info_towers];
    if (check) {
        [[[UIAlertView alloc] initWithTitle:@"Push level" 
                                    message:@"Your data is submitted successfully!" 
                                   delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles: nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Push level" 
                                    message:@"There is an error when submitting your data." 
                                   delegate:nil 
                          cancelButtonTitle:@"OK" 
                          otherButtonTitles: nil] show];
    }
}

// login to facebook
- (void)requireUserLoginFB {
    
    FBConnector *fb = [FBConnector sharedFaceBookConnector];
    if (![fb login]) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(pushToServerPressed) 
                                                     name:@"ReceivedUserId" 
                                                   object:nil];
    } else {
        //request
        [self pushToServerPressed];
    }
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startGame];
}

- (void)viewDidUnload {
    [self setHomeButton:nil];
    [super viewDidUnload];
    tileMap = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
