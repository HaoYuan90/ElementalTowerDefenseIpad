#import "ArrangeCreepsOrderVC.h"
#import "SpringBoardIconCell.h"
#import "UserDataFetcher.h"
#import "SocialModeGameVC.h"

@implementation ArrangeCreepsOrderVC

@synthesize selectedUserId;
@synthesize sequence;
@synthesize creepInfo;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _emptyCellIndex = NSNotFound;
    
    self.view.autoresizesSubviews = YES;
 
    
    // grid view sits on top of the background image
    _gridView = [[AQGridView alloc] initWithFrame: CGRectMake(self.view.bounds.origin.x -30, self.view.bounds.origin.y+80 , self.view.bounds.size.width , self.view.bounds.size.height -200)]; 
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.opaque = NO;
    _gridView.dataSource = self;
    _gridView.delegate = self;
    _gridView.scrollEnabled = NO;
    
    if ( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) )
    {
        // bring 1024 in to 1020 to make a width divisible by five
        _gridView.leftContentInset = 2.0;
        _gridView.rightContentInset = 2.0;
    }
    
    [self.view addSubview: _gridView];
    
    // add our gesture recognizer to the grid view
    UILongPressGestureRecognizer * gr = [[UILongPressGestureRecognizer alloc] initWithTarget: self action: @selector(moveActionGestureRecognizerStateChanged:)];
    gr.minimumPressDuration = 0.2;  //!!! minimum pressing duration here!!!
    gr.delegate = self;
    [_gridView addGestureRecognizer: gr];
    if(sequence==nil)
        sequence = [[NSMutableArray alloc] init];
    if ( _icons == nil )
    {
        _icons = [[NSMutableArray alloc] init];
        for ( NSUInteger i = 0; i < [sequence count]; i++ )
        {
            NSDictionary *infoForCurrentCreep = [self.creepInfo objectForKey:[[sequence objectAtIndex:i] stringValue]];
            UIImage * image = [UIImage imageNamed:[infoForCurrentCreep objectForKey:@"normalImageName"]];
            [_icons addObject: image];
        }  
    }
    NSLog(@"%d",[sequence count]);
    for(int i = 0 ; i < [sequence count];i++)
        NSLog(@"%@,",[sequence objectAtIndex:i]);
    [_gridView reloadData];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
    interfaceOrientation == UIInterfaceOrientationLandscapeLeft;
}

- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
                                 duration: (NSTimeInterval) duration
{
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        // width will be 768, which divides by four nicely already
        NSLog( @"Setting left+right content insets to zero" );
        _gridView.leftContentInset = 0.0;
        _gridView.rightContentInset = 0.0;
    }
    else
    {
        // width will be 1024, so subtract a little to get a width divisible by five
        NSLog( @"Setting left+right content insets to 2.0" );
        _gridView.leftContentInset = 2.0;
        _gridView.rightContentInset = 2.0;
        
    }
}

#pragma mark - UIGestureRecognizer Delegate/Actions

- (BOOL) gestureRecognizerShouldBegin: (UIGestureRecognizer *) gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView: _gridView];
    if ( [_gridView indexForItemAtPoint: location] < [_icons count] )
        return ( YES );
    
    // touch is outside the bounds of any icon cells, so don't start the gesture
    return ( NO );
}

- (void) moveActionGestureRecognizerStateChanged: (UIGestureRecognizer *) recognizer
{
    switch ( recognizer.state )
    {
        default:
        case UIGestureRecognizerStateFailed:
            // do nothing
            break;
            
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateCancelled:
        {
            [_gridView beginUpdates];
            
            if ( _emptyCellIndex != _dragOriginIndex )
            {
                [_gridView moveItemAtIndex: _emptyCellIndex toIndex: _dragOriginIndex withAnimation: AQGridViewItemAnimationFade];
            }
            
            _emptyCellIndex = _dragOriginIndex;
            
            // move the cell back to its origin
            [UIView beginAnimations: @"SnapBack" context: NULL];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration: 0.1];
            [UIView setAnimationDelegate: self];
            [UIView setAnimationDidStopSelector: @selector(finishedSnap:finished:context:)];
            
            CGRect f = _draggingCell.frame;
            f.origin = _dragOriginCellOrigin;
            _draggingCell.frame = f;
            
            [UIView commitAnimations];
            
            [_gridView endUpdates];
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            CGPoint p = [recognizer locationInView: _gridView];
            NSUInteger index = [_gridView indexForItemAtPoint: p];
			if ( index == NSNotFound )
			{
				// index is the last available location
				index = [_icons count] - 1;
			}
            
            // update the data store
            id obj = [_icons objectAtIndex: _dragOriginIndex];
            [_icons removeObjectAtIndex: _dragOriginIndex];
            [_icons insertObject: obj atIndex: index];
            
            if ( index != _emptyCellIndex )
            {
                [_gridView beginUpdates];
                [_gridView moveItemAtIndex: _emptyCellIndex toIndex: index withAnimation: AQGridViewItemAnimationFade];
                _emptyCellIndex = index;
                [_gridView endUpdates];
            }
            
            // move the real cell into place
            [UIView beginAnimations: @"SnapToPlace" context: NULL];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration: 0.001];//!!!!!!!!!!!!!!
            [UIView setAnimationDelegate: self];
            [UIView setAnimationDidStopSelector: @selector(finishedSnap:finished:context:)];
            
            CGRect r = [_gridView rectForItemAtIndex: _emptyCellIndex];
            CGRect f = _draggingCell.frame;
            f.origin.x = r.origin.x + floorf((r.size.width - f.size.width) * 0.5);
            f.origin.y = r.origin.y + floorf((r.size.height - f.size.height) * 0.5) - _gridView.contentOffset.y;
            NSLog( @"Gesture ended-- moving to %@", NSStringFromCGRect(f) );
            _draggingCell.frame = f;
            
            _draggingCell.transform = CGAffineTransformIdentity;
            _draggingCell.alpha = 1.0;
            
            [UIView commitAnimations];
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            NSUInteger index = [_gridView indexForItemAtPoint: [recognizer locationInView: _gridView]];
            _emptyCellIndex = index;    // we'll put an empty cell here now
            
            // find the cell at the current point and copy it into our main view, applying some transforms
            AQGridViewCell * sourceCell = [_gridView cellForItemAtIndex: index];
            CGRect frame = [self.view convertRect: sourceCell.frame fromView: _gridView];
            _draggingCell = [[SpringBoardIconCell alloc] initWithFrame: frame reuseIdentifier: @""];
            _draggingCell.icon = [_icons objectAtIndex: index];
            [self.view addSubview: _draggingCell];
            
            // grab some info about the origin of this cell
            _dragOriginCellOrigin = frame.origin;
            _dragOriginIndex = index;
            
            [UIView beginAnimations: @"" context: NULL];
            [UIView setAnimationDuration: 0.01]; //！！！！！！！！！！ grab icon --> enlarge it！！！！！！！！！！！！
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            
            // transformation-- larger, slightly transparent
            _draggingCell.transform = CGAffineTransformMakeScale( 1.2, 1.2 );
            _draggingCell.alpha = 0.7;
            
            // also make it center on the touch point
            _draggingCell.center = [recognizer locationInView: self.view];
            
            [UIView commitAnimations];
            
            // reload the grid underneath to get the empty cell in place
            [_gridView reloadItemsAtIndices: [NSIndexSet indexSetWithIndex: index]
                              withAnimation: AQGridViewItemAnimationNone];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            // update draging cell location
            _draggingCell.center = [recognizer locationInView: self.view];
            
            // don't do anything with content if grid view is in the middle of an animation block
            if ( _gridView.isAnimatingUpdates )
                break;
            
            // update empty cell to follow, if necessary
            NSUInteger index = [_gridView indexForItemAtPoint: [recognizer locationInView: _gridView]];
			
			// don't do anything if it's over an unused grid cell
			if ( index == NSNotFound )
			{
				// snap back to the last possible index
				index = [_icons count] - 1;
			}
			
            if ( index != _emptyCellIndex )
            {
                NSLog( @"Moving empty cell from %u to %u", _emptyCellIndex, index );
                // Modify the sequence
                NSNumber *temp = [sequence objectAtIndex:_emptyCellIndex];
                [sequence removeObjectAtIndex:_emptyCellIndex];
                [sequence insertObject:temp atIndex:index];
                
                
                // batch the movements
                [_gridView beginUpdates];
                
                // move everything else out of the way
                if ( index < _emptyCellIndex )
                {
                    for ( NSUInteger i = index; i < _emptyCellIndex; i++ )
                    {
                        NSLog( @"Moving %u to %u", i, i+1 );
                        
                        [_gridView moveItemAtIndex: i toIndex: i+1 withAnimation: AQGridViewItemAnimationFade];
                    }
                }
                else
                {
                    for ( NSUInteger i = index; i > _emptyCellIndex; i-- )
                    {
                        NSLog( @"Moving %u to %u", i, i-1 );
                        
                        [_gridView moveItemAtIndex: i toIndex: i-1 withAnimation: AQGridViewItemAnimationFade];
                    }
                }
                
                for(int i = 0 ; i < [sequence count];i++)
                    NSLog(@"%@,",[sequence objectAtIndex:i]);
                
                [_gridView moveItemAtIndex: _emptyCellIndex toIndex: index withAnimation: AQGridViewItemAnimationFade];
                _emptyCellIndex = index;
                
                [_gridView endUpdates];
            }
            
            break;
        }
    }
}

- (void) finishedSnap: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context
{
    NSLog(@"finishedSnap called");
    NSIndexSet * indices = [[NSIndexSet alloc] initWithIndex: _emptyCellIndex];
    _emptyCellIndex = NSNotFound;
    
    // load the moved cell into the grid view
    [_gridView reloadItemsAtIndices: indices withAnimation: AQGridViewItemAnimationNone];
    
    // dismiss our copy of the cell
    [_draggingCell removeFromSuperview];
    _draggingCell = nil;
    
}

#pragma mark - GridView Data Source

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return ( [_icons count] );
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * EmptyIdentifier = @"EmptyIdentifier";
    static NSString * CellIdentifier = @"CellIdentifier";
    
    if ( index == _emptyCellIndex )
    {
        NSLog( @"Loading empty cell at index %u", index );
        AQGridViewCell * hiddenCell = [gridView dequeueReusableCellWithIdentifier: EmptyIdentifier];
        if ( hiddenCell == nil )
        {
            // must be the SAME SIZE AS THE OTHERS
            // Yes, this is probably a bug. Sigh. Look at -[AQGridView fixCellsFromAnimation] to fix
            hiddenCell = [[AQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 72.0, 72.0)
                                               reuseIdentifier: EmptyIdentifier];
        }
        
        hiddenCell.hidden = YES;
        return ( hiddenCell );
    }
    
    
    SpringBoardIconCell * cell = (SpringBoardIconCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier];
    if ( cell == nil )
    {
        cell = [[SpringBoardIconCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 72.0, 72.0) reuseIdentifier: CellIdentifier];
    }
    
    cell.icon = [_icons objectAtIndex: index];
    
    return cell;
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return ( CGSizeMake(120, 120) );
}

#pragma mark - Seques

- (IBAction)backButtonPressed:(id)sender 
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	if ([segue.identifier isEqualToString:@"SegueToStartGame"]) {
        SocialModeGameVC *dest = (SocialModeGameVC*) segue.destinationViewController;
        dest.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        NSDictionary *dic = [UserDataFetcher fetchMapWithUserId:self.selectedUserId];
        dest.friendMapInfo = dic;
        dest.creepSequence = sequence;
 	}	
}
@end
