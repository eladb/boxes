//
//  BZSettings.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZSettings.h"
#import "TargetConditionals.h"

@implementation BZSettings

// url of the home service
- (NSURL*)homeUrl
{
    return [NSURL URLWithString:@"http://boxesapi.appspot.com"];
}    

// the zoom level to request when sending the map request
- (NSInteger)mapRequestZoomLevel
{
    return 15;
}

// returns true if we should simulate the user's location or use the actual location.
- (BOOL)simulateLocation
{
#ifdef TARGET_IPHONE_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

@end
