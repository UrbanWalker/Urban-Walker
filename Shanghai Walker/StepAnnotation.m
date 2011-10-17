//
//  StepAnnotation.m
//  Shanghai Walker
//
//  Created by JF on 7/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StepAnnotation.h"


@implementation StepAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (id) initWithCoordinates:(CLLocationCoordinate2D )paramCoordinates title:(NSString *)paramTitle subTitle:(NSString *) paramSubTitle;
{
    if ((self = [super init]))
    {
        coordinate = paramCoordinates;
        title = [paramTitle copy];
        subtitle = [paramSubTitle copy];
    }
    return self;
}

- (void) dealloc
{
    [title release];
    [subtitle release];
    [super dealloc];
}


@end
