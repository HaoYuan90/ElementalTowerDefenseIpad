#import <Foundation/Foundation.h>
#import "ETDBuffManagerDelegate.h"
#import "ETDResistanceManager.h"
#import "ETDBuff.h"

@interface ETDBuffManager : NSObject {
    NSMutableArray *buffs;
    CGFloat velocityFactor;
    CGFloat resistanceFactor;
    __weak id<ETDBuffManagerDelegate> delegate;
}

@property (nonatomic, readonly) NSMutableArray *buffs;
@property (nonatomic, readonly) CGFloat velocityFactor;
@property (nonatomic, readonly) CGFloat resistanceFactor;
@property (nonatomic, readwrite) BOOL shouldFreezeCreep;

//delegate
@property (nonatomic, weak) id<ETDBuffManagerDelegate> delegate;

- (id)initWithDelegate:(id<ETDBuffManagerDelegate>)del;
// EFFECTS: constructs a ETDBuffManager with the delegate.

- (void)addBuff:(ETDBuff *)buff;
// EFFECTS: adds buff to the array of buffs.

- (void)update;
// EFFECTS: updates the status of buffs.

@end
