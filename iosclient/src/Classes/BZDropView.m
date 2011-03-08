//
//  BZDropView.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZDropView.h"
#import "BZAppDelegate.h"
#import "BZBox.h"
#import "BZBoxView.h"

static NSString* const kMyBoxCellIdentifer = @"myBox";

@implementation BZDropView

@synthesize boxes;

- (void)dealloc
{
    [myBoxes release];
    [boxes release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    ASIHTTPRequest* req = [[[BZAppDelegate app] backend] requestWithQuery:@"my?dummy=yes"];
    [req setDelegate:self];
    [req start];
    [super viewDidAppear:animated];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BZBoxView* boxView = [[BZBoxView new] autorelease];
    BZBox* box = [myBoxes objectAtIndex:[indexPath row]];
    boxView.box = box;
    
    [self.navigationController pushViewController:boxView animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return myBoxes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kMyBoxCellIdentifer];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMyBoxCellIdentifer] autorelease];
    }

    BZBox* box = [myBoxes objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = box.dropMessage;
    return cell;
}

#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary* response = [[[BZAppDelegate app] backend] parsedResponse:request];
    NSLog(@"Response: %@", response);
    
    NSArray* myBoxesDicts = [[response objectForKey:@"boxes"] retain];
    
    NSMutableArray* newMyBoxes = [NSMutableArray array];
    for (NSDictionary* boxDict in myBoxesDicts)
    {
        BZBox* newBox = [BZBox boxFromDictionary:boxDict];
        [newMyBoxes addObject:newBox];
    }
    
    [myBoxes release];
    myBoxes = [newMyBoxes retain];
    
    [boxes reloadData];
}


@end
