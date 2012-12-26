//to be implemented for the build selection
#import <Foundation/Foundation.h>

@protocol BuildSelectionDelegate <NSObject>

-(void) didSelect:(TowerType)choice At:(int)tileNumber;
-(void) destroySelectionPanel;

@end
