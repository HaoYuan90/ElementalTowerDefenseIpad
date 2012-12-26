#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameDatabaseAccess.h"
#import "GameLevel.h"

@interface ListLevels : UIViewController <GameLevelDelegate> {
    GameLevelModel *selectedLevel;
    NSMutableArray *listOfLevels;
    int stageId;
}

@property (weak, nonatomic) IBOutlet UILabel *stageName;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIView *levelFrameView;
@property (weak, nonatomic) IBOutlet UIImageView *backButton;
@property (weak, nonatomic) IBOutlet UIScrollView *levelArea;
@property (strong, nonatomic) NSMutableArray *listOfLevels;
@property (strong, nonatomic) GameLevelModel *selectedLevel;
@property (readwrite, nonatomic) int stageId;

- (IBAction)backButtonPressed:(id)sender;

@end
