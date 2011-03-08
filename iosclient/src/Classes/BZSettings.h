//
//  BZSettings.h
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// app settings
@interface BZSettings : NSObject 
{
}

// url of the home service
- (NSURL*)homeUrl;

// the zoom level to request when sending the map request
- (NSInteger)mapRequestZoomLevel;

@end
