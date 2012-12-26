//
//  InGameOptionVC.h
//  ElementalTowerDefense
//
//  Created by Nguyen Ngoc Trung on 4/8/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InGameOptionDelegate.h"

@interface InGameOptionVC : UIViewController

@property (nonatomic, strong) UIImageView *backgroundFrame;
@property (nonatomic, strong) UIImageView *optionRestart;
@property (nonatomic, strong) UIImageView *optionGoToMainMenu;
@property (nonatomic, strong) UIImageView *optionGoToLevelSelection;
@property (nonatomic, strong) UIImageView *dismissButton;
@property (nonatomic, weak) id <InGameOptionDelegate> delegate;

- (id)initWithDelegate:(id<InGameOptionDelegate>)del;

@end
