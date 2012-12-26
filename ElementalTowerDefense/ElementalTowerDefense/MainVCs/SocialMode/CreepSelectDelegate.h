//
//  CreepSelectDelegate.h
//  ElementalTowerDefense
//
//  Created by Leon Qiao on 6/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CreepSelectDelegate <NSObject>
- (BOOL) tryAddingCreep: (id)sender;
- (BOOL) tryRemovingCreep: (id)sender;
@end
