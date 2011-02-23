//
//  BZNearByMapView.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZNearByMapView.h"
#import "BZAppDelegate.h"

@interface BZNearByMapView (Private)

- (void)refreshClicked:(id)sender;
- (void)refresh;

@end

@implementation BZNearByMapView

@synthesize mapView;

- (void)dealloc 
{
    [currentAnnotations release];
    [super dealloc];
}

- (id)init
{
    if (self = [super init])
    {
        self.tabBarItem.title = @"Map";
    }
    
    return self;
}

- (void)viewDidLoad 
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshClicked:)] autorelease];
    
    // add my position on the map
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeHybrid;
    mapView.delegate = self;
    
    currentAnnotations = [NSMutableArray new];
    self.navigationItem.title = @"Map";
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refresh];
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

// called when a request finished loading
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSDictionary* resp = [[[BZAppDelegate app] backend] parsedResponse:request];
    if (!resp) return;
    
    NSArray* boxes = [resp objectForKey:@"boxes"];
    if (!boxes) return;

    // delete all previous annotations
    [mapView removeAnnotations:currentAnnotations];
    [currentAnnotations removeAllObjects];
    
    for (NSDictionary* box in boxes)
    {
        MKPointAnnotation* annotation = [[MKPointAnnotation new] autorelease];
        annotation.title = [box objectForKey:@"drop_location"];
        annotation.coordinate = CLLocationCoordinate2DMake([[box objectForKey:@"drop_location_lat"] doubleValue], [[box objectForKey:@"drop_location_lon"] doubleValue]);
        [mapView addAnnotation:annotation];
        [currentAnnotations addObject:annotation];
    }
}

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [aMapView setRegion:MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 500.0, 500.0) animated:YES];
}

@end

@implementation BZNearByMapView (Private)

- (void)refreshClicked:(id)sender
{
    [self refresh];
}

- (void)refresh
{
    ASIHTTPRequest* req = [[[BZAppDelegate app] backend] mapRequest];
    if (!req) return;
    
    [req setDelegate:self];
    [req start];
}

@end