//
//  CreepToSelect.h
//  ElementalTowerDefense
//
//  Created by Leon Qiao on 7/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreepSelectDelegate.h"

@interface CreepToSelect : UIViewController

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *creepCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) UIImage *creepImage;

@property int creepId;
@property int creepCount;
@property int creepCost;

@property (weak, nonatomic) id<CreepSelectDelegate> delegate;

- (CreepToSelect*) initWithCreepId: (int)creepId
                          creepImage:(UIImage*)image
                           creepCost:(int)cost
                            delegate:(id <CreepSelectDelegate>)del;
@end
