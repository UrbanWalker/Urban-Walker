//
//  PageController.m
//  PagingTests
//
//  Created by Jeff on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PageController.h"
#import "Reachability.h"


@implementation PageController
@synthesize scrollView = _scrollView;
@synthesize stepViewControllers;
@synthesize arrayOfWalkDetails;
@synthesize pageControl;




/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
 // Custom initialization
 }
 return self;
 }
 */


- (id) initWithFile:(NSString *) aFile
{
    if ((self = [super init]))
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:aFile ofType:@"plist"];
        self.arrayOfWalkDetails = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [[self.arrayOfWalkDetails objectAtIndex:0] valueForKey:@"walkTitle"];
    
    maxSteps = [self.arrayOfWalkDetails count];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * maxSteps,self.scrollView.frame.size.height );
    
    self.scrollView.delegate = self;
	
	NSMutableArray *stepViewCtrls = [[NSMutableArray alloc]init];
	for (unsigned i = 0; i < maxSteps; i++)
	{
		[stepViewCtrls addObject:[NSNull null]];
	}
	
	self.stepViewControllers = stepViewCtrls;
	[stepViewCtrls release];
	
    //setup the page control
    self.pageControl.numberOfPages = [self.arrayOfWalkDetails count];
    self.pageControl.currentPage = 0;

	[self loadStepViewWithPage:0];
    [self loadStepViewWithPage:1];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.scrollView = nil;
	self.stepViewControllers = nil;
    self.arrayOfWalkDetails = nil;
    
    
}
- (void)dealloc 
{
	[_scrollView release];
    [arrayOfWalkDetails release];
    [pageControl release];
    [super dealloc];
}


#pragma mark scrollView

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (pageControlUsed) { //called from UIPageControl, not the user dragging
        return;
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
	currentPageShown = floor((scrollView.contentOffset.x - pageWidth * 0.5) / pageWidth) +1;

    self.pageControl.currentPage = currentPageShown;
   	[self loadStepViewWithPage:currentPageShown];
	//[self loadStepViewWithPage:currentPageShown-1];
	[self loadStepViewWithPage:currentPageShown+1];	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}



- (void) loadStepViewWithPage:(int) page
{
    if (page < 0) 
    {
        return;
    }
    
    if (page >= maxSteps)
    {
        return;
    }
    
    NoteViewController *noteViewVC = [self.stepViewControllers objectAtIndex:page];
    if ((NSNull *)noteViewVC == [NSNull null] )
    {                                                                                   
        noteViewVC = [[NoteViewController alloc]initWithDict:[self.arrayOfWalkDetails objectAtIndex:page]];
        noteViewVC.delegate = self;
        [self.stepViewControllers replaceObjectAtIndex:page withObject:noteViewVC];
        [noteViewVC release];
    }
    
    if (noteViewVC.view.superview == nil)
    {
        CGRect frame = noteViewVC.view.frame;                       //center horizontally
        frame.origin.x = (self.scrollView.frame.size.width * page)+(self.scrollView.frame.size.width - noteViewVC.view.frame.size.width)/2;
        frame.origin.y = 5 + (self.scrollView.frame.size.height - noteViewVC.view.frame.size.height)/2; //center vertically but think of uipagectrl
        noteViewVC.view.frame = frame;
        
        [self.scrollView addSubview:noteViewVC.view];
        
    }
    
}




- (void) startWalkingButtonWasPushed
{
    //set the "back" text on the back button
	self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    
    NoteViewController *noteViewVC = [stepViewControllers objectAtIndex:currentPageShown];
    
    [UIView transitionWithView:noteViewVC.view
                      duration:0.6 
                       options:UIViewAnimationOptionTransitionCurlUp
                    animations:^{[self.navigationController pushViewController:noteViewVC animated:NO];}
                    completion:nil];

}


- (IBAction)changePage:(id)sender 
{
    int page = self.pageControl.currentPage;
    
    //load the visible page and the page on either side of it
    [self loadStepViewWithPage:page - 1];
    [self loadStepViewWithPage:page];
    [self loadStepViewWithPage:page + 1];
    
    //update the scrollview to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    
    pageControlUsed = YES;
    
}

- (void) mapButtonWasPushed
{

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable) 
    {
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:
                              [[self.arrayOfWalkDetails objectAtIndex:0]valueForKey:@"mapFile" ],@"WalkFileName",
                              nil];
        
        NSArray *arr = [[NSArray alloc]initWithObjects:dict, nil];
        
        MapViewController *mapVC = [[MapViewController alloc]initWithFiles:arr];
        
        [dict release];
        [arr release];
        
        mapVC.overviewMode = NO;
        mapVC.delegate = self;
        
        mapVC.annotationToDisplay = currentPageShown-1;
        mapVC.stepNumberText = [NSString stringWithFormat:@"Step %d",currentPageShown];
        [self.navigationController presentModalViewController:mapVC animated:YES];
        
        [mapVC release];        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"Sorry, you need to be connected to the internet to access the map." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}

- (void) doneButtonWasPushed
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void) tornPaperViewDoneButtonWasPushed
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.stepViewControllers objectAtIndex:currentPageShown];
}

@end
