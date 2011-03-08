//
//  DictionaryExtensions.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface NSDictionary (Extensions)

- (CLLocation*)locationForGeoPtKey:(NSString*)key;
- (void)setLocation:(CLLocation*)location forKey:(NSString*)key;

@end
