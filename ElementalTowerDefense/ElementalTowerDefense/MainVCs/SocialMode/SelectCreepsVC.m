#import "SelectCreepsVC.h"
#import "ArrangeCreepsOrderVC.h"
#import "UserDataFetcher.h"
#import "SocialModeGameVC.h"
#import "CreepToSelect.h"
#define CREEP1COST 100
#define CREEP2COST 200
#define CREEPWIDTH 200
#define CREEPHEIGHT 225
#define FIRSTCREEP_POSITION_X 7
#define FIRSTCREEP_POSITION_Y 20
#define HORIZONTAL_DISTANCE 2
#define VERTICAL_DISTANCE 8

@implementation SelectCreepsVC

@synthesize creditLabel;
@synthesize scrollViewContent;
@synthesize creepPlaceHoldingPlane;
@synthesize credit = _credit;
@synthesize selectedUserId;
@synthesize creepsToSelect;
@synthesize creepInfo;
@synthesize friendMapInfo;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight 
    || interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

- (void)setCredit:(int)credit{
    _credit = credit;
    self.creditLabel.text = [NSString stringWithFormat:@"%d",_credit];
}

- (int) credit{
    return _credit;
}

- (IBAction)backButtonPressed:(id)sender 
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Seques

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"SegueToCreepArrange"]) {
        ArrangeCreepsOrderVC *dest = (ArrangeCreepsOrderVC*) segue.destinationViewController;
        dest.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        NSMutableArray *temp = [[NSMutableArray alloc] init];
		//load temp, which is the sequence
        for (CreepToSelect *cts in creepsToSelect) {
            for(int i = 0 ; i < cts.creepCount ; i ++){
                [temp addObject:[NSNumber numberWithInt:cts.creepId]];
            }
        }
        
        dest.selectedUserId = selectedUserId;
        dest.sequence = temp;
        dest.creepInfo = self.creepInfo;
	}
    if ([segue.identifier isEqualToString:@"SegueToPreview"]) {
        SocialModeGameVC *dest = (SocialModeGameVC*)segue.destinationViewController;
        dest.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        dest.friendMapInfo = self.friendMapInfo;
        dest.isInPreviewMode = YES;
	}
}

#pragma mark - CreepSelect Delegate
- (BOOL) tryAddingCreep: (CreepToSelect*)sender{
    if(sender.creepCost <= self.credit)
    {
        self.credit -= sender.creepCost;
        sender.creepCount++;
        return TRUE;
    }
    else
        return FALSE;
}

- (BOOL) tryRemovingCreep: (CreepToSelect*)sender{
    if(sender.creepCount > 0)
    {
        self.credit += sender.creepCost;
        sender.creepCount--;
        return TRUE;
    }
    else
        return FALSE;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"ScrollView Test";
    self.creepPlaceHoldingPlane.contentSize = CGSizeMake(2048, 541);
    self.creepsToSelect = [[NSMutableArray alloc]init];
    self.friendMapInfo = [UserDataFetcher fetchMapWithUserId:self.selectedUserId];
    //selected User Id -- > UserMapInfo --> mapID--> MapInfo-->creepwaveFileName
    
    NSString *levelId = [self.friendMapInfo objectForKey:SOCIAL_MODE_STAGE];
    GameLevelModel *model = [[[GameDatabaseAccess alloc] init] getLevelModelWithId:[levelId intValue]];
    // model.fileName ---> XXXlevel.plist
     
    // load level from file
     NSLog(@"levelId:%@!!!",levelId);
    NSLog(@"model.fileName:%@!!!",model.fileName);
    NSString *bundleForLevel = [[NSBundle mainBundle] pathForResource:model.fileName ofType:@"plist"]; 
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:bundleForLevel];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSDictionary *mapInfo = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
     if (!mapInfo)
    NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    
    self.credit = [[mapInfo objectForKey:SOCIAL_MODE_CREDIT] intValue];
    NSLog(@"%d!!",self.credit);
    // load creep from file 
    NSString* creepWaveFileName = [mapInfo objectForKey:@"creepWaveFileName"];
    NSLog(@"creepWaveFileName:%@!!!",creepWaveFileName);
    NSString *bundleForCreep = [[NSBundle mainBundle] pathForResource:creepWaveFileName ofType:@"plist"]; 
    plistXML = [[NSFileManager defaultManager] contentsAtPath:bundleForCreep];
    errorDesc = nil;
  
    NSDictionary *wavesInfo = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
    if (!wavesInfo)
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    NSString *key = [NSString stringWithFormat:@"%d",[wavesInfo count]-1];
    NSDictionary *waveInfo = [wavesInfo valueForKey:key];
    self.creepInfo = [waveInfo valueForKey:@"creepInfo"];
    int numOfCreeps = [creepInfo count];
    for(int i = 1 ; i <= numOfCreeps ; i ++){
        NSString *creepId = [NSString stringWithFormat:@"%d",i];
        UIImage *img = [UIImage imageNamed:[[creepInfo objectForKey:creepId] objectForKey:@"normalImageName"]];
        NSNumber *creepCost = [[creepInfo objectForKey:creepId] objectForKey:@"hp"];
        // load creep cost ... later implementation
        CreepToSelect *temp = [[CreepToSelect alloc] initWithCreepId:i creepImage:img creepCost:[creepCost intValue] delegate:self];
        [self.creepsToSelect addObject:temp];
        if(i >= 1 && i <=5)
        {
            temp.view.frame = CGRectMake(FIRSTCREEP_POSITION_X +(i-1)*(CREEPWIDTH + HORIZONTAL_DISTANCE),FIRSTCREEP_POSITION_Y,CREEPWIDTH,CREEPHEIGHT);
            [self.scrollViewContent addSubview:temp.view];
        } else if (i >= 6 && i <= 10){
            temp.view.frame = CGRectMake(FIRSTCREEP_POSITION_X +(i-1)*(CREEPWIDTH + HORIZONTAL_DISTANCE),FIRSTCREEP_POSITION_Y + VERTICAL_DISTANCE + CREEPHEIGHT,CREEPWIDTH,CREEPHEIGHT);
            [self.scrollViewContent addSubview:temp.view];
        } else if (i >=11 && i <= 15){
             temp.view.frame = CGRectMake(FIRSTCREEP_POSITION_X +(i- 1 - 5)*(CREEPWIDTH + HORIZONTAL_DISTANCE),FIRSTCREEP_POSITION_Y,CREEPWIDTH,CREEPHEIGHT);
            [self.scrollViewContent addSubview:temp.view];
        } else if (i >=16 && i <= 20){
             temp.view.frame = CGRectMake(FIRSTCREEP_POSITION_X +(i- 1 - 5 - 5)*(CREEPWIDTH + HORIZONTAL_DISTANCE),FIRSTCREEP_POSITION_Y + VERTICAL_DISTANCE + CREEPHEIGHT,CREEPWIDTH,CREEPHEIGHT);
            [self.scrollViewContent addSubview:temp.view];
        }
    }
    
    
    [self.creepPlaceHoldingPlane flashScrollIndicators];
    self.scrollViewContent.backgroundColor = [UIColor clearColor];
   
}


- (void)viewDidUnload
{
    [self setCreepPlaceHoldingPlane:nil];
    [self setScrollViewContent:nil];
    [self setCreditLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
