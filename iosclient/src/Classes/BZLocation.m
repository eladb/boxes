//
//  BZLocation.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZLocation.h"
#import "DictionaryExtensions.h"

static NSString* const kSimulatedLocationDefaultsKey = @"simulatedLocation";
static NSString* const kRealLocationDefaultsKey = @"lastLocation";

@interface CLLocation (Dictionary)

- (NSDictionary*)toDictionary;
+ (CLLocation*)locationFromDictionary:(NSDictionary*)dict;

@end

@interface BZLocation (Private)

- (void)loadFromDefaults;
- (void)saveToDefaults;

@end

@implementation BZLocation

// dealloc
- (void)dealloc
{
    [simulatedLocation release];
    [realLocation release];
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
        
        // load last locations from defaults
        [self loadFromDefaults];
    }
    
    return self;
}

// returns the last location updated
- (CLLocation*)currentLocation
{
    if (simulatedLocation) return simulatedLocation;
    return realLocation;
}

- (CLLocation*)simulatedLocation
{
    return simulatedLocation;
}

- (void)setSimulatedLocation:(CLLocation *)newSimulatedLocation
{
    [simulatedLocation release];
    simulatedLocation = [newSimulatedLocation retain];
    [self saveToDefaults];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

// notify when the location is updated
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location update to: %@", [newLocation description]);
    realLocation = [newLocation retain];
    [self saveToDefaults];
}

@end

@implementation BZLocation (Privte)

- (void)loadFromDefaults
{
    NSUserDefaults* d = [NSUserDefaults standardUserDefaults];
    
    self.simulatedLocation = [CLLocation locationFromDictionary:[d objectForKey:kSimulatedLocationDefaultsKey]];
    
    [realLocation release];
    realLocation = [[CLLocation locationFromDictionary:[d objectForKey:kRealLocationDefaultsKey]] retain];
}

- (void)saveToDefaults
{
    NSDictionary* dict = [self.simulatedLocation toDictionary];
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kSimulatedLocationDefaultsKey];
    [[NSUserDefaults standardUserDefaults] setObject:[realLocation toDictionary] forKey:kRealLocationDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

@implementation CLLocation (Dictionary)

- (NSDictionary*)toDictionary
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithDouble:self.coordinate.latitude], @"coordinate.latitude",
            [NSNumber numberWithDouble:self.coordinate.longitude], @"coordinate.longitude",
            nil];
}

+ (CLLocation*)locationFromDictionary:(NSDictionary*)dict
{
    NSNumber* latitudeNumber = [dict objectForKey:@"coordinate.latitude"];
    NSNumber* longitudeNumber = [dict objectForKey:@"coordinate.longitude"];
    if (!latitudeNumber || !longitudeNumber) return nil;
    return [[[CLLocation alloc] initWithLatitude:[latitudeNumber doubleValue] longitude:[longitudeNumber doubleValue]] autorelease];
}

@end