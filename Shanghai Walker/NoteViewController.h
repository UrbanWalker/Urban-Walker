//
//  NoteViewController.h
//  Shanghai Walker
//
//  Created by JF on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NoteViewDelegate <NSObject>

- (void) startWalkingButtonWasPushed;
- (void) mapButtonWasPushed;
@end


@interface NoteViewController : UIViewController {
    
    UILabel *walkName;
    UITextView *aboutThisWalkText;
    UIImageView *thumbnailImage;
    UILabel *distanceLabel;
    UILabel *durationLabel;
    UILabel *startsLabel;
    UILabel *endsLabel;
    UILabel *midText;
    UIButton *helpButton;
    
    id <NoteViewDelegate> delegate;
    UIView *walkIntroTopView;
    UILabel *roadLookingForLabel;
    UIView *viewWithImageViewTop;
    UIImageView *stepImage;
    UITextView *helpText;
    UIView *flipView;
    UIView *tornPaperView;
    UIButton *mapButton;
}
@property (nonatomic, retain) IBOutlet UIView *tornPaperView;
@property (nonatomic, retain) NSDictionary *walkInfo;
@property (assign) id delegate;
@property (nonatomic, retain) IBOutlet UILabel *walkName;
@property (nonatomic, retain) IBOutlet UITextView *aboutThisWalkText;
@property (nonatomic, retain) IBOutlet UIImageView *thumbnailImage;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *durationLabel;
@property (nonatomic, retain) IBOutlet UILabel *startsLabel;
@property (nonatomic, retain) IBOutlet UILabel *endsLabel;
@property (nonatomic, retain) IBOutlet UILabel *midText;
@property (nonatomic, retain) IBOutlet UIButton *helpButton;
@property (nonatomic, retain) IBOutlet UIView *viewWithImageViewTop;
@property (nonatomic, retain) IBOutlet UIImageView *stepImage;
@property (nonatomic, retain) IBOutlet UITextView *helpText;
@property (nonatomic, retain) IBOutlet UIView *flipView;
@property (nonatomic, retain) IBOutlet UIView *walkIntroTopView;
@property (nonatomic, retain) IBOutlet UILabel *roadLookingForLabel;
- (IBAction)okButtonPushed:(id)sender;
@property (nonatomic, retain) IBOutlet UIButton *mapButton;

- (IBAction)mapButtonPushed:(id)sender;
- (IBAction)helpButtonPushed:(id)sender;
- (IBAction)startWalkingButtonPushed:(id)sender;
- (id) initWithDict:(NSDictionary *)aDict;
- (void) DoneButtonPushed;
@end


