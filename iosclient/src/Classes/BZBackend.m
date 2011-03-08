//
//  BZBackend.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZBackend.h"
#import "JSON.h"

@implementation BZBackend

// dealloc
- (void)dealloc
{
    [settings release];
    [location release];
    [user release];
    [super dealloc];
}

// init
- (id)initWithSettings:(BZSettings*)settingsModule andLocation:(BZLocation*)locationModule
{
    if (self = [super init])
    {
        settings = [settingsModule retain];
        location = [locationModule retain];
        user = [BZUser new];
    }
    
    return self;
}

// creates a request for a specific query.
- (ASIHTTPRequest*)requestWithQuery:(NSString*)queryString
{
    NSString* urlEncodedQueryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* url = [NSString stringWithFormat:@"%@/%@&token=%@", [settings homeUrl], urlEncodedQueryString, user.token];
    NSLog(@"request: %@", url);
    ASIHTTPRequest* req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    return req;
}

// returns a parsed response or nil if there was an error.
- (id)parsedResponse:(ASIHTTPRequest*)request
{
    if ([request responseStatusCode] != 200)
    {
        NSLog(@"HTTP error %d: %@ %@", [request responseStatusCode], [request responseStatusMessage], [request responseString]);
        return nil;
    }
    
    id val = [[request responseString] JSONValue];
    NSLog(@"Response: %@", val);
    return val;
}

// creates a 'map' request with coordinates and zoom level.
- (ASIHTTPRequest*)mapRequestWithCoordinates:(CLLocationCoordinate2D)coords andZoom:(NSInteger)zoomLevel
{
    return [self requestWithQuery:[NSString stringWithFormat:@"map?lat=%g&long=%g&zoom=%d", coords.latitude, coords.longitude, zoomLevel]];    
}

// creates a 'map' request with coordinates and the default zoom level.
- (ASIHTTPRequest*)mapRequestWithCoordinates:(CLLocationCoordinate2D)coords
{
    return [self mapRequestWithCoordinates:coords andZoom:[settings mapRequestZoomLevel]];
}

// creates a 'map' request with current location and default zoom level.
- (ASIHTTPRequest*)mapRequest
{
    CLLocation* currentLocation = [location currentLocation];
    if (!currentLocation) 
    {
        NSLog(@"cannot send a map request without a valid location");
        return nil;
    }
    
    return [self mapRequestWithCoordinates:currentLocation.coordinate];
}

@end
