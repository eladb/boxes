//
//  NSString+Extensions.h
//  boxes
//
//  Created by eladb on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSString (Extensions)

// converts a string in the format 'lat,lng' to a CLLocation or returns nil if could not do it
- (CLLocation*)locationValue;

// converts a string in the format '2011-03-08 14:30:25.781325' to an NSDate
- (NSDate*)dateValue;

@end
