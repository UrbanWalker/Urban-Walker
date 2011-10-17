//
//  MapViewController.m
//  Shanghai Walker
//
//  Created by JF on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "StepAnnotation.h"


@implementation MapViewController
@synthesize mapNavBar;
@synthesize navItem;
@synthesize mapView;
//@synthesize routeLine;
@synthesize routeLineView;
@synthesize stepNumOverlay;
@synthesize filenames;
@synthesize annotationsInMapView;
@synthesize delegate;
@synthesize overviewMode;
@synthesize annotationToDisplay;
@synthesize arrayRouteLine;
@synthesize arrayRouteLineView;
@synthesize stepNumberText;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//receives multilpe files
- (id) initWithFiles:(NSArray *)theFilenames
{
    if ((self = [super init]))
    {
        self.filenames = theFilenames;    
        
    }
    return self;
}


- (void)viewDidUnload
{
    self.stepNumberText = nil;
    self.arrayRouteLine = nil;
    self.arrayRouteLineView = nil;
    [self setNavItem:nil];
    [self setMapNavBar:nil];
    [super viewDidUnload];
    self.filenames = nil;
    self.mapView = nil;
   // self.routeLine = nil;
    self.routeLineView = nil;
    self.stepNumOverlay = nil;
    self.annotationsInMapView = nil; 
    self.delegate = nil;
}

- (void)dealloc
{
    [arrayRouteLineView release];
    [arrayRouteLine release];
    [mapView release];
    [filenames release];
    [annotationsInMapView release];
 //   [routeLine release];
    [routeLineView release];
    [stepNumOverlay release];
    [navItem release];
    delegate = nil;
    [mapNavBar release];
	[super dealloc];
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

    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:93.0/255 green:45.0/255 blue:38.0/255 alpha:1.0];
    
    self.mapNavBar.tintColor = [UIColor colorWithRed:93.0/255 green:45.0/255 blue:38.0/255 alpha:1.0];
    
    self.navItem.title = self.stepNumberText;
    
    self.mapView.delegate = self;
    
	self.stepNumOverlay = [[NSMutableArray alloc]init];
    
    self.annotationsInMapView = [[NSMutableArray alloc] init];
    
    self.arrayRouteLine = [[NSMutableArray alloc]init];
    
    self.arrayRouteLineView = [[NSMutableArray alloc]init];
    
    if (overviewMode)
        distance = 5400.000;
    else
        distance = 200.000;
	   
    [self displayWalkPath];
}

- (void) displayWalkPath
{
	for (int i = 0; i < [self.filenames count]; i++)
    {
        NSString *filename = [[NSString alloc] initWithString:[[self.filenames objectAtIndex:i]valueForKey:@"WalkFileName"]];
       NSString *filePath = [[NSBundle mainBundle]pathForResource:filename ofType:@"csv"];
        NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        MKMapPoint northEastPoint;
        MKMapPoint southWestPoint;
        
        MKMapPoint *pointArr = malloc(sizeof(CLLocationCoordinate2D) * pointStrings.count);
        
        for (int j = 0; j < pointStrings.count; j++)
        {
            NSString *currentPointString = [pointStrings objectAtIndex:j];
            NSArray *latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            
            CLLocationDegrees latitude = [[latLonArr objectAtIndex:0]doubleValue];
            CLLocationDegrees longitude = [[latLonArr objectAtIndex:1]doubleValue];
            
            CLLocationCoordinate2D coordinate =  CLLocationCoordinate2DMake(latitude, longitude);
            
            /*
                the map can be displayed in 2 instances: 1- as a global map showing all the walks and 
             2- focusing on a single walk             
             
             */
            if (overviewMode) //we want to see the entire map, no need for individual pins
            {
                if (j == 0 || j == pointStrings.count - 1)
                {
                    NSMutableString *titleString = [[NSMutableString alloc]initWithString:[[self.filenames objectAtIndex:i]valueForKey:@"WalkName"]];
                    if (j == 0)
                    {
                        [titleString appendString:@" "];
                        unichar emDash = 0x2014;
                        [titleString appendString:[NSString stringWithCharacters:&emDash length:1]];
                        [titleString appendString:@" Start"];                                        
                    }
                    if (j == pointStrings.count - 1)
                    {
                        [titleString appendString:@" "];
                        unichar emDash = 0x2014;
                        [titleString appendString:[NSString stringWithCharacters:&emDash length:1]];
                        [titleString appendString:@" End"];                                        
                    }
                    StepAnnotation *annotation = [[StepAnnotation alloc]initWithCoordinates:coordinate title:titleString subTitle:nil];
                    [self.mapView addAnnotation:annotation];
                    [self.annotationsInMapView addObject:annotation];
                    
                    [titleString release];
                    [annotation release]; 
                }
                
            }
            else
            {
                int t = [[latLonArr objectAtIndex:2]intValue];
                if (t > -1) //if an annotation needs to be placed, value (i.e. step number) will be greater than -1
                {
                    NSMutableString *titleString;
                    if (t == 1)
                    {
                        titleString = [[NSMutableString alloc]initWithString:@"Step "];
                        [titleString appendString:[NSString stringWithFormat:@"%d ",t]];
                        unichar emDash = 0x2014;
                        [titleString appendString:[NSString stringWithCharacters:&emDash length:1]];
                        [titleString appendString:[NSString stringWithString:@" Start"]];
                    }
                    else if (j == pointStrings.count-1)
                    {
                        titleString = [[NSMutableString alloc]initWithString:@"Step "];
                        [titleString appendString:[NSString stringWithFormat:@"%d ",t]];
                        unichar emDash = 0x2014;
                        [titleString appendString:[NSString stringWithCharacters:&emDash length:1]];
                        [titleString appendString:[NSString stringWithString:@" End"]];
                    }
                    else
                    {
                        titleString = [[NSMutableString alloc]initWithString:@"Step "];
                        [titleString appendString:[NSString stringWithFormat:@"%d",t]];
                    }
                    
                    StepAnnotation *annotation = [[StepAnnotation alloc]initWithCoordinates:coordinate title:titleString subTitle:nil];
                    [self.mapView addAnnotation:annotation];
                    [self.annotationsInMapView addObject:annotation];
                    
                    [titleString release];
                    [annotation release];
                }
            
            }
            
            MKMapPoint point = MKMapPointForCoordinate(coordinate);
            
            if (j == 0)
            {
                northEastPoint = point;
                southWestPoint = point;
                
                //setting up initial display of map, based on first point in list            
                CLLocationCoordinate2D zoomLocation;
                zoomLocation.latitude = [[latLonArr objectAtIndex:0]doubleValue];
                zoomLocation.longitude = [[latLonArr objectAtIndex:1]doubleValue];;
                
                MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, distance, distance);
                MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
                
                [self.mapView setRegion:adjustedRegion animated:YES];
                
            }
            else {
                if (point.x > northEastPoint.x) 
                    northEastPoint.x = point.x;
                if (point.y > northEastPoint.y)
                    northEastPoint.y = point.y;
                if (point.x < southWestPoint.x)
                    southWestPoint.x = point.x;
                if (point.y < southWestPoint.y)
                    southWestPoint.y = point.y;
                
            }
            pointArr[j] = point;
            
            
        }
        
        //need an array of routelines when displaying the global map???
        //self.routeLine = [MKPolyline polylineWithPoints:pointArr count:pointStrings.count];
      
        MKPolyline *routeLine = [MKPolyline polylineWithPoints:pointArr count:pointStrings.count];
        [self.arrayRouteLine addObject:routeLine];
        
        [self.mapView addOverlay:[self.arrayRouteLine objectAtIndex:i]];
        
        free(pointArr);
        [filename release];
    }
}

- (void) showUserLocation
{
        self.mapView.showsUserLocation = YES;
}


- (void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation = userLocation.coordinate;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, distance, distance);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    
}

// Any errors are sent here
- (void) mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    switch ([error code]) 
    {
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location Denied!" message:@"Please turn on Location Services for this app by going to Settings → General → Location Services" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }   
            break;
            
        case kCLErrorNetwork:
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Your location couldn't be determined" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
            break;
    }
}
- (MKOverlayView *) mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    
    BOOL found = NO;
    MKOverlayView *overlayView = nil;
    
    if ([self.arrayRouteLineView count] > 0)
    {
        for (MKPolylineView *polyView in self.arrayRouteLineView) 
        {
            if (polyView.polyline == overlay)
            {
                found = YES;
                overlayView = polyView;
                
            }
        }
    }
    if (!found) 
    {
        for (MKPolyline *routeLine in self.arrayRouteLine) 
        {
            if (overlay == routeLine)
            {
                
                MKPolylineView *aRouteLineView = [[[MKPolylineView alloc]initWithPolyline:routeLine]autorelease];
                aRouteLineView.lineWidth = 8;
                aRouteLineView.lineCap = kCGLineCapRound;
                aRouteLineView.lineJoin = kCGLineJoinRound;
                aRouteLineView.strokeColor = [[UIColor brownColor] colorWithAlphaComponent:0.7];
                [self.arrayRouteLineView addObject:aRouteLineView];
            }
        }
        
    }

    
    return overlayView;

 /*   
    	MKOverlayView *overlayView = nil;
	
    for (MKPolyline *routeLine in self.arrayRouteLine) 
    {
        if (overlay == routeLine)
        {
            
            if ([self.arrayRouteLineView containsObject:routeLine] == NO)
            {
                MKPolylineView *aRouteLineView = [[[MKPolylineView alloc]initWithPolyline:routeLine]autorelease];
                aRouteLineView = [[[MKPolylineView alloc]initWithPolyline:routeLine]autorelease];
                aRouteLineView.lineWidth = 8;
                aRouteLineView.lineCap = kCGLineCapRound;
                aRouteLineView.lineJoin = kCGLineJoinRound;
                aRouteLineView.strokeColor = [[UIColor brownColor] colorWithAlphaComponent:0.7];
                [self.arrayRouteLineView addObject:aRouteLineView];
            }
            
            int index = [self.arrayRouteLineView indexOfObject:routeLine];
            overlayView = [self.arrayRouteLineView objectAtIndex:index];
            
            
            
        }
    }
	return overlayView;
*/
}

- (void) displayAnnotationNumber:(int) annotationNumber
{
    StepAnnotation *anno = [self.annotationsInMapView objectAtIndex:annotationNumber];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(anno.coordinate,distance, distance);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    
    [self.mapView setRegion:adjustedRegion animated:YES];
    [self.mapView selectAnnotation:anno animated:YES];
}


- (void) viewDidAppear:(BOOL)animated
{
    if (!overviewMode)
    {
        [self displayAnnotationNumber:annotationToDisplay];
    }

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)doneButtonPushed:(id)sender 
{
    [self.delegate doneButtonWasPushed];
}


- (IBAction)findMeButtonPushed:(id)sender
{
    [self showUserLocation];
}



@end
