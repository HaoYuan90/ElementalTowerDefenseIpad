#import <Foundation/Foundation.h>

@protocol TileMapDelegate <NSObject>

-(void)setInitLife:(int)life andCoin:(int)coin;
-(void)didChangeLifeLeft:(int)life;
-(void)didChangeCoin:(int)coin;
-(void)didFinishCurrentWave:(float)percentage;
//percentage is current wave number/total wave
-(void)didFinishGame;
-(void)didLostGame;
-(void)didPlaceComboTower;
-(void)handleTowerSelection:(id)tower;
-(UIView *)getSuperView;
//push warning
-(void)showWarningOfType:(popoverWarningType)tp;

@end
