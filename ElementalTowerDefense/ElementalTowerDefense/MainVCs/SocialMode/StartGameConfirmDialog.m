//
//  StartGameConfirmDialog.m
//  ElementalTowerDefense
//
//  Created by Leon Qiao on 12/4/12.
//  Copyright (c) 2012 University of Singapore. All rights reserved.
//

#import "StartGameConfirmDialog.h"

@interface StartGameConfirmDialog ()

@end

@implementation StartGameConfirmDialog
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (StartGameConfirmDialog*) initWithDelegate:(id<StartGameConfirmDialogDelegate>)del
{
    if(self = [super init]){
        _delegate = del;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)startButtonPressed:(id)sender {
    [self.delegate startGame];
    [self.view removeFromSuperview];
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.view removeFromSuperview];
}

@end
