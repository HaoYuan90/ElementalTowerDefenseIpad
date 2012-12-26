#import <UIKit/UIKit.h>
#import "ETDTower.h"
#import "TowerButtonsDelegate.h"

@interface TowerButtonsVC : UIViewController

@property (nonatomic, readonly, strong) ETDTower *target;
@property (nonatomic, readonly, weak) id<TowerButtonsDelegate> delegate;

- (id)initWithTower:(ETDTower*)tower andDelegate:(id<TowerButtonsDelegate>) del;

@end
