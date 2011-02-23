//
//  BZLocation.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZLocation.h"


@implementation BZLocation

// dealloc
- (void)dealloc
{
    [settings release];
    [manager release];
    [super dealloc];
}

// init
- (id)initWithSettings:(BZSettings*)settingsModule
{
    if (self = [super init])
    {
        settings = [settingsModule retain];
        
        manager = [CLLocationManager new];
        manager.purpose = @"Find boxes around you";
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        manager.delegate = self;
        
        // start updating location
        [manager startUpdatingLocation];
    }
    
    return self;
}

// returns the last location updated
- (CLLocation*)currentLocation
{
    if ([settings simulateLocation])
    {
        return [[[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(32.09054, 34.78162)
                                              altitude:0
                                    horizontalAccuracy:kCLLocationAccuracyNearestTenMeters 
                                      verticalAccuracy:kCLLocationAccuracyNearestTenMeters 
                                             timestamp:[NSDate date]] autorelease];
    }
    else 
    {
        return manager.location;
    }
}

// notify when the location is updated
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location update to: %@", [newLocation description]);
}

@end
