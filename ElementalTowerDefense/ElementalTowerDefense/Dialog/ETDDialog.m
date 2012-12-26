#import "ETDDialog.h"

@implementation ETDDialog

#define dialogFrame CGRectMake(0,518,IPAD_LANDSCAPE_MAX_WIDTH,200)
#define portraitFrame CGRectMake(730,488,274,250)
#define masterPortraitImageName @"masterPortrait.PNG"
#define skipButtonImageName @"skipButton.png"

@synthesize transparentLayer;
@synthesize superView;
@synthesize dialog;
@synthesize dialogMessages;
@synthesize dialogContent;
@synthesize nextMessage;
@synthesize skipButton;

- (id)initWithSuperView:(UIView *)view {
    // EFFECTS: constructs a ETDDialog with a super view.
    
    self = [super init];
    if (self) {
        superView = view;
    }
    
    // dialog view
    dialog = [[UIView alloc] initWithFrame:dialogFrame];
    dialog.backgroundColor = [UIColor blackColor];
    dialog.alpha = 0.6;
    dialog.userInteractionEnabled = YES;
    
    // skip button
    UIImage *img = [UIImage imageNamed:skipButtonImageName];
    skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [skipButton setImage:img forState:UIControlStateNormal];
    [skipButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentFill];
    [skipButton setContentVerticalAlignment:UIControlContentVerticalAlignmentFill];
    skipButton.frame = CGRectMake(0, 0, 200, 40);
    
    
    // add content
    dialogContent = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, dialog.frame.size.width - 300, dialog.frame.size.height - 40)];
    dialogContent.backgroundColor = [UIColor clearColor];
    dialogContent.font = [UIFont boldSystemFontOfSize:30];
    dialogContent.textColor = [UIColor whiteColor];
    dialogContent.textAlignment = UITextAlignmentCenter;
    dialogContent.numberOfLines = 0;
    dialogContent.lineBreakMode = UILineBreakModeWordWrap;
    
    return self;
}

- (void)freezeScreen {
    
    if (self.view) {
        [self.view removeFromSuperview];
    }
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPAD_LANDSCAPE_MAX_WIDTH, IPAD_LANDSCAPE_MAX_HEIGHT+20)];
    self.view.userInteractionEnabled = YES;
    
    transparentLayer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, IPAD_LANDSCAPE_MAX_WIDTH, IPAD_LANDSCAPE_MAX_HEIGHT+20)];
    transparentLayer.backgroundColor = [UIColor blackColor];
    transparentLayer.alpha = 0.4;
    [self.view addSubview:transparentLayer];
    [superView addSubview:self.view];
}


- (void)showDialogs:(NSArray *)contents {
    // EFFECTS: shows the dialog on the view with the contents.
    
    dialogMessages = contents;
    
    // prevent users to touch out side of the dialog.
    [self freezeScreen];
    
    // remove the subviews in dialog view.
    for (int i = 0; i < [[dialog subviews] count]; i++ ) {
        [[[dialog subviews] objectAtIndex:i] removeFromSuperview];
    }
    
    // add content subview.
    dialogContent.text = [dialogMessages objectAtIndex:0];
    [dialog addSubview:dialogContent];
    
    nextMessage = 1;
    
    // add guesture recognizer for dialog and then add the dialog to view.
    [dialog addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moveNextDialog:)]];
    [self.view addSubview:dialog];
    
    // add skip button.
    skipButton.center = CGPointMake(dialog.center.x, dialog.center.y + dialog.frame.size.height / 2);
    [skipButton addTarget:self action:@selector(skipDialog:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:skipButton];
    
    // add the portraitview image.
    UIImage *portrait = [UIImage imageNamed:masterPortraitImageName];
    UIImageView *portraitView = [[UIImageView alloc] initWithImage:portrait];
    portraitView.frame = portraitFrame;
    [self.view addSubview:portraitView];
}


- (void)moveNextDialog:(UITapGestureRecognizer *)gesture {
    // EFFECTS: show the next message on the view, if there is not any message, the dialog is closed.
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (dialogMessages == nil || nextMessage >= dialogMessages.count) {
            [self.view removeFromSuperview];
        } else {
            dialogContent.text = [dialogMessages objectAtIndex:nextMessage];
            nextMessage++;
        }
    }
}

- (IBAction)skipDialog:(id)sender
{
    [self.view removeFromSuperview];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


@end
