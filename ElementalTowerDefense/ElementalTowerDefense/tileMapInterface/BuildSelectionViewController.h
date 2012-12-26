#import <UIKit/UIKit.h>
#import "BuildSelectionDelegate.h"

@interface BuildSelectionViewController : UIViewController

@property (nonatomic, readonly) CGPoint center; 
@property (nonatomic, readonly) int tileNumber; 
@property (nonatomic, readonly, weak) id<BuildSelectionDelegate> delegate;


- (id)initWithCenter:(CGPoint)ct tileNumber:(int)tileNumber Delegate: (id<BuildSelectionDelegate>)del;

@end
