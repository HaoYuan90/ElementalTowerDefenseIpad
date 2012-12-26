#import <UIKit/UIKit.h>
#import "BuildSelectionDelegate.h"
#import "TileMapDelegate.h"
#import "ETDCreepDelegate.h"
#import "ETDTowerDelegate.h"
#import "ETDProjectileDelegate.h"
#import "ETDGameEngineDelegate.h"
#import "ETDTowerFactory.h"
#import "BuildSelectionViewController.h"
#import "ETDGameEngine.h"
#import "ETDWave.h"
#import "FlyingTags.h"
#import "ETDDialog.h"
#import "TowerButtonsVC.h"
#import "GameDatabaseAccess.h"

//module responsible for loading of map
//NOTE: tileNumber IS 1 based numbering instead of 0 based

@interface TileMapViewController: 
UIViewController<BuildSelectionDelegate,ETDCreepDelegate,ETDTowerDelegate,
ETDProjectileDelegate,ETDGameEngineDelegate, TowerButtonsDelegate>
//saved properties
@property (nonatomic, readonly, strong) NSString *mapName;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) int numRows;
@property (nonatomic, readonly) int numCols;
@property (nonatomic, readonly, strong) NSArray *wayPoints;
@property (nonatomic, readonly, strong) NSMutableArray *canBuild; //boolean array
//derived tile properties
@property (nonatomic, readonly) CGFloat tileWidth;
@property (nonatomic, readonly) CGFloat tileHeight;
//selectionPanel properties
@property (nonatomic, readonly, strong) BuildSelectionViewController *selectionPanel;
@property (nonatomic, readonly) BOOL selectionPanelOn;
//towrButtons properties
@property (nonatomic, readonly, strong) TowerButtonsVC* towerButtons;
//enginef
@property (nonatomic, readonly, strong) ETDGameEngine *engine;
//game conditions (coins, life)
@property (atomic, readonly) int totalCoins;
@property (nonatomic, readonly) int totalLife;
@property (nonatomic, readonly) int totalEscapedCreeps;
@property (nonatomic, readonly) int levelLock;
//delegate related variables
@property (nonatomic, readonly, weak) id<TileMapDelegate> delegate;
@property (nonatomic, readonly, strong) ETDTower *shouldPlaceOnNextTap;
@property (nonatomic, assign) BOOL shouldChooseNewPositionForEarthTower;
@property (nonatomic, strong) ETDEarthTower *earthTowerToChangePosition;
//social game control
@property (nonatomic, readonly) BOOL isInSocialGame;
//special towers
@property (nonatomic, strong) NSMutableArray *listWindTowers;

- (id)initTestInterfaceFromFile:(NSString *)fileName;
//initialise test interface
- (id)initNormalGameFromFile:(NSString *)fileName withDelegate:(id<TileMapDelegate>)del totalCoins:(int)coins totalLife:(int)life;
//initialise normal game
- (id)initSocialModeWithMapInfo:(NSDictionary*)dic CreepSequence:(NSArray*)seq Delegate:(id<TileMapDelegate>)del;
//initialise social game

//tile infos
- (CGPoint)centerOfTile:(int)tileNumber;
- (CGPoint)originOfTile:(int)tileNumber;
- (BOOL)canBuildOnTile:(int)tileNumber;
- (int)tileNumberOfPoint:(CGPoint)point;

//game related
- (void)addNewCreepOnMap:(ETDCreep*)creep;
- (void)addTowerOnMap:(ETDTower*)tower At:(int)tileNumber;
- (void)removeTower:(ETDTower*)tower;
- (void)shouldPlaceTowerOnNextTap:(ETDTower*)tower;
- (void)addBuffsToCreep:(ETDBuff *)buff position:(CGPoint)p;
- (void)addCoins:(int)numOfCoins atPosition:(CGPoint)pos;

//pause/resume
- (void)pauseGame;
- (void)resumeGame;

@end
