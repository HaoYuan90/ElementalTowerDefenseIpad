#import <UIKit/UIKit.h>
#import "GameLevelModel.h"
#import "GameLevelDelegate.h"

@interface GameLevel : UIViewController{
    GameLevelModel *model;
    UIImageView *view;
}
@property (nonatomic, readonly, weak) id<GameLevelDelegate> delegate;
@property (nonatomic, strong) GameLevelModel *model;
@property (nonatomic, strong) UIImageView *view;

- (id)initWithModel:(GameLevelModel *)levelModel position:(int)position delegate:(id<GameLevelDelegate>)del;
// EFFECTS: constructs a new GameLevelLevel.

- (void)openLevel;
// EFFECTS: adds guestures to allow user to tap the level.  
@end