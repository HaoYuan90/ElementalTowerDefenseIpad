//actual single player game interface
#import <UIKit/UIKit.h>
#import "TileMapDelegate.h"
#import "TileMapViewController.h"
#import "ETDComboChecker.h"
#import "GameLevelModel.h"
#import "WarningPopOverVC.h"
#import "InGameOptionVC.h"
#import "AppDelegate.h"
#import "EndGameDialogVC.h"
#import "GameDatabaseAccess.h"
#import "UserDataFetcher.h"
#import "HelpPopOverVC.h"
#import "FBConnector.h"

@interface NormalGameVC: UIViewController <TileMapDelegate, WarningPopOverDelegate, InGameOptionDelegate, HelpPopOverDelegate, EndGameDialogDelegate>

// Game level model
@property (strong, nonatomic) IBOutlet GameLevelModel *model;

//UIOutlets
@property (weak, nonatomic) IBOutlet UIScrollView *gameArea;
@property (weak, nonatomic) IBOutlet UIView *mask;
@property (weak, nonatomic) IBOutlet UIView *icon;
//topleft
@property (weak, nonatomic) IBOutlet UIButton *multiStateButton;
@property (weak, nonatomic) IBOutlet UIImageView *pointer;
@property (weak, nonatomic) IBOutlet UILabel *lifeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinLabel;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *comboButton;

//btm
@property (weak, nonatomic) IBOutlet UIImageView *sphere1;
@property (readonly, nonatomic, weak) ETDTower *sel1;
@property (weak, nonatomic) IBOutlet UIImageView *sphere2;
@property (readonly, nonatomic, weak) ETDTower *sel2;
@property (readonly, nonatomic) int selection;

@property (weak, nonatomic) IBOutlet UILabel *DmgLabel;
@property (weak, nonatomic) IBOutlet UILabel *DmgNum;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *upgradeCostLabel;
@property (weak, nonatomic) IBOutlet UIButton *invokeButton;
@property (weak, nonatomic) IBOutlet UIView *CDMask;
@property (nonatomic, readonly, weak) ETDTower *observedTower;

//dialog
@property (nonatomic, strong, readonly) ETDDialog *dialog;

@property (nonatomic, readonly, strong) TileMapViewController *tileMap;
@property (nonatomic, readonly) BOOL isFirstWave;

// ingame options
@property (nonatomic, strong) InGameOptionVC *optionView;

//endgame dialog
@property (nonatomic, strong) EndGameDialogVC *endGameView;


- (IBAction)multiStateButtonPressed:(UIButton *)sender;
- (IBAction)homeButtonPressed:(UIButton *)sender;
- (IBAction)invokeButtonPressed:(UIButton *)sender;

- (IBAction)comboButtonPressed:(UIButton *)sender;
- (IBAction)clearButtonPressed:(UIButton *)sender;

- (void)showIntroductionDialog;
- (void)showInGameOptionsView;
- (void)levelCleared;
- (void)levelFail;
- (void)requireUserLoginFB;


- (void)startGame;
- (void)clearElementSelection;
- (void)setButtonStateNext;

// Help
- (IBAction)helpButtonPressed:(UIButton *)sender;
- (void)showHelp;

- (void)clearInfoPane;
@end
