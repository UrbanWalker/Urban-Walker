//
//  NoteViewController.m
//  Shanghai Walker
//
//  Created by JF on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NoteViewController.h"
#import "MapViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation NoteViewController
@synthesize mapButton;
@synthesize viewWithImageViewTop;
@synthesize stepImage;
@synthesize helpText;
@synthesize flipView;
@synthesize walkIntroTopView;
@synthesize roadLookingForLabel;
@synthesize thumbnailImage;
@synthesize distanceLabel;
@synthesize durationLabel;
@synthesize startsLabel;
@synthesize endsLabel;
@synthesize midText;
@synthesize helpButton;

@synthesize tornPaperView;
@synthesize walkInfo;
@synthesize walkName;
@synthesize aboutThisWalkText;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithDict:(NSDictionary *)aDict
{
    if ((self = [super init]))
    {
        self.walkInfo = aDict;
    }
    return self;
}

- (void)dealloc
{
    [walkName release];
    [thumbnailImage release];
    [aboutThisWalkText release];
    [distanceLabel release];
    [durationLabel release];
    [startsLabel release];
    [endsLabel release];
    [walkIntroTopView release];
    [viewWithImageViewTop release];
    [stepImage release];
    [midText release];
    [helpButton release];
    [roadLookingForLabel release];
    [helpText release];
    [flipView release];
    [tornPaperView release];
    [mapButton release];
    [super dealloc];
    [walkInfo release];
}

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
    

    /* The thumnail only exists in the first screen. If it is there, we are dealing
        with the first screen. Other screen will need to load different values */
    if ([UIImage imageNamed:[self.walkInfo valueForKey:@"thumbnail"]])
    {
        CGRect frame = self.walkIntroTopView.frame;
        frame.origin.x = 47;
        frame.origin.y = 95;
        self.walkIntroTopView.frame = frame;
        
        [self.tornPaperView addSubview:self.walkIntroTopView];
        
        self.thumbnailImage.image = [UIImage imageNamed:[self.walkInfo valueForKey:@"thumbnail"]];
        
        self.thumbnailImage.layer.masksToBounds = NO;
        self.thumbnailImage.layer.shadowColor = [UIColor blackColor].CGColor;
        self.thumbnailImage.layer.shadowOffset = CGSizeMake(0, 2);
        self.thumbnailImage.layer.shadowOpacity = 0.7f;
      //  self.thumbnailImage.layer.shadowRadius = 5.0;
        
        
        self.walkName.text = [self.walkInfo valueForKey:@"walkTitle"];
        self.midText.text = @"About This Walk";
        
        self.aboutThisWalkText.text = [self.walkInfo valueForKey:@"overview"];
        
       
        
        CGFloat d = [[self.walkInfo valueForKey:@"distance"]floatValue];
        
        NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
        [format setNumberStyle:NSNumberFormatterDecimalStyle];
        [format setDecimalSeparator:@"."];
        [format setMaximumFractionDigits:1];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        if ([prefs boolForKey:@"metric"])
        {
            [format setPositiveSuffix:@" km"];
        }
        else //U.S.
        {
            d = d / 1.6;
            [format setPositiveSuffix:@" mi"];
        }
        NSNumber *n = [NSNumber numberWithFloat:d];
        
        self.distanceLabel.text = [format stringFromNumber:n];
        
        
        self.durationLabel.text = [self.walkInfo valueForKey:@"duration"];
        self.startsLabel.text = [self.walkInfo valueForKey:@"starts"];
        self.endsLabel.text = [self.walkInfo valueForKey:@"ends"];
        self.helpButton.hidden = YES;
        
        self.mapButton.hidden = YES;
        
        [format release];

    }
    else
    {
        CGRect frame = self.viewWithImageViewTop.frame;
        frame.origin.x = 47;
        frame.origin.y = 90;
        self.viewWithImageViewTop.frame = frame;
        
        //reusing the label for walkName to display step number
        self.walkName.text = [self.walkInfo valueForKey:@"StepName"];
        self.midText.text = @"Directions";
        
        self.aboutThisWalkText.text = [self.walkInfo valueForKey:@"DirectionText"];
       
        self.stepImage.image = [UIImage imageNamed:[self.walkInfo valueForKey:@"picture"]]; 
        
     //   self.stepImage.layer.masksToBounds = YES;
        self.stepImage.layer.cornerRadius = 20;

        //shadow for images //remember to import quartzcore
        self.stepImage.layer.shadowColor = [UIColor blackColor].CGColor;
        self.stepImage.layer.shadowOffset = CGSizeMake(0, 2);
        self.stepImage.layer.shadowOpacity = 0.7f;
        //self.stepImage.layer.shadowRadius = 1.0;
        self.stepImage.layer.masksToBounds = NO;
       // UIBezierPath *p = [UIBezierPath bezierPathWithRect:self.stepImage.bounds] ;
       // self.stepImage.layer.shadowPath = p.CGPath;
        
        [self.tornPaperView addSubview:self.viewWithImageViewTop];
         self.helpButton.hidden = NO;
        
        self.helpText.text = [self.walkInfo valueForKey:@"helpText"];
        self.roadLookingForLabel.text = [self.walkInfo valueForKey:@"helpTextEn"];
        //center the label
        
        self.mapButton.hidden = NO;
        
        
    }
    

}

- (void)viewDidUnload
{
    [self setWalkName:nil];
    [self setThumbnailImage:nil];
    [self setAboutThisWalkText:nil];
    [self setDistanceLabel:nil];
    [self setDurationLabel:nil];
    [self setStartsLabel:nil];
    [self setEndsLabel:nil];
    [self setWalkIntroTopView:nil];
    [self setViewWithImageViewTop:nil];
    [self setStepImage:nil];
    [self setMidText:nil];
    [self setHelpButton:nil];
    [self setRoadLookingForLabel:nil];
    [self setHelpText:nil];
    [self setFlipView:nil];
    [self setTornPaperView:nil];
    [self setMapButton:nil];
    [super viewDidUnload];
    self.walkInfo = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)startWalkingButtonPushed:(id)sender 
{
    [self.delegate startWalkingButtonWasPushed ];
    
}

- (IBAction)okButtonPushed:(id)sender 
{
    [UIView transitionFromView:self.flipView
                        toView:self.tornPaperView
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:nil];

}

- (IBAction)mapButtonPushed:(id)sender 
{
    [self.delegate mapButtonWasPushed];

}

- (IBAction)helpButtonPushed:(id)sender
{
        [UIView transitionFromView:self.tornPaperView
                        toView:self.flipView
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                        completion:nil];
    
}

- (void) DoneButtonPushed
{

              
}
@end
