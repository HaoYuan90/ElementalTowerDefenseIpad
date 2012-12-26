#import "ModalNoAnimationSegue.h"

@implementation ModalNoAnimationSegue

- (void)perform {
    [self.sourceViewController presentViewController:self.destinationViewController animated:YES completion:nil];
} 

@end
