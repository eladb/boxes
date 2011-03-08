//
//  BZBackend.h
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "BZSettings.h"
#import "BZLocation.h"
#import "BZUser.h"

// performs calls to the boxes backend service.
@interface BZBackend : NSObject
{
    BZLocation* location;
    BZSettings* settings;
    BZUser* user;
}

// init
- (id)initWithSettings:(BZSettings*)settingsModule andLocation:(BZLocation*)locationModule;

// creates a request for a specific query.
- (ASIHTTPRequest*)requestWithQuery:(NSString*)queryString;

// creates a 'map' request with coordinates and zoom level.
- (ASIHTTPRequest*)mapRequestWithCoordinates:(CLLocationCoordinate2D)coords andZoom:(NSInteger)zoomLevel;

// creates a 'map' request with coordinates and the default zoom level.
- (ASIHTTPRequest*)mapRequestWithCoordinates:(CLLocationCoordinate2D)coords;

// creates a 'map' request with current location and default zoom level.
- (ASIHTTPRequest*)mapRequest;

// returns a parsed response or nil if there was an error.
- (id)parsedResponse:(ASIHTTPRequest*)request;

@end
