//
//  BZLocation.h
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BZSettings.h"

@interface BZLocation : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *manager;
    BZSettings* settings;
    
    CLLocation* simulatedLocation;
    CLLocation* realLocation;
}

@property (nonatomic, readonly) CLLocation *currentLocation; // the current location (simulated or real).
@property (nonatomic, retain) CLLocation* simulatedLocation; // gets or sets simulated location. if set to nil, this means we are using real location.

// init
- (id)initWithSettings:(BZSettings*)settingsModule;

// dealloc
- (void)dealloc;

@end
