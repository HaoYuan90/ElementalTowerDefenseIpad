//testing interface for game

#import <UIKit/UIKit.h>
#import "TileMapViewController.h"

@interface GameTestViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *gameArea;
@property (nonatomic, readonly, strong) TileMapViewController *tileMap;

-(IBAction) spawnCreep:(id)sender;

@end
