//
//  BZBoxView.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZBoxView.h"
#import "BZAppDelegate.h"
#import "BZDropContentView.h"

static NSString* const kHistoryTableCellIdentifier = @"History";

@interface BZBoxView (Private)

- (void)reloadHistory;

@end

@implementation BZBoxView

@synthesize boxInfoTextView;
@synthesize historyTable;
@synthesize historyMap;

- (void)dealloc 
{
    [currentAnnotations release];
    [historyTable release];
    [historyMap release];
    [box release];
    [boxInfoTextView release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    if (box.isDropped) self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pickup" style:UIBarButtonItemStyleDone target:self action:@selector(pickupClicked:)];
    else self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Drop" style:UIBarButtonItemStyleDone target:self action:@selector(dropClicked:)];
    
    historyMap.mapType = MKMapTypeHybrid;
    
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

#pragma mark Properties

- (BZBox*)box
{
    return box;
}

- (void)setBox:(BZBox *)newBox
{
    [box release];
    box = [newBox retain];

    [box loadHistoryWithCompletionBlock:^{ [self reloadHistory]; } failedBlock:nil];
}

#pragma mark IBActions

- (IBAction)pickupClicked:(id)sender
{
    [box pickupWithCompletionBlock:^(NSString* message)
     { 
         [self.navigationController popToRootViewControllerAnimated:YES];
         [[[[UIAlertView alloc] initWithTitle:@"Boxz" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
     } failedBlock:nil];
}

- (IBAction)dropClicked:(id)sender
{
    BZDropContentView* newView = [[[BZDropContentView alloc] init] autorelease];
    newView.box = self.box;
    [self.navigationController pushViewController:newView animated:YES];
}

#pragma mark ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary* response = [[[BZAppDelegate app] backend] parsedResponse:request];
    NSLog(@"History: %@", response);
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    return box.history.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kHistoryTableCellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kHistoryTableCellIdentifier];
    
    BZBoxHistoryItem* historyItem = [box.history objectAtIndex:[indexPath row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%g,%g: %@",
                           historyItem.dropLocation.coordinate.latitude,
                           historyItem.dropLocation.coordinate.longitude,
                           historyItem.dropMessage];
    return cell;
}

@end

@implementation BZBoxView (Private)

- (void)reloadHistory
{
    [historyTable reloadData];

    // delete all previous annotations (or create the annotations array)
    if (currentAnnotations)
    {
        [historyMap removeAnnotations:currentAnnotations];
        [currentAnnotations removeAllObjects];
    }
    else
    {
        currentAnnotations = [NSMutableArray new];
    }
    
    MKMapRect allCoordinates = MKMapRectNull;
    
    for (BZBoxHistoryItem* historyItem in box.history)
    {
        MKPointAnnotation* annotation = [[MKPointAnnotation new] autorelease];
        annotation.title = [NSString stringWithFormat:@"%@ %@", historyItem.dropMessage, historyItem.dropTimestamp];
        annotation.coordinate = historyItem.dropLocation.coordinate;
        
        MKMapRect thisCoordinate;
        thisCoordinate.origin = MKMapPointForCoordinate(annotation.coordinate);
        thisCoordinate.size = MKMapSizeMake(0, 0);

        allCoordinates = MKMapRectUnion(allCoordinates, thisCoordinate);

        [historyMap addAnnotation:annotation];
        [currentAnnotations addObject:annotation];
    }

    // add 20% to region span
    MKCoordinateRegion allCoordsRegion = MKCoordinateRegionForMapRect(allCoordinates);
    allCoordsRegion.span.latitudeDelta += .2 * allCoordsRegion.span.latitudeDelta;
    allCoordsRegion.span.longitudeDelta += .2 * allCoordsRegion.span.longitudeDelta;
    historyMap.region = allCoordsRegion;
}

@end