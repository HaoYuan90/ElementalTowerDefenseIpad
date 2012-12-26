#import "TileMapViewController.h"

@implementation TileMapViewController

#define projSizeRatio 0.4;

@synthesize mapName;
@synthesize width;
@synthesize height;
@synthesize numRows;
@synthesize numCols;
@synthesize wayPoints;
@synthesize canBuild;
@synthesize tileWidth;
@synthesize tileHeight;
@synthesize selectionPanel;
@synthesize selectionPanelOn;
@synthesize towerButtons;
@synthesize engine;
@synthesize totalCoins;
@synthesize totalLife;
@synthesize levelLock;
@synthesize totalEscapedCreeps;
@synthesize delegate;
@synthesize shouldPlaceOnNextTap;
@synthesize isInSocialGame;

@synthesize listWindTowers;
@synthesize shouldChooseNewPositionForEarthTower;
@synthesize earthTowerToChangePosition;

- (void)testSetUpTower
{
    //TEST METHOD
    
    //set up tower as shown below
    ETDTower *temp = [[ETDJadeTower alloc] initWithDelegate:self withLevel:1];
    [self addTowerOnMap:temp At:17];
    //end of setting up a tower
    temp = [[ETDJadeTower alloc] initWithDelegate:self withLevel:1];
    [self addTowerOnMap:temp At:57];
}


// This method load basic map setting from a file with fileName. Return information as Dictionary
- (NSDictionary*)loadBasicMapSettingsFromFile:(NSString*)fileName
{
    //Requires: fileName MUST NOT HAVE postfix @".plist"
    //Effect: initialise map of a level according to data in the corresponding file
    //returns mapInfo dictionary for callers to do additional set-ups
    //load data from file
    NSString *bundle = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]; 
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:bundle];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSDictionary *mapInfo = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!mapInfo)
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    
    //load keys into properties
    mapName = [mapInfo objectForKey:@"mapName"];
    width = [[mapInfo objectForKey:@"width"] doubleValue];
    height = [[mapInfo objectForKey:@"height"] doubleValue];
    numRows = [[mapInfo objectForKey:@"numRows"] intValue];
    numCols = [[mapInfo objectForKey:@"numColumns"] intValue];
    tileWidth = width/numCols;
    tileHeight = height/numRows;
    
    wayPoints = [mapInfo objectForKey:@"wayPoints"];
    
    canBuild = [NSMutableArray array];
    for(int i=0;i<numRows*numCols;i++)
        [canBuild addObject:[NSNumber numberWithBool:YES]];
    //grids on path cannot be built upon
    NSArray *obstacles = [mapInfo objectForKey:@"obstacles"];
    for (NSNumber *temp in obstacles){
        int index = [temp intValue] -1;
        [canBuild replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:NO]];
    }
    //add edges of the map to obstacles, disallow building on the edges of the map
    for (int i=0; i<numCols;i++){
        [canBuild replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        [canBuild replaceObjectAtIndex:i+(numRows-1)*numCols withObject:[NSNumber numberWithBool:NO]];
    }
    for (int i=0; i<numRows*numCols;i += numCols){
        [canBuild replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        [canBuild replaceObjectAtIndex:i+(numCols-1) withObject:[NSNumber numberWithBool:NO]];
    }
    //test if canbuild is correct 
    /*
     for (int i=0;i<canBuild.count;i++)
     if(![[canBuild objectAtIndex:i] boolValue])
     [self testTileInfo:i+1];*/
    
    //init other states
    selectionPanel = nil;
    selectionPanelOn = NO;
    shouldPlaceOnNextTap = nil;
    
    levelLock = [[mapInfo objectForKey:levelLockTag] intValue];
    
    return mapInfo;
}


// This method initialize a social mode game from a file and a creep sequence
- (id)initSocialModeFromFile:(NSString *)fileName withCreepSequence:(NSArray*)creepSequence
{
    //init social game, creep sequence will not be loaded from creep wave file anymore
    //currently only last wave is in use. 
    self = [super init];
    if (self == nil) {
        NSLog(@"malloc error loading map");
        return nil;
    }
    isInSocialGame = YES;
    
    NSDictionary *mapInfo = [self loadBasicMapSettingsFromFile:fileName];
    totalCoins = 0;
    totalLife = 0;
    totalEscapedCreeps = 0;
    
    NSString* creepWaveFileName = [mapInfo objectForKey:@"creepWaveFileName"];
    NSArray* creepWaves = [ETDWave loadCustomCreepWaveFromFile:creepWaveFileName 
                                                 withSequence:creepSequence withDelegate:self];

    engine = [[ETDGameEngine alloc] initWithWaves:creepWaves andDelegate:self];
    
    return self;
}

// This method initialize a normal game from a file and starting coins + starting life and set its delegate
- (id)initNormalGameFromFile:(NSString *)fileName withDelegate:(id<TileMapDelegate>)del totalCoins:(int)coins totalLife:(int)life
{
    //Requires: fileName MUST NOT HAVE postfix @".plist"
    //Effect: initialise map of a level according to data in the corresponding file
    self = [super init];
    if (self == nil) {
        NSLog(@"malloc error loading map");
        return nil;
    }
    delegate = del;
    isInSocialGame = NO;
    
    NSDictionary *mapInfo = [self loadBasicMapSettingsFromFile:fileName];
    
    NSString* creepWaveFileName = [mapInfo objectForKey:@"creepWaveFileName"];
    NSArray* creepWaves = [ETDWave loadCreepWavesFromFile:creepWaveFileName withDelegate:self];
    
    engine = [[ETDGameEngine alloc] initWithWaves:creepWaves andDelegate:self];
    
    totalCoins = coins;
    totalLife = life;
    
    [delegate setInitLife:totalLife andCoin:totalCoins];
    
    listWindTowers = [NSMutableArray arrayWithCapacity:0];
	
    return self;
}
	
// TEST METHOD
- (id)initTestInterfaceFromFile:(NSString *)fileName
{
    self = [self initNormalGameFromFile:fileName withDelegate:nil totalCoins:10000 totalLife:10000];
    [self testSetUpTower];
    return self;
}

// Set up towers for social game with information comes from a dictionary
- (void)setUpTowersWithDictionary:(NSDictionary*)friendMapInfo
{
    //load towers stored in server
    CGPoint pos;
    ETDTower *temp;
    int positionId;
    // [a,b,c] a--> tower ID, b --> tower Level ,c--> position Id
    for (int i = 0; i< [[friendMapInfo objectForKey:SOCIAL_MODE_TOWERS] count]; i++) {
        positionId = [[[[friendMapInfo objectForKey:SOCIAL_MODE_TOWERS] objectAtIndex:i] objectAtIndex:2] intValue];
        pos = [self centerOfTile:positionId];
        switch ([[[[friendMapInfo objectForKey:SOCIAL_MODE_TOWERS] objectAtIndex:i] objectAtIndex:0] intValue]) {
				//kFire, kWater, kWood, kEarth, kMetal 1,2,3,
            case 1:
                temp = [[ETDFireTower alloc] initWithDelegate:self withLevel:1];
                break;
            case 2:
                temp = [[ETDWaterTower alloc] initWithDelegate:self withLevel:1];
                break;
            case 3:
                temp = [[ETDWoodTower alloc] initWithDelegate:self withLevel:1];
                break;
            case 4:
                temp = [[ETDEarthTower alloc] initWithDelegate:self withLevel:1];
                break;
            default:
                temp = [[ETDMetalTower alloc] initWithDelegate:self withLevel:1];
                
                break;
				
        }
        [self addTowerOnMap:temp At:positionId];
    }
}

// Initialize social mode game with map information + creep sequence + its delegate
- (id)initSocialModeWithMapInfo:(NSDictionary *)dic CreepSequence:(NSArray *)seq Delegate:(id<TileMapDelegate>)del
{
    //dic containing mapId, wave number, and tower info
    // test level should later change to mapId
    NSString *levelId = [dic objectForKey:SOCIAL_MODE_STAGE];
    GameLevelModel *model = [[[GameDatabaseAccess alloc] init] getLevelModelWithId:[levelId intValue]];
    self = [self initSocialModeFromFile:model.fileName withCreepSequence:seq];
 //   self = [self initSocialModeFromFile:@"testLevel" withCreepSequence:seq];
   
    delegate = del;
    [self setUpTowersWithDictionary:dic];
    return self;
}

- (BOOL) canBuildOnTile:(int)tileNumber
{
    //Effect: return YES if you can build on that tile
    return [[canBuild objectAtIndex:tileNumber-1] boolValue];
}

// Return a CGPoint which is the origin of a specific tile
- (CGPoint) originOfTile:(int)tileNumber
{
    int row = (tileNumber-1)/numCols;
    int col = (tileNumber-1)%numCols;
    return CGPointMake(col*tileWidth,row*tileHeight);
}

// Return a CGPoint which is the cetnter of a specific tile
- (CGPoint) centerOfTile:(int)tileNumber
{
    CGPoint temp = [self originOfTile:tileNumber];
    return CGPointMake(temp.x+tileWidth/2, temp.y+tileHeight/2);
}

// Return the tile number that contains a specific point
- (int)tileNumberOfPoint:(CGPoint)point
{
    int x=point.x,y= point.y;
    int row=0, col=0;
    while (x>0){
        x-=tileWidth;
        col++;
    }
    while (y>0){
        y-=tileHeight;
        row++;
    }
    return (row-1)*numCols+col;
}

// Add coins to the total amount of coins and display the respective change in UI needed
- (void)addCoins:(int)numOfCoins atPosition:(CGPoint)pos
{
    totalCoins += numOfCoins;
	[self.view.superview addSubview:[[CoinTag alloc] initWithAmt:numOfCoins andPosition:pos]];
    [delegate didChangeCoin:totalCoins];
    /*
    UIViewController* temp = (UIViewController*)delegate;
    [temp performSelectorOnMainThread:@selector(didChangeCoin:) withObject:[NSNumber numberWithInt:totalCoins] waitUntilDone:false];*/
}

// Add a new tower on map
- (void) addTowerOnMap:(ETDTower *)tower At:(int)tileNumber
{
    if (tower != nil){
		// Handle wind tower
		if ([tower isKindOfClass:[ETDWindTower class]]) {
			[listWindTowers addObject:tower];
			ETDWindTower *wt = (ETDWindTower *)tower;
			for (ETDTower *t in engine.towers) {
				if ([wt isPositionInsideWindAura:t.position]) {
					[t addWindAuraEffect];
				}
			}
		}
		// end
        CGPoint origin = [self originOfTile:tileNumber];
        tower.position = [self centerOfTile:tileNumber];
        tower.view.frame = CGRectMake(origin.x, origin.y, tileWidth, tileHeight);
        [canBuild replaceObjectAtIndex:tileNumber-1 withObject:[NSNumber numberWithBool:NO]];
        [engine addObjectToGameLogic:tower];
        [self.view addSubview:tower.view];
		for (ETDWindTower *wt in listWindTowers) {
			if ([wt isPositionInsideWindAura:tower.position]) {
				[tower addWindAuraEffect];
			}
		}
        
        //put level cap
        if (levelLock != 0)
            tower.maxLevel = levelLock;
    }
}

// Remove a tower from map
- (void)removeTower:(ETDTower*)tower
{
    if (tower != nil){
		// Handle wind tower
		if ([tower isKindOfClass:[ETDWindTower class]]) {
			[listWindTowers removeObject:tower];
			ETDWindTower *wt = (ETDWindTower *)tower;
			for (ETDTower *t in engine.towers) {
				if ([wt isPositionInsideWindAura:t.position]) {
					[t removeWindAuraEffect];
				}
			}
		}
		// end
        [tower.view removeFromSuperview];
        int index = [self tileNumberOfPoint:tower.position]-1;
        [canBuild replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:YES]];
        [engine removeFromGameLogic:tower];
    }
}

// This is to mark that next tap will place a specific tower to the map
- (void)shouldPlaceTowerOnNextTap:(ETDTower*)tower
{
    shouldPlaceOnNextTap = tower;
}

// Add buff to creeps at some position
- (void)addBuffsToCreep:(ETDBuff *)buff position:(CGPoint)p {
    
    // add animation...
    [engine addBuffsToCreep:buff position:p];
}

- (void)pauseGame
{
    [engine pause];
}

- (void)resumeGame
{
    [engine resume];
}

// Test method
- (void) testTileInfo:(int)tileNumber
{
    //Testing method
    /*
    CGPoint origin = [self originOfTile:tileNumber];
    UIView *originPt = [[UIView alloc] initWithFrame:CGRectMake(origin.x-5, origin.y-5, 10, 10)];
    originPt.backgroundColor = [UIColor redColor];
    [self.view addSubview:originPt];*/

    CGPoint center = [self centerOfTile:tileNumber];
    UIView *centerPt = [[UIView alloc] initWithFrame:CGRectMake(center.x-5, center.y-5, 10, 10)];
    centerPt.backgroundColor = [UIColor blackColor];
    [self.view addSubview:centerPt];
    
    /*
    if ([self canBuildOnTile:tileNumber])
        NSLog(@"can build");
    else
        NSLog(@"cannot build");*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - EngineDelegate Methods

// Handle a wave has finished
-(void)didFinishCurrentWave
{
    [delegate didFinishCurrentWave:(double)engine.currentWave/engine.waves.count];
    if(engine.currentWave == engine.waves.count) {
        NSLog(@"wavecount %d, currentwave %d", engine.currentWave, engine.waves.count);
        [engine removeFromRunLoop];
        [delegate didFinishGame];
    }
}

#pragma mark - ProjectileDelegate Methods

// destroy a projectile from game
-(void)destructProjectile:(ETDProjectile*)proj
{
    [engine removeFromGameLogic:proj];
    [proj.view removeFromSuperview];
}

// Show the critical tags when a critical strike happens
-(void)didScoreCritAt:(CGPoint)position dmg:(double)damage
{
    [self.view.superview addSubview:[[CritTag alloc] initWithDmg:damage andPosition:position]];
}

// Perform special ability for fire projectile -> deal fire damage to a specific area
- (void)dealFireDamage:(double)damage toAreaDefinedByCenter:(CGPoint)center andRadius:(double)radius {
	[engine dealFireDamage:damage toAreaDefinedByCenter:center andRadius:radius];
}

#pragma mark - TowerButtons control

// Destroy tower sell/upgrade buttons
-(void) destroyTowerButtons
{
    [towerButtons.view removeFromSuperview];
    towerButtons = nil;
}

#pragma mark - TowerDelegate Methods

-(CGFloat)getDataWRTMap:(CGFloat)data
{
    return data*tileWidth;
}

// Add new projectile to game
-(void)addProjectileToGame:(ETDProjectile*) proj
{
    CGFloat projWidth = tileWidth*projSizeRatio;
    CGFloat projHeight = tileWidth*projSizeRatio;
    proj.view.frame = CGRectMake(proj.position.x-projWidth/2, proj.position.y-projHeight/2,projWidth,projHeight);
    [engine addObjectToGameLogic:proj];
    [self.view addSubview:proj.view];
}

// Handle when player touch a tower
-(void)didSelectTower:(ETDTower*)tower
{
	if (shouldChooseNewPositionForEarthTower) {
#warning earth tower invalid position
		DLog(@"Invalid Position - Cannot place Earth Tower");
		return;
	}
    [self destroyTowerButtons];
    
    if(!isInSocialGame){
        towerButtons = [[TowerButtonsVC alloc] initWithTower:tower andDelegate:self];
        [self.view.superview addSubview:towerButtons.view];
    }
    
    [delegate handleTowerSelection:tower];
    
	if (selectionPanelOn) {
		[self destroySelectionPanel];
	}
}

// Check whether player can upgrade tower or not
- (BOOL)canUpgradeTower:(ETDTower *)tower {
	if (totalCoins >= tower.upgradeCost )
        return YES;
    else {
        [delegate showWarningOfType:notEnoughCoinsWarning];
        return NO;
    }
}

// Update the changes in UI after upgrading a towre
- (void)didUpgradeTower:(ETDTower *)tower {
	totalCoins -= tower.upgradeCost;
	DLog(@"%d %d", totalCoins, tower.upgradeCost);
	[delegate didChangeCoin:totalCoins];
}

// Sell a specific tower from map
- (void)soldTower:(ETDTower *)tower 
{
	[self addCoins:tower.sellingValue atPosition:tower.position];
	[self removeTower:tower];
}

// Choose new position for the Earth Tower as its special ability is invoked
- (void)chooseNewPositionForEarthTower:(ETDEarthTower *)tower {
	shouldChooseNewPositionForEarthTower = YES;
	earthTowerToChangePosition = tower;
}

// Select target for split attacks - Wood tower special ability
-(NSArray*)selectTargetsForSplitAttack:(CGPoint)pos :(CGFloat)range :(int)numOfTargets :(NSMutableArray *)exclusion
{
    return [engine selectTargetsForSplitAttack:pos :range :numOfTargets :exclusion];
}

// Freeze creeps inside a specific area - Ice tower special ability
- (void)freezeCreepsInsideAreaDefinedByCenter:(CGPoint)cen andRadius:(double)rad andDuration:(double)dur{
	NSArray *creepsBeingFreezed = [engine getCreepsInsideAreaDefinedByCenter:(CGPoint)cen andRadius:(double)rad];
	for (ETDCreep *creep in creepsBeingFreezed) {
		ETDBuff *freezeBuff = [[ETDBuff alloc] initWithType:kFreeze duration:dur radius:0 factor:0];
		[creep addBuff:freezeBuff];
		[creep addMaskToCreep:kFreezing inDuration:1];
	}
}

// Method to support Wood tower split attacks
- (ETDCreep *)getNearestCreepToPosition:(CGPoint)pos excludeCreeps:(NSArray *)targets{
	return [engine getNearestCreepToPosition:pos excludeCreeps:targets];
}

#pragma mark - CreepDelegate Methods

// Return the the position of a specific waypoint
- (CGPoint) waypoingPosition:(int)waypointNumber
{
    return [self centerOfTile:[[wayPoints objectAtIndex:waypointNumber] intValue]];
}

// Check if the creeps should exit the field after reaching the waypoint or not
// If YES -> update needed information 
- (BOOL) shouldExit:(int)waypointNumber
{
    //check if creep reach the last waypoint/exit of map
    if (waypointNumber < [wayPoints count]) {
        return NO;
    }
    else {
        totalLife --;
        totalEscapedCreeps ++;
        [delegate didChangeLifeLeft:totalLife];
        if (totalLife == 0){
            [engine removeFromRunLoop];
            [delegate didLostGame];
        }
        return YES;
    }
}

// Remove creep from game
-(void) removeCreep:(id)creep
{
	ETDCreep *creepToRemove = (ETDCreep *)creep;
	if (creepToRemove.isTargetCreep) {	
		engine.targetCreep = nil;
	}
    [engine removeFromGameLogic:creep];
}

// Add creep to grame
- (void) addNewCreepOnMap:(ETDCreep *)creep
{
    int tileNumber = [[wayPoints objectAtIndex: creep.currentPositionIndicator] intValue];
    CGPoint origin = [self originOfTile:tileNumber];
    creep.view.frame = CGRectMake(origin.x, origin.y, tileWidth, tileHeight);
    [engine addObjectToGameLogic:creep];
    [self.view addSubview:creep.view];
}

// Display arrow tag for buff when the creep receive some buff
-(void) shouldDisplayArrowTagForBuff:(arrowTagType)type :(arrowTagState)state At:(CGPoint)position
{
    [self.view.superview addSubview:[[ArrowTag alloc] initWithType:type andState:state at:position]];
}

// Make a specific creep target creep -> force tower to try to attack it first before attempting other creeps
- (void)targetCreep:(ETDCreep *)creep {
    if(!isInSocialGame){
        // If creep is target creep -> make it not target creep anymore.
        if (creep.isTargetCreep) {
            creep.isTargetCreep = NO;
            [creep hideTargetArrow];
            return;
        }
        // Check if engine has already logged another creep as target creep.
        if (engine.targetCreep) {
            engine.targetCreep.isTargetCreep = NO;
            [engine.targetCreep hideTargetArrow];
        }
        [creep.view.superview bringSubviewToFront:creep.view];
        [creep showTargetArrow];
        engine.targetCreep = creep;
        creep.isTargetCreep = YES;
    }
}

#pragma mark - SelectionPanel control

// Handle seletion on selection panel
-(void) didSelect:(TowerType)choice At:(int)tileNumber
{
    ETDTower *temp = [ETDTowerFactory createNewTowerOfType:choice withDelegate:self];
    [self destroySelectionPanel];
	if (totalCoins >= temp.towerValue) {
		[self addTowerOnMap:temp At:tileNumber];
		totalCoins -= temp.towerValue;
		[delegate didChangeCoin:totalCoins];
	}
    else {
        [delegate showWarningOfType:notEnoughCoinsWarning];
    }
}

// Destroy selection panel
-(void) destroySelectionPanel
{
    [selectionPanel.view removeFromSuperview];
    selectionPanel = nil;
    selectionPanelOn = NO;
}

#pragma mark - Single Touch Gesture Handling

// Handle single tap in game
-(void)singleTap:(UITapGestureRecognizer *)gesture
{
    //if in social mode, touch gesture on tile map should not function
    if (!isInSocialGame) {
        
        //Effect: handle user tapping on screen
        //determine tileNumber of clicking
        int tileNumber = [self tileNumberOfPoint: [gesture locationInView:self.view]];
        
        [self destroyTowerButtons];
        
        if(shouldPlaceOnNextTap == nil){
            if (shouldChooseNewPositionForEarthTower && [self canBuildOnTile:tileNumber]) {
//                [self removeTower:earthTowerToChangePosition];
//                ETDTower *temp = [ETDTowerFactory createNewTowerOfType:kEarthTower withDelegate:self withLevel:earthTowerToChangePosition.level];
//                earthTowerToChangePosition = nil;
//                [self addTowerOnMap:temp At:tileNumber];
//                [delegate handleTowerSelection:temp];
                int prevTile = [self tileNumberOfPoint: earthTowerToChangePosition.position];
                [canBuild replaceObjectAtIndex:prevTile-1 withObject:[NSNumber numberWithBool:YES]];
                [canBuild replaceObjectAtIndex:tileNumber-1 withObject:[NSNumber numberWithBool:NO]];
				CGPoint origin = [self originOfTile:tileNumber];
				earthTowerToChangePosition.position = [self centerOfTile:tileNumber];
				earthTowerToChangePosition.view.frame = CGRectMake(origin.x, origin.y, tileWidth, tileHeight);
                shouldChooseNewPositionForEarthTower = NO;
                return;
            }
            
            if(!selectionPanelOn && [self canBuildOnTile:tileNumber])
            {
                selectionPanel = [[BuildSelectionViewController alloc]
                                  initWithCenter:[self centerOfTile:tileNumber] tileNumber:tileNumber Delegate:self];
                [self.view.superview addSubview:selectionPanel.view];
                selectionPanelOn = YES;
            }
            else if(selectionPanelOn)
                [self destroySelectionPanel];
            else{
            }
        }
        else{
            if([self canBuildOnTile:tileNumber]){
                [self addTowerOnMap:shouldPlaceOnNextTap At:tileNumber];
                shouldPlaceOnNextTap = nil;
                [delegate didPlaceComboTower];
            }
            else {
                //show warning this grid cannot be built upon
            }
        }
        /*
         [self testTileInfo:tileNumber];
         NSLog(@"%d",tileNumber);*/
    }
}

#pragma mark - View lifecycle

- (void)loadView
{
    UIImage *mapImage = [UIImage imageNamed:mapName];
    UIImageView *map = [[UIImageView alloc] initWithImage:mapImage];
    [map setUserInteractionEnabled:YES];
    map.frame = CGRectMake(0, 0, width, height);
    self.view = map;
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
