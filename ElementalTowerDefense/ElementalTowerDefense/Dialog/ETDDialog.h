#import <UIKit/UIKit.h>

@interface ETDDialog : UIViewController

@property (strong, nonatomic) IBOutlet UIView *superView;
@property (strong, nonatomic) IBOutlet UIView *transparentLayer;
@property (strong, nonatomic) IBOutlet UIView *dialog;
@property (strong, nonatomic) IBOutlet UIButton *skipButton;
@property (strong, nonatomic) IBOutlet NSArray *dialogMessages;
@property (readonly, nonatomic) int nextMessage;
@property (strong, nonatomic) IBOutlet UILabel *dialogContent;

- (id)initWithSuperView:(UIView *)view;
// EFFECTS: constructs a ETDDialog with a super view.

- (void)freezeScreen;

- (void)showDialogs:(NSArray *)contents;
// EFFECTS: shows the dialog on the view with the contents.

- (void)moveNextDialog:(UITapGestureRecognizer *)gesture;
// EFFECTS: show the next message on the view, if there is not any message, the dialog is closed.

@end
