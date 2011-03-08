//
//  ExtensionsTests.m
//  boxes
//
//  Created by eladb on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ExtensionsTests.h"
#import "NSString+Extensions.h"

@implementation ExtensionsTests

- (void)testStringLocationValue
{
    CLLocation* loc = [@"12.33,33.4" locationValue];
    STAssertNotNil(loc, @"locationValue should not return nil");
    STAssertEquals(12.33, loc.coordinate.latitude, @"latitude should be 12.33");
    STAssertEquals(33.40, loc.coordinate.longitude, @"longitude should be 33.40");
}

- (void)testStringLocationValueInvalid
{
    STAssertNil([@"12.33" locationValue], @"locationValue should return nil");
    STAssertNil([@"" locationValue], @"locationValue should return nil");
    STAssertNil([@",22.33" locationValue], @"locationValue should return nil");
    STAssertNil([@"12.2," locationValue], @"locationValue should return nil");
}

- (void)testStringDateValue
{
    NSDate* date = [NSDate date]; // this is now in local time.
    NSLog(@"Expected: %@", date);
        
    // convert to GMT
    NSTimeZone* gmt = [NSTimeZone localTimeZone];
    NSDate* gmtDate = [date dateByAddingTimeInterval:-[gmt secondsFromGMT]];

    NSDateFormatter* f = [[[NSDateFormatter alloc] init] autorelease];
    f.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSSSSS";
    NSString* formattedDate = [f stringFromDate:gmtDate];
    NSLog(@"Expected: %@", formattedDate);
    
    //@"2011-03-08 14:30:25.781325"
    NSDate* actualDate = [formattedDate dateValue];
    NSLog(@"Actual: %@", actualDate);
    STAssertTrue([actualDate timeIntervalSinceDate:date] < 60, @"Actual=%@ expected=%@", actualDate, date);
}

@end
