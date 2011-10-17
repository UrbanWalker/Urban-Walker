//
//  PageController.h
//  PagingTests
//
//  Created by Jeff on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteViewController.h" 
#import "MapViewController.h"

@interface PageController : UIViewController <UIScrollViewDelegate, NoteViewDelegate,MapViewControllerDelagate>
{
	int maxSteps;
    int currentPageShown;
    NSMutableArray *stepViewControllers;
    UIPageControl *pageControl;
    
    // to be used when scrolls originates from UIPageControl
    BOOL pageControlUsed;
}  

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *stepViewControllers;
@property (nonatomic, retain) NSArray *arrayOfWalkDetails;

- (IBAction)changePage:(id)sender;

- (id) initWithFile:(NSString *) aFile;
- (void) loadStepViewWithPage:(int) page;
- (void) tornPaperViewDoneButtonWasPushed;

@end
