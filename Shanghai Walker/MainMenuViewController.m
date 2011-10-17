//
//  MainMenuViewController.m
//  Shanghai Walker
//
//  Created by JF on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "PageController.h"
#import "Reachability.h"



@implementation MainMenuViewController
@synthesize metricSystemSwitch;
@synthesize iButton;
@synthesize calepinView;
@synthesize backOfCalepin;
@synthesize tableView = _tableView;
@synthesize arrayOfWalkFilenames;
@synthesize tvCell;
@synthesize walkName;
@synthesize distanceLabel;
@synthesize mapVC;


- (MapViewController *) mapVC
{
    if (mapVC == nil)
    {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [self.arrayOfWalkFilenames count]; i++)
        {
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:
                                [[self.arrayOfWalkFilenames objectAtIndex:i]valueForKey:@"WalkFileName"],@"WalkFileName",
                                [[self.arrayOfWalkFilenames objectAtIndex:i]valueForKey:@"WalkName"],@"WalkName",
                                  nil];
            [arr addObject:dict];
            [dict release];
        }
        
        NSArray *arr2 = [[NSArray alloc]initWithArray:arr];
        mapVC = [[MapViewController alloc]initWithFiles:arr2];
        [arr2 release];
        [arr release];
    }
    return mapVC;
}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {

    }
    return self;
}

- (void)dealloc
{
    [_tableView release];
    [distanceLabel release];
    [arrayOfWalkFilenames release];
    [tvCell release];
    [walkName release];
    [calepinView release];
    [backOfCalepin release];
    [metricSystemSwitch release];
    [mapVC release];
    [iButton release];
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
    
    self.title = @"Shanghai Walker";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor colorWithRed:146.0/255 green:193.0/255 blue:216.0/255 alpha:1.0];
    self.tableView.backgroundColor = [UIColor clearColor];

    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:93.0/255 green:45.0/255 blue:38.0/255 alpha:1.0];

    [self buildWalks];
    

    
    // Do any additional setup after loading the view from its nib.
}

- (void) buildWalks
{
    NSDictionary *walk1 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"TheFrenchConcessionI",@"WalkFileName",
                           @"4.1", @"WalkDistance",
                           @"The French Concession II", @"WalkName",
                           @"Exploring {distance} of charming streets.", @"slogan",
                           nil];
    
    
    NSDictionary *walk2 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"FromTheTemple",@"WalkFileName",
                           @"4", @"WalkDistance",
                           @"From the Temple", @"WalkName",
                           @"Around Jing'an in {distance}.", @"slogan",
                           nil];
  
    
    
    NSDictionary *walk3 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"strollingToTianzifang",@"WalkFileName",
                           @"2.5", @"WalkDistance",
                           @"Strolling to Tianzifang", @"WalkName",
                           @"{distance} through tree covered roads.", @"slogan",
                           nil];
    
     
    NSDictionary *walk4 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"weekendWalk",@"WalkFileName",
                           @"2.4", @"WalkDistance",
                           @"Weekend Walk", @"WalkName",
                           @"A {distance} walk for a sunny weekend.", @"slogan",
                           nil];
						   
	NSDictionary *walk5 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"warmupWalk",@"WalkFileName",
                           @"2.6", @"WalkDistance",
                           @"West Jing'an", @"WalkName",
                           @"Easy {distance} outside of downtown.", @"slogan",
                           nil];
    
    
	NSDictionary *walk6 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"PSQYuGarden",@"WalkFileName",
                           @"4", @"WalkDistance",
                           @"Onwards to Yu Garden", @"WalkName",
                           @"From busy to busier in {distance}.", @"slogan",
                           nil];
    
    
    NSDictionary *walk7 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"acrossTheRiver",@"WalkFileName",
                           @"4.9", @"WalkDistance",
                           @"Across the River", @"WalkName",
                           @"{distance} of contrasts.", @"slogan",
                           nil];
    
    NSDictionary *walk8 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"TheFrenchConcession34",@"WalkFileName",
                           @"3.4", @"WalkDistance",
                           @"The French Concession I", @"WalkName",
                           @"Bars, shops and music in {distance}.", @"slogan",
                           nil];
    
    NSDictionary *walk9 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"CityCenter",@"WalkFileName",
                           @"3.1", @"WalkDistance",
                           @"The City Center", @"WalkName",
                           @"To the symbolic center in {distance}.", @"slogan",
                           nil];
    
    
    
    self.arrayOfWalkFilenames = [[NSArray alloc]initWithObjects:walk1,
                                 walk2,
                                 walk3,
                                 walk4,
								 walk5,
                                 walk6,
                                 walk7,
                                 walk8,
                                 walk9,
								 nil];
    
    [walk1 release];
    [walk2 release];
    [walk3 release];
    [walk4 release];
	[walk5 release];
    [walk6 release];
    [walk7 release];
    [walk8 release];
    [walk9 release];
    
    //now, all walks have a distance from the user's location calculated. Next step is to sort the array from closest to farthest
	//http://stackoverflow.com/questions/3925666/sorting-an-nsarray-of-nsdictionary
	
	NSSortDescriptor *descriptor = [[[NSSortDescriptor alloc] initWithKey:@"WalkDistance" ascending:YES] autorelease]; 
	NSArray *arr = [self.arrayOfWalkFilenames sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
	
    self.arrayOfWalkFilenames = [arr copy];

}

- (void) viewWillAppear:(BOOL)animated  
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)viewDidUnload
{
    [self setTableView:nil];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.arrayOfWalkFilenames = nil;
    [self setDistanceLabel:nil];
    [self setArrayOfWalkFilenames:nil];
    [self setTvCell:nil];
    [self setWalkName:nil];
    [self setCalepinView:nil];
    [self setBackOfCalepin:nil];
    [self setMetricSystemSwitch:nil];
    [self setMapVC:nil];
    [self setIButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - tableView

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayOfWalkFilenames count];
}
/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.0;
}
*/

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0f];
        cell.textLabel.shadowColor = [UIColor lightGrayColor];
        cell.textLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        
        cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
        cell.detailTextLabel.shadowColor = [UIColor whiteColor];
        cell.detailTextLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
        cell.detailTextLabel.textColor = [UIColor colorWithRed:93.0f/255.0f green:45.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }
    cell.textLabel.text = [[self.arrayOfWalkFilenames objectAtIndex:indexPath.row]valueForKey:@"WalkName"];
    
    CGFloat d = [[[self.arrayOfWalkFilenames objectAtIndex:indexPath.row]valueForKey:@"WalkDistance"]floatValue];
    
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
    
    NSString *text = [[NSString alloc]initWithString:[[self.arrayOfWalkFilenames objectAtIndex:indexPath.row]valueForKey:@"slogan"]];
    NSString *text2 = [[NSString alloc]initWithString:[text stringByReplacingOccurrencesOfString:@"{distance}" withString:[format stringFromNumber:n]]];
    
    
    cell.detailTextLabel.text = text2;
    [format release];
    [text release];
    [text2 release];
    
/*
    self.walkName.text = [[self.arrayOfWalkFilenames objectAtIndex:indexPath.row]valueForKey:@"WalkName"];
    
    CGFloat d = [[[self.arrayOfWalkFilenames objectAtIndex:indexPath.row]valueForKey:@"WalkDistance"]floatValue];

    NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
    [format setNumberStyle:NSNumberFormatterNoStyle];
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

    NSString *text = [[NSString alloc]initWithString:[[self.arrayOfWalkFilenames objectAtIndex:indexPath.row]valueForKey:@"slogan"]];
    NSString *text2 = [[NSString alloc]initWithString:[text stringByReplacingOccurrencesOfString:@"{distance}" withString:[format stringFromNumber:n]]];
    
    self.distanceLabel = (UILabel *)[cell viewWithTag:99];
    self.distanceLabel.text = text2;
    [format release];
    [text release];
    [text2 release];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;*/
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //set title of current window to have a different label
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Walks" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    PageController *pageCtrl = [[PageController alloc]initWithFile: [[self.arrayOfWalkFilenames objectAtIndex:indexPath.row] valueForKey:@"WalkFileName"]];
    [self.navigationController pushViewController:pageCtrl animated:YES];
    [pageCtrl release];		

   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)iButtonPushed:(id)sender 
{
      
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self.metricSystemSwitch.on = [prefs boolForKey:@"metric"];
        
    self.iButton.hidden = YES;
    [UIView transitionFromView:self.calepinView
                        toView:self.backOfCalepin
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneButtonPushed)];
                         self.navigationItem.rightBarButtonItem = doneButton; 
                        [doneButton release];
                    }];
}

- (void) DoneButtonPushed
{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:self.metricSystemSwitch.on forKey:@"metric"];
    [prefs synchronize];
       
    [self.tableView reloadData];

     self.navigationItem.rightBarButtonItem = nil;
    
    [UIView transitionFromView:self.backOfCalepin
                        toView:self.calepinView
                      duration:0.6
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    completion:nil
                    ];
        self.iButton.hidden = NO;
}

- (IBAction)viewWalksOnMapButtonPushed:(id)sender 
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    if (internetStatus != NotReachable) {

        self.mapVC.delegate = self;
        self.mapVC.overviewMode = YES;
        [self.navigationController presentModalViewController:self.mapVC animated:YES];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No network connection" message:@"Sorry, you need to be connected to the internet to access the map." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
}

// mapview delegate
- (void) doneButtonWasPushed
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self setMapVC:nil];
}

@end
