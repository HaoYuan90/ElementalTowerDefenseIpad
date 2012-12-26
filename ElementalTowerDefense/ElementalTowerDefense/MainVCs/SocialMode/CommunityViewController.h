#import <UIKit/UIKit.h>
#import "FBConnector.h"



@interface CommunityViewController : UIViewController <FBRequestDelegate,UIAlertViewDelegate>

//button with friend images
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet UIButton *button4;
@property (weak, nonatomic) IBOutlet UIButton *button5;
@property (weak, nonatomic) IBOutlet UIButton *button6;
@property (weak, nonatomic) IBOutlet UIButton *button7;
@property (weak, nonatomic) IBOutlet UIButton *button8;
@property (weak, nonatomic) IBOutlet UIButton *button9;
@property (weak, nonatomic) IBOutlet UIButton *button10;
//page number
@property (weak, nonatomic) IBOutlet UILabel *pageNumLabel;
//friend information
@property (weak, nonatomic) IBOutlet UILabel *friendsInfoDisplay;

@end
