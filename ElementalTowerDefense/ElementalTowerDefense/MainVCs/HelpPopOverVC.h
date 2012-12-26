//
//  HelpPopOverVC.h
//  ElementalTowerDefense
//
//  Created by Nguyen Ngoc Trung on 4/9/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpPopOverDelegate.h"

@interface HelpPopOverVC : UIViewController
@property (nonatomic, weak) id <HelpPopOverDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;

- (id)initWithDelegate:(id<HelpPopOverDelegate>)del;

@end
