#import <UIKit/UIKit.h>
#import "Constants.h"
#import "WarningPopOverDelegate.h"

@interface WarningPopOverVC : UIViewController

@property (nonatomic, readonly) popoverWarningType type;
@property (nonatomic, readonly, strong) UILabel *desc;
@property (nonatomic, readonly, weak) id<WarningPopOverDelegate> delegate;

- (id)initWithWarningType:(popoverWarningType)tp andDelegate:(id<WarningPopOverDelegate>) del;

@end
