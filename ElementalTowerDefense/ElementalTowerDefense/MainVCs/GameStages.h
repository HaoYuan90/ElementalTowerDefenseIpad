//
//  GameStages.h
//  ElementalTowerDefense
//
//  Created by DINH TUAN NHU on 3/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListLevels.h"

@interface GameStages : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *fire;
@property (readonly, nonatomic) int selectedStage;

- (IBAction)backButtonPressed:(id)sender;

@end
