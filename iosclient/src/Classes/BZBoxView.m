//
//  BZBoxView.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZBoxView.h"


@implementation BZBoxView

@synthesize boxInfoTextView;

- (void)dealloc 
{
    [boxId release];
    [boxInfoTextView release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void)setBoxId:(NSString *)newBoxId
{
    [boxId release];
    boxId = [newBoxId retain];

    
}

- (NSString*)boxId
{
    return boxId;
}

@end
