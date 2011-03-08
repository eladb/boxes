//
//  NSString+Extensions.m
//  boxes
//
//  Created by eladb on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extensions.h"

@implementation NSString (Extensions)

// converts a string in the format 'lat,lng' to a CLLocation or returns nil if could not do it
- (CLLocation*)locationValue
{
    NSArray* components = [self componentsSeparatedByString:@","];
    if (components.count != 2) return nil;
    
    NSString* latString = [components objectAtIndex:0];
    NSString* lngString = [components objectAtIndex:1];
    
    if (!latString || !lngString || latString.length == 0 || lngString.length == 0)
        return nil;
 
    CLLocationDegrees lat = [latString doubleValue];
    CLLocationDegrees lng = [lngString doubleValue];
    
    return [[[CLLocation alloc] initWithLatitude:lat longitude:lng] autorelease];
}

// converts a string in the format '2011-03-08 14:30:25.781325' to an NSDate
- (NSDate*)dateValue
{
    NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSSS";
    NSDate* gmtDate = [formatter dateFromString:self];
    
    NSTimeZone* gmtTimeZone = [NSTimeZone localTimeZone];
    NSInteger secondsFromGmt = [gmtTimeZone secondsFromGMT];
    return [gmtDate dateByAddingTimeInterval:secondsFromGmt];
}

@end
