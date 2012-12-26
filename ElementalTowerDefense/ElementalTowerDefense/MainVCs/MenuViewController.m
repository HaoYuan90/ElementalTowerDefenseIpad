#import "MenuViewController.h"
@implementation MenuViewController

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue.destinationViewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
           interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

@end
