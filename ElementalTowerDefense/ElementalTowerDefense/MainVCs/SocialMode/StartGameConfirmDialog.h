//
//  StartGameConfirmDialog.h
//  ElementalTowerDefense
//
//  Created by Leon Qiao on 12/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartGameConfirmDialogDelegate.h"
@interface StartGameConfirmDialog : UIViewController 
@property (nonatomic, weak) id <StartGameConfirmDialogDelegate > delegate;
- (StartGameConfirmDialog*) initWithDelegate:(id<StartGameConfirmDialogDelegate>)del;
@end
