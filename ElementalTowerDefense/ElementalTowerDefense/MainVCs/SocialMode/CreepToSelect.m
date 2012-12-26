//
//  CreepToSelect.m
//  ElementalTowerDefense
//
//  Created by Leon Qiao on 7/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import "CreepToSelect.h"

@implementation CreepToSelect
@synthesize mainView;
@synthesize creepCountLabel;
@synthesize imageView;
@synthesize creepCount = _creepCount;
@synthesize creepId = _creepId;
@synthesize creepCost = _creepCost;
@synthesize delegate = _delegate;
@synthesize creepImage;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return interfaceOrientation == UIInterfaceOrientationLandscapeRight 
    || interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

- (CreepToSelect*) initWithCreepId: (int)creepId
                          creepImage:(UIImage*)image
                           creepCost:(int)cost
                            delegate:(id <CreepSelectDelegate>)del
{
    if(self = [super init]){
        _creepId = creepId;
        _creepCost = cost;
        _delegate = del;
        self.creepImage = image;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (IBAction)plusButtonPressed:(id)sender {
    if([self.delegate tryAddingCreep:self]){
        self.creepCountLabel.text = [NSString stringWithFormat:@"%d",self.creepCount];
    }
}
- (IBAction)minusButtonPressed:(id)sender {
    if([self.delegate tryRemovingCreep:self]){
        self.creepCountLabel.text = [NSString stringWithFormat:@"%d",self.creepCount];
    }
}


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainView.backgroundColor = [UIColor clearColor];
    self.imageView.image = self.creepImage;
    [self.view bringSubviewToFront:self.creepCountLabel]; 
}



- (void)viewDidUnload {
     NSLog(@"!!!");
    [self setMainView:nil];
    [self setCreepCountLabel:nil];
    [self setImageView:nil];
    [super viewDidUnload];
}
@end
