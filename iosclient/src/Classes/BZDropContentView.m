//
//  BZDropContentView.m
//  boxes
//
//  Created by eladb on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZDropContentView.h"
#import "BZAppDelegate.h"

@implementation BZDropContentView

@synthesize dropMessageText;
@synthesize box;

- (void)dealloc 
{
    [box release];
    [dropMessageText release];
    [super dealloc];
}

#pragma mark IBOutlets

- (IBAction)dropClicked:(id)sender
{
    [box dropAtLocation:[BZAppDelegate app].location.currentLocation andMessage:dropMessageText.text WithCompletionBlock:^ (NSString* message)
     {
         [self.navigationController popToRootViewControllerAnimated:YES];
         [[[[UIAlertView alloc] initWithTitle:@"Boxz" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
     } failedBlock:nil];
}

@end