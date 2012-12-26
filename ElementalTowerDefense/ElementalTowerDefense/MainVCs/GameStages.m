#import "GameStages.h"
#import "ListLevels.h"

@interface GameStages ()

@end

@implementation GameStages
@synthesize fire;
@synthesize selectedStage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedStage = 0;
    [fire addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapFire:)]];
}

- (void)viewDidUnload {
    [self setFire:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapFire:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        selectedStage = 1;
        [self performSegueWithIdentifier:@"StageToLevels" sender:self];
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // add the information for the GameLevelMenueViewController before transition
    if([segue.identifier isEqualToString:@"StageToLevels"]) {
        ListLevels *dest = (ListLevels*)segue.destinationViewController;
        dest.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        dest.stageId = selectedStage;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
