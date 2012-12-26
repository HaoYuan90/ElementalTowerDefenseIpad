#import <UIKit/UIKit.h>
#import "TileMapDelegate.h"
#import "TileMapViewController.h"
#import "InGameOptionVC.h"
#import "SocialModeEndGameDialog.h"
#import "StartGameConfirmDialog.h"

@interface SocialModeGameVC : UIViewController <TileMapDelegate,InGameOptionDelegate,SocialModeEndGameDialogDelegate,StartGameConfirmDialogDelegate>
{
    NSString* _friendId;
}
//UIOutlets
@property (weak, nonatomic) IBOutlet UIScrollView *gameArea;
@property (weak, nonatomic) IBOutlet UIView *mask;
//topleft
@property (weak, nonatomic) IBOutlet UIButton *multiStateButton;
//btm
@property (weak, nonatomic) IBOutlet UILabel *DmgLabel;
@property (weak, nonatomic) IBOutlet UILabel *DmgNum;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (nonatomic, readonly, strong) TileMapViewController *tileMap;
@property (nonatomic, strong) NSDictionary* friendMapInfo;
@property (nonatomic, strong) NSArray* creepSequence;

@property (nonatomic) BOOL isInPreviewMode;
// ingame options
@property (nonatomic, strong) InGameOptionVC *optionViewforSocial;

@property (nonatomic, strong) SocialModeEndGameDialog *endGameDialog;

@property (nonatomic, strong) StartGameConfirmDialog *startGameDialog;

-(IBAction)multiStateButtonPressed:(UIButton*)sender;
-(IBAction)homeButtonPressed:(UIButton*)sender;
- (void)setButtonStatePause;

@end
