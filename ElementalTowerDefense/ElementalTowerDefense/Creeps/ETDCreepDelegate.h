//To be implemented to provide creeps with positions of way points

#import <Foundation/Foundation.h>
#import "ETDBuff.h"

@protocol ETDCreepDelegate <NSObject>

- (CGFloat)getDataWRTMap:(CGFloat)data; 
// EFFECTS: returns the actual game distance based on map

- (CGPoint)waypoingPosition:(int)waypointNumber;
// EFFECTS: returns coordinates of center of tile indicated by waypointNumber.

- (BOOL)shouldExit:(int)waypointNumber;
// EFFECTS: check if the creep is exiting the maze.

- (void)removeCreep:(id)creep;
// REQUIRES: creep must be of type ETDCreep
// EFFECTS: removes creep from game loop

- (void)addNewCreepOnMap:(id)creep;
// REQUIRES: creep must be of type ETDCreep
// EFFECTS: adds creep on game loop

- (void)shouldDisplayArrowTagForBuff:(arrowTagType)type:(arrowTagState)state At:(CGPoint)position;
// EFFECTS: displays the arrow tag for buff.

- (void)addCoins:(int)numOfCoins atPosition:(CGPoint)pos;
// EFFECTS: adds bounty

- (void)addBuffsToCreep:(ETDBuff *)buff position:(CGPoint)p;
// EFFECTS: adds buffs to the creeps around it.

- (void)targetCreep:(id)creep;
// EFFECTS: makes this creep the targeted creep (when it is tapped).

@end
