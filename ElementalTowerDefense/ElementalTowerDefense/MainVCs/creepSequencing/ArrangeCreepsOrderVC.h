#import <UIKit/UIKit.h>
#import "AQGridView.h"


@class SpringBoardIconCell;
@interface ArrangeCreepsOrderVC : UIViewController  <AQGridViewDataSource, 
AQGridViewDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray * _icons;
    AQGridView * _gridView;
    
    NSUInteger _emptyCellIndex;
    
    NSUInteger _dragOriginIndex;
    CGPoint _dragOriginCellOrigin;
    
    SpringBoardIconCell * _draggingCell;
    NSMutableArray * sequence;
}
@property (weak,nonatomic) NSString* selectedUserId;
@property (strong,nonatomic) NSMutableArray* sequence;
@property (strong, nonatomic) NSDictionary* creepInfo;
@end
