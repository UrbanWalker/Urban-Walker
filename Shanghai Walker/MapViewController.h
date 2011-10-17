//
//  MapViewController.h
//  Shanghai Walker
//
//  Created by JF on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol MapViewControllerDelagate <NSObject>

- (void) doneButtonWasPushed;

@end

@interface MapViewController : UIViewController<MKMapViewDelegate> 
{

    UINavigationItem *navItem;
    id<MapViewControllerDelagate> delegate;
    UINavigationBar *mapNavBar;
    float distance;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UINavigationItem *navItem;
//@property (nonatomic, retain) MKPolyline *routeLine;
@property (nonatomic, retain) MKPolylineView *routeLineView;
@property (nonatomic, retain) NSMutableArray *stepNumOverlay;
@property (nonatomic, retain) NSMutableArray *arrayRouteLine;
@property (nonatomic, retain) NSMutableArray *arrayRouteLineView;
@property (nonatomic, assign) id delegate;
@property (nonatomic, copy) NSArray *filenames;
@property (nonatomic) BOOL overviewMode;
@property (nonatomic, retain) IBOutlet UINavigationBar *mapNavBar;
@property (nonatomic) int annotationToDisplay;
@property (nonatomic, retain) NSMutableArray *annotationsInMapView; //MapView seems to return annotations in random order. Need to have them in the sequence they are added 
@property (nonatomic,copy) NSString *stepNumberText;

- (IBAction)doneButtonPushed:(id)sender;
//- (id) initWithFile:(NSString *)aFilename;
- (id) initWithFiles:(NSArray *)theFilenames;
- (void) showUserLocation;
- (void) displayWalkPath;
- (void) displayAnnotationNumber:(int) annotationNumber;

- (IBAction)findMeButtonPushed:(id)sender;

@end
