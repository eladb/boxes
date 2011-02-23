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
}

@property (nonatomic, readonly) CLLocation *currentLocation;

// init
- (id)initWithSettings:(BZSettings*)settingsModule;

// dealloc
- (void)dealloc;

@end
