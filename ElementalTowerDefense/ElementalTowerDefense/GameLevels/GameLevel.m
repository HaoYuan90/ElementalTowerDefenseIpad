//
//  GameLevel.m
//  ElementalTowerDefense
//
//  Created by DINH TUAN NHU on 4/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import "GameLevel.h"

@interface GameLevel ()
@end

@implementation GameLevel
@synthesize model;
@synthesize view;
@synthesize delegate;

- (id)initWithModel:(GameLevelModel *)levelModel position:(int)position delegate:(id<GameLevelDelegate>)del{
    // EFFECTS: Constructs a new GameLevelLevel
    
    self = [super init];
    model = levelModel;
    delegate = del;
    
    UIImage *img = [UIImage imageNamed:LEVEL_IMG];
    view = [[UIImageView alloc] initWithImage:img];
    view.frame = CGRectMake((LEVEL_VIEW_WIDTH + LEVEL_GAP_X) * (position % NUMBER_LEVEL_VIEW_PER_ROW) + 5, (LEVEL_VIEW_HEIGHT + LEVEL_GAP_Y) * (position / NUMBER_LEVEL_VIEW_PER_ROW), LEVEL_VIEW_WIDTH, LEVEL_VIEW_HEIGHT);
    view.contentMode = UIViewContentModeCenter;
    
    // create a label to show the name of game level
    UILabel *levelLabel  = [[UILabel alloc] initWithFrame:CGRectMake(22, 8, 81, 81)];
    levelLabel.text = model.name;
    levelLabel.textAlignment =  UITextAlignmentCenter;
    levelLabel.backgroundColor =[UIColor clearColor];
    levelLabel.textColor = [UIColor whiteColor];
    levelLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(30.0)];
    [view addSubview:levelLabel];
    
    if (model.highScore > 0) {
        [self openLevel];
    } else {
        view.alpha = 0.5;
    }
    
    int numberStars = round(3.0 * model.highScore / model.initLife);
    img = [UIImage imageNamed:[STARS_IMAGES objectAtIndex:numberStars]];
    UIImageView *stars = [[UIImageView alloc] initWithImage:img];
    stars.frame = CGRectMake(26, 91, 73, 19);
    [view addSubview:stars];
    
    return self;
}

- (void)openLevel {
    view.alpha = 1;
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(play:)]];
}

- (void)play:(UITapGestureRecognizer *)gesture {	
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [delegate playGame:self.model];
    }
}


@end
