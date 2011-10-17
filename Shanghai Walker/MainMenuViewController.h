//
//  MainMenuViewController.h
//  Shanghai Walker
//
//  Created by JF on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"



@interface MainMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,MapViewControllerDelagate> {
    
    IBOutlet UITableView *_tableView;
    UILabel *walkName;
    UIImageView *distanceImageView;
    UIView *calepinView;
    UIView *backOfCalepin;
    UISwitch *metricSystemSwitch;
    UIButton *iButton;
}
@property (nonatomic, retain) NSArray *arrayOfWalkFilenames;
@property (nonatomic, retain) MapViewController *mapVC;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) IBOutlet UITableViewCell *tvCell;
@property (nonatomic, retain) IBOutlet UILabel *walkName;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UIView *calepinView;
@property (nonatomic, retain) IBOutlet UIView *backOfCalepin;
@property (nonatomic, retain) IBOutlet UISwitch *metricSystemSwitch;
@property (nonatomic, retain) IBOutlet UIButton *iButton;


- (IBAction)iButtonPushed:(id)sender;
- (IBAction)viewWalksOnMapButtonPushed:(id)sender;
- (void) DoneButtonPushed;
- (void) buildWalks;


@end
