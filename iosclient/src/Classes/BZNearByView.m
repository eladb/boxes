//
//  BZNearByView.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZAppDelegate.h"
#import "BZNearByView.h"
#import "JSON.h"

static NSString *const kCellIdentifier = @"boxCell";

@interface BZNearByView (Private)

- (void)refresh;
- (void)refreshClicked:(id)sender;

@end

@implementation BZNearByView

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

// returns the table cell for a row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* c = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!c) 
    {
        c = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    NSDictionary* box = [boxes objectAtIndex:[indexPath row]];
    c.textLabel.text = [box objectForKey:@"drop_location"];
    
    return c;
}

// returns the number of rows in the table view
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return boxes.count;
}

// called when a request finished loading
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary* responseDict = [[[BZAppDelegate app] backend] parsedResponse:request];
    if (!responseDict) return;
    
    [boxes release];
    boxes = [[responseDict objectForKey:@"boxes"] retain];
    
    // reload table view
    [boxesTableView reloadData];
}

@end

@implementation BZNearByView (Private)

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