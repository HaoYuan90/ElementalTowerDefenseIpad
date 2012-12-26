#import <UIKit/UIKit.h>
#import "CreepSelectDelegate.h"
#import "CreepToSelect.h"

@interface SelectCreepsVC : UIViewController <CreepSelectDelegate>
// userId
@property (weak,nonatomic) NSString* selectedUserId;
// scroll & content
@property (weak, nonatomic) IBOutlet UIScrollView *creepPlaceHoldingPlane;
@property (weak, nonatomic) IBOutlet UIView *scrollViewContent;
@property (strong, nonatomic) NSMutableArray *creepsToSelect;
// credit to buy creeps
@property int credit;
@property (weak, nonatomic) IBOutlet UILabel *creditLabel;
// game info
@property (strong, nonatomic) NSDictionary *creepInfo;
@property (strong, nonatomic) NSDictionary *friendMapInfo;
- (IBAction)backButtonPressed:(id)sender;

@end