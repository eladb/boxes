//
//  BZNearByView.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZAppDelegate.h"
#import "BZPickupView.h"
#import "JSON.h"
#import "BZBox.h"
#import "BZBoxView.h"

static NSString *const kCellIdentifier = @"boxCell";

@interface BZPickupView (Private)

- (void)refresh;
- (void)refreshClicked:(id)sender;

@end

@implementation BZPickupView

@synthesize boxesTableView;

- (void)dealloc 
{
    [boxes release];
    [boxesTableView release];
    [super dealloc];
}

- (void)viewDidLoad 
{

    self.navigationItem.title = @"Around me";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked:)] autorelease];
    
    boxes = [NSArray new]; // empty array to start with
    
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refresh];
    [super viewDidAppear:animated];
}

#pragma mark UITableViewDelegate

// returns the table cell for a row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* c = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!c) 
    {
        c = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    BZBox* box = [boxes objectAtIndex:[indexPath row]];
    c.textLabel.text = [NSString stringWithFormat:@"%@ (%.fm)", box.dropMessage, [box distanceFromCurrentLocation]];
    c.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return c;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return boxes.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZBoxView* boxView = [[BZBoxView new] autorelease];
    boxView.box = [boxes objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:boxView animated:YES];
}

#pragma mark ASIHTTPRequestDelegate

NSInteger compareBoxDistance(id box1Obj, id box2Obj, void* context)
{
    BZBox* box1 = (BZBox*)box1Obj;
    BZBox* box2 = (BZBox*)box2Obj;
    
    CLLocationDistance distance1 = [box1 distanceFromCurrentLocation];
    CLLocationDistance distance2 = [box2 distanceFromCurrentLocation];
    
    return distance1 - distance2;
}

// called when a request finished loading
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary* responseDict = [[[BZAppDelegate app] backend] parsedResponse:request];
    if (!responseDict) return;
    
    NSArray* rawBoxes = [responseDict objectForKey:@"boxes"];
    
    // convert to BZBox
    NSMutableArray* unsortedBoxes = [NSMutableArray array];
    for (NSDictionary* rawBox in rawBoxes)
    {
        BZBox* box = [BZBox boxFromDictionary:rawBox];
        [unsortedBoxes addObject:box];
    }

    // sort by distance to current location
    NSArray* sortedBoxes = [unsortedBoxes sortedArrayUsingFunction:compareBoxDistance context:nil];
    
    [boxes release];
    boxes = [sortedBoxes retain];
    
    // sort boxes by distance from current location
    
    
    // reload table view
    [boxesTableView reloadData];
}

@end

@implementation BZPickupView (Private)

// reloads boxes from backend.
- (void)refresh
{
    ASIHTTPRequest* req = [[[BZAppDelegate app] backend] mapRequest];
    if (!req) return;
    
    [req setDelegate:self];
    [req start];
}

- (void)refreshClicked:(id)sender
{
    [self refresh];
}

@end