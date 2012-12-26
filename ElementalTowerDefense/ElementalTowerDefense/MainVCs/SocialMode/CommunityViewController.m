#import "CommunityViewController.h"
#import "UserDataFetcher.h"
#import "SocialModeGameVC.h"
#import "SelectCreepsVC.h"

#define FULL_SCREEN CGRectMake(0, 0, 1024, 768)
#define SCREEN_CENTER CGPointMake(512, 384)

#define requestingFriendsId 0
#define requestingFriendsInfo 1


@interface CommunityViewController()
//  storing fb callback results
@property (nonatomic, strong) NSMutableArray *savedAPIResult;
@property (nonatomic, strong) NSMutableDictionary *savedFriendName;
//  controls for loading button images
@property int currentPageNum;
@property int maxPageNum;
@property int currentApiCall;
@property BOOL netWorkAvailable;
@property (weak, nonatomic) NSString* selectedUserId;
//  loading spinner
@property (nonatomic, strong) UIActivityIndicatorView *progressIndicator;
@property (nonatomic, strong) UIView *splashScreen;
//  confirm button
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@end

@implementation CommunityViewController
@synthesize button1;
@synthesize button2;
@synthesize button3;
@synthesize button4;
@synthesize button5;
@synthesize button6;
@synthesize button7;
@synthesize button8;
@synthesize button9;
@synthesize button10;
@synthesize pageNumLabel;
@synthesize friendsInfoDisplay;
@synthesize maxPageNum;
@synthesize currentPageNum;
@synthesize progressIndicator;
@synthesize splashScreen;
@synthesize goButton;

@synthesize currentApiCall;
@synthesize savedAPIResult;
@synthesize savedFriendName;
@synthesize selectedUserId;
@synthesize netWorkAvailable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (UIImage *)imageForObject:(NSString *)objectID {
    //EFFECT: Get the object image for a userId
    NSString *url = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",objectID];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    return image;
}


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //EFFECT: resize the photo
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

- (void) loadButtonImage{
    //EFFECT: load buttons with friend image
    //        hide unnecessary buttons
    
    BOOL buttonImageUpdatingFinished = FALSE;
    UIImage* newButtonImage;
    // 1. loading button image using userId from savedAPIResult.
    // 2. when finished, hide the rest of buttons
    // 3. current page number decide what userIds are userd
    for(int i =1 ;i<= 10; i++){
        if(currentPageNum == maxPageNum && (currentPageNum-1)*10 + i > [savedAPIResult count] )
            buttonImageUpdatingFinished = TRUE;
        switch (i) {
            case 1:
                if(buttonImageUpdatingFinished)
                    button1.hidden = TRUE;
                else
                {
                    button1.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button1 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
            case 2:
                if(buttonImageUpdatingFinished)
                    button2.hidden = TRUE;
                else
                {
                    button2.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button2 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
            case 3:
                if(buttonImageUpdatingFinished)
                    button3.hidden = TRUE;
                else
                {
                    button3.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button3 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
            case 4:
                if(buttonImageUpdatingFinished)
                    button4.hidden = TRUE;
                else
                {
                    button4.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button4 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
            case 5:
                if(buttonImageUpdatingFinished)
                    button5.hidden = TRUE;
                else
                {
                    button5.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button5 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
            case 6:
                if(buttonImageUpdatingFinished)
                    button6.hidden = TRUE;
                else
                {
                    button6.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button6 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
            case 7:
                if(buttonImageUpdatingFinished)
                    button7.hidden = TRUE;
                else
                {
                    button7.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button7 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
            case 8:
                if(buttonImageUpdatingFinished)
                    button8.hidden = TRUE;
                else
                {
                    button8.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button8 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
            case 9:
                if(buttonImageUpdatingFinished)
                    button9.hidden = TRUE;
                else
                {
                    button9.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button9 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
            case 10:
                if(buttonImageUpdatingFinished)
                    button10.hidden = TRUE;
                else
                {
                    button10.hidden = FALSE;
                    newButtonImage = [self imageForObject:[savedAPIResult objectAtIndex:(i-1+(currentPageNum-1)*10)]];
                    [button10 setImage:newButtonImage forState:UIControlStateNormal];
                }
                break;
                
            default:
                break;
        }
    }
    
    
}

- (IBAction)backButtonPressed:(id)sender 
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendRequestForAppUser {
    //EFFECT: Retrieving fbID of friends who have also installed the game.
    //        Setting currentApiCall state as "requestingFriendsId"
    FBConnector* fb = [FBConnector sharedFaceBookConnector];
    self.currentApiCall = requestingFriendsId;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"friends.getAppUsers", @"method",nil];
    [fb.facebook requestWithParams:params andDelegate:self];
}

- (void)cancelSplashscreen {
    [self.splashScreen removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)tryLogin {
    //EFFECT: if session is valid --> get friends id
    //        if session is invalid --> login/app permission request if necessary
    
    //after login, fbDidLogin will get called and send notification, then-->get friends id
    FBConnector* fb = [FBConnector sharedFaceBookConnector];
    if (![fb login]) {
        NSLog(@"[ViewController] is authorizing via facebook");
      
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendRequestForAppUser) name:@"FBDidLogin" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelSplashscreen) name:@"FBLoginCancelled" object:nil];
    } else {
        //request for friendsId
        [self sendRequestForAppUser];
    }
   

}


- (IBAction)nextPageButtonClicked:(id)sender {
    //EFFECTs: update currentPageNum
    //         reload all the button images using updated currentPageNum
    if(savedAPIResult!=nil&& currentPageNum < maxPageNum)
    {
        currentPageNum++;
        pageNumLabel.text = [NSString stringWithFormat:@"%d", currentPageNum];
        [self loadButtonImage];
    }
}

- (IBAction)previousPageButtonClicked:(id)sender {
    //EFFECTs: update currentPageNum
    //         reload all the button images using updated currentPageNum
    if(savedAPIResult!=nil&& currentPageNum >1)
    {
        currentPageNum--;
        pageNumLabel.text = [NSString stringWithFormat:@"%d", currentPageNum];
        [self loadButtonImage];
    }
}

- (IBAction)imageButtonClicked:(id)sender {
    //EFFECT: retrieve backend data for the clicked friends
    //        display the info of clicked friends
    UIButton* buttonClicked =  (UIButton*)sender; 
    NSString *userInfo;
    
    // tag from 1 to 10, labelling 10 different buttons
    self.selectedUserId = [savedAPIResult objectAtIndex:(buttonClicked.tag-1+(currentPageNum-1)*10)];
    NSDictionary* dict = [UserDataFetcher fetchMapWithUserId:self.selectedUserId];
    if([dict objectForKey:SOCIAL_MODE_TOWERS] == [NSNull null])
        {
            userInfo = @"is still drilling. Pick another:D";
            self.goButton.enabled = NO;
        } else {
            userInfo = [NSString stringWithFormat:@" at Level %@.",[dict objectForKey:SOCIAL_MODE_STAGE]];
            self.goButton.enabled = YES;
        }
    // displaying name and level
    friendsInfoDisplay.text =[NSString stringWithFormat:@"%@ %@", [savedFriendName valueForKey:[savedAPIResult objectAtIndex:(buttonClicked.tag-1+(currentPageNum-1)*10)]],userInfo];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Seques

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
	if ([segue.identifier isEqualToString:@"SegueToCreepSelect"]) {
        SelectCreepsVC *dest = (SelectCreepsVC*) segue.destinationViewController;
        dest.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        dest.selectedUserId = selectedUserId;
	}
	
}

#pragma mark - Checking Connection availability

- (BOOL) connectedToInternet
{
  // quick and dirty
    NSError* error = nil;
    NSURL* url = [[NSURL alloc] initWithString:@"http://www.google.com"];
    NSString *URLString = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    return ( URLString != NULL ) ? YES : NO;
}



#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // spinner on a splashscreen
    self.progressIndicator = [[UIActivityIndicatorView alloc]init];
    self.progressIndicator.center = SCREEN_CENTER;
    [progressIndicator sizeToFit];
    self.progressIndicator.hidesWhenStopped = YES;
    progressIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    self.splashScreen = [[UIView alloc] initWithFrame:FULL_SCREEN];
    splashScreen.backgroundColor = [UIColor blackColor];
    [self.splashScreen addSubview:progressIndicator];
    [self.view addSubview:splashScreen];
    self.savedFriendName = [[NSMutableDictionary alloc] init];
    
    if ([self connectedToInternet]) {
        //yes we're connected
        //self.view.hidden = YES;
        self.netWorkAvailable = YES;
        [self.progressIndicator startAnimating];
        [self tryLogin];
    }
    else {
        //no we're not connected
        self.netWorkAvailable = NO;
        UIAlertView *invalidGameStartAlert = [[UIAlertView alloc] 
                                              initWithTitle:@"Cannot start game"
                                              message:@"Sorry, you have no network connection" 
                                              delegate:nil 
                                              cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [invalidGameStartAlert show];  
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!self.netWorkAvailable)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
} 

- (void)viewDidUnload
{
    [self setButton1:nil];
    [self setButton2:nil];
    [self setButton3:nil];
    [self setButton4:nil];
    [self setButton5:nil];
    [self setButton6:nil];
    [self setButton7:nil];
    [self setButton8:nil];
    [self setButton9:nil];
    [self setButton10:nil];
    [self setPageNumLabel:nil];
    [self setFriendsInfoDisplay:nil];
    [self setGoButton:nil];
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight 
    || interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

#pragma mark - Facebook delegate methods

- (void)request:(FBRequest *)request didLoad:(id)result 
{
   //EFFECTS: Handling the request callback for getting the friends id
   //         if the result is not empty, load the buttons with friends image
   //         save id of users using the app
    switch (self.currentApiCall) {
            //handleing quest for ID
        case requestingFriendsId:
        {
            if ([result isKindOfClass:[NSArray class]]) {
                savedAPIResult = [[NSMutableArray alloc] init];
                for (NSNumber *num in result) {
                    [savedAPIResult addObject:[num stringValue]];
                }                  
            } else  {
                //if ([result isKindOfClass:[NSDecimalNumber class]];
                savedAPIResult = [[NSMutableArray alloc] initWithObjects:[result stringValue], nil];
                
            }
            FBConnector *fb = [FBConnector sharedFaceBookConnector];
            for (int i = 0 ; i < [self.savedAPIResult count ] ; i ++) {
                [fb.facebook requestWithGraphPath:[self.savedAPIResult objectAtIndex:i] andDelegate:self];
            }
            self.currentApiCall = requestingFriendsInfo;
            maxPageNum = [savedAPIResult count]/10 +1;
            currentPageNum = 1;
            if ([savedAPIResult count] > 0) {
                [self loadButtonImage];
                pageNumLabel.text = [NSString stringWithFormat:@"%d", currentPageNum];
                self.selectedUserId = [savedAPIResult objectAtIndex:((currentPageNum-1)*10)];
                 self.goButton.enabled = NO;
                [self.progressIndicator stopAnimating];
                self.friendsInfoDisplay.text = @"Choose a friend to challenge!";
             
            } else {
                NSLog(@"?No results?");
                savedAPIResult = nil;
                UIAlertView *invalidGameStartAlert = [[UIAlertView alloc] 
                                                      initWithTitle:@"Cannot start game"
                                                      message:@"Sorry, you have no friends survived. They are all eaten by the creeps" 
                                                      delegate:nil 
                                                      cancelButtonTitle:@"Ok" 
                                                      otherButtonTitles:nil];
                [invalidGameStartAlert show];  
                [self dismissViewControllerAnimated:YES completion:nil];

                
            }

            break;
        }
            //handling request for friends info
        case requestingFriendsInfo:
        {
            if ([result isKindOfClass:[NSArray class]]) {
                result = [result objectAtIndex:0];
            }
            // When we ask for user infor this will happen.
            if ([result isKindOfClass:[NSDictionary class]]){
                //NSDictionary *hash = result;
                [self.savedFriendName setValue:[result objectForKey:@"name"] forKey:[result objectForKey:@"id"]];
                
            }
            if([self.savedFriendName count] == [self.savedAPIResult count])
            {
                [self.splashScreen removeFromSuperview];
                self.view.hidden = NO;
            }
            break;
            
        default:
            break;
        }
    }
}

#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
