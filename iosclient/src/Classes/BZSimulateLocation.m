//
//  SimulateLocation.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZSimulateLocation.h"
#import "BZAppDelegate.h"

@interface BZSimulateLocation (Private)

- (void)updateCurrentLocation;
- (void)setLocationClicked:(id)sender;
- (void)queryBoxes;

@end

@implementation BZSimulateLocation

@synthesize map;
@synthesize realLocationButton;

- (void)dealloc 
{
    [currentAnnotations release];
    [realLocationButton release];
    [map release];
    [super dealloc];
}

- (void)viewDidLoad 
{
    self.navigationItem.title = @"Simulate Location";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Set" style:UIBarButtonItemStyleDone target:self action:@selector(setLocationClicked:)] autorelease];
 
    map.showsUserLocation = YES;
    map.mapType = MKMapTypeHybrid;
    
    [self updateCurrentLocation];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self queryBoxes];
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark IBActions

- (IBAction)realLocationClicked:(id)sender
{
    [[BZAppDelegate app] location].simulatedLocation = nil;
    [self updateCurrentLocation];
}

@end

@implementation BZSimulateLocation (Private)

- (void)updateCurrentLocation
{
    if ([[BZAppDelegate app] location].simulatedLocation) 
    {
        [realLocationButton setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        [realLocationButton setBackgroundColor:[UIColor blueColor]];
    }

    CLLocation* currentLocation = [[[BZAppDelegate app] location] currentLocation];
    
    MKCoordinateRegion region;
    region.center = currentLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.005, 0.005);
    [map setRegion:region animated:YES];
}

- (void)setLocationClicked:(id)sender
{
    CLLocation* newLocation = [[CLLocation alloc] initWithCoordinate:map.centerCoordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
    [[BZAppDelegate app] location].simulatedLocation = newLocation;
    [self updateCurrentLocation];
}

- (void)queryBoxes
{
    ASIHTTPRequest *req = [[[BZAppDelegate app] backend] mapRequestWithCoordinates:map.centerCoordinate andZoom:1];
    [req setDelegate:self];
    [req start];
}

// called when a request finished loading
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary* resp = [[[BZAppDelegate app] backend] parsedResponse:request];
    if (!resp) return;
    
    NSArray* boxes = [resp objectForKey:@"boxes"];
    if (!boxes) return;
    
    // delete all previous annotations
    if (currentAnnotations)
    {
        [map removeAnnotations:currentAnnotations];
        [currentAnnotations removeAllObjects];
    }
    else
    {
        currentAnnotations = [NSMutableArray new];
    }
    
    for (NSDictionary* box in boxes)
    {
        MKPointAnnotation* annotation = [[MKPointAnnotation new] autorelease];
        annotation.title = [box objectForKey:@"drop_location"];
        annotation.coordinate = CLLocationCoordinate2DMake([[box objectForKey:@"drop_location_lat"] doubleValue], [[box objectForKey:@"drop_location_lon"] doubleValue]);
        [map addAnnotation:annotation];
        [currentAnnotations addObject:annotation];
    }
}

@end