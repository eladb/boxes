//
//  DiagnosticsView.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZDiagnosticsView.h"
#import "BZSimulateLocation.h"

@implementation BZDiagnosticsView

@synthesize menu;

- (void)dealloc 
{
    [menu release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    MTMenuSection* locationSection = [menu addSectionWithTitle:@"Location"];
    [locationSection addItem:[MTMenuItem itemWithTitle:@"Simulate Location" image:[UIImage imageNamed:@"13-target.png"] navigateTo:[[BZSimulateLocation new] autorelease] viaController:self.navigationController]];
    
    [super viewDidLoad];
}

@end
