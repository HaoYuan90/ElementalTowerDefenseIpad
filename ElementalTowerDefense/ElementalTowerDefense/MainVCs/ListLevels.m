#import "ListLevels.h"
#import "NormalGameVC.h"

@interface ListLevels ()

@end

@implementation ListLevels
@synthesize stageName;
@synthesize background;
@synthesize levelFrameView;
@synthesize backButton;
@synthesize levelArea;
@synthesize listOfLevels;
@synthesize stageId;
@synthesize selectedLevel;

// Handle when the back button is pressed
- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    selectedLevel = NULL;
    listOfLevels = [[NSMutableArray alloc] init];
    levelFrameView.layer.cornerRadius = 30.0; 
    stageName.text = [[[GameDatabaseAccess alloc] init] getStageName:stageId];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // reload the game levels when the view appears
    [listOfLevels removeAllObjects];
    NSArray *levelModels = [[[GameDatabaseAccess alloc] init] getLevelsWithStageId:stageId];
    
    int levelNeedOpen = 0;
    for (int i = 0; i < levelModels.count; i++) {
        GameLevelModel *levelModel = [levelModels objectAtIndex:i];
        GameLevel *level = [[GameLevel alloc] initWithModel:levelModel position:i delegate:self];
        if (levelModel.highScore > 0) {
            levelNeedOpen = i + 1;
        }
        [levelArea addSubview:level.view];
        [listOfLevels addObject:level];
    }
    
    if (levelNeedOpen < levelModels.count) {
        [[listOfLevels objectAtIndex:levelNeedOpen] openLevel];
    }
    [levelArea setContentSize:CGSizeMake(800, (listOfLevels.count / NUMBER_LEVEL_VIEW_PER_ROW + 1) * (LEVEL_VIEW_HEIGHT + LEVEL_GAP_Y))];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    // remove all subviews of levelArea
    for (int i = [[levelArea subviews] count] - 1; i >= 0; i-- ) {
        [[[levelArea subviews] objectAtIndex:i] removeFromSuperview];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)playGame:(GameLevelModel *)levelModel {
    selectedLevel = levelModel;
    [self performSegueWithIdentifier:@"LevelToGame" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // add the information for the GamePlayViewController before transition
    if([segue.identifier isEqualToString:@"LevelToGame"]) {
        NormalGameVC *dest = (NormalGameVC*) segue.destinationViewController;
        dest.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        dest.model = selectedLevel;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // only support Landscape
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
