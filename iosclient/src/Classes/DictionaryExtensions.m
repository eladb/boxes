//
//  DictionaryExtensions.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DictionaryExtensions.h"


@implementation NSDictionary (Extensions)

- (CLLocation*)locationForGeoPtKey:(NSString*)key
{
    NSString* geoptString = [self objectForKey:key];
    if (!geoptString) return nil;
    
    NSArray* components = [geoptString componentsSeparatedByString:@","];
    NSString* latitudeString = [components objectAtIndex:0];
    NSString* longitudeString = [components objectAtIndex:1];
    if (!latitudeString || !longitudeString) return nil;
    
    return [[[CLLocation alloc] initWithLatitude:[latitudeString doubleValue] longitude:[longitudeString doubleValue]] autorelease];
}

- (void)setLocation:(CLLocation*)location forKey:(NSString*)key
{
    NSString* value = [NSString stringWithFormat:@"%g,%g",location.coordinate.latitude,location.coordinate.longitude];
    [self setValue:value forKey:key];
}

@end
