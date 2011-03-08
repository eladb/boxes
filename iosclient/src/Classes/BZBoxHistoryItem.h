//
//  BZBoxHistoryItem.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BZBoxHistoryItem : NSObject 
{
    CLLocation* dropLocation;
    NSString* dropMessage;
    UIImage* dropImage;
    NSDate* dropTimestamp;
    NSString* nextPicker;
    NSDate* nextPickerTimestamp;
}

@property (nonatomic, retain) CLLocation* dropLocation;
@property (nonatomic, retain) NSString* dropMessage;
@property (nonatomic, retain) UIImage* dropImage;
@property (nonatomic, retain) NSDate* dropTimestamp;
@property (nonatomic, retain) NSString* nextPicker;
@property (nonatomic, retain) NSDate* nextPickerTimestamp;

@end

@interface BZBoxHistoryItem (Dictionary)

+ (BZBoxHistoryItem*)fromDictionary:(NSDictionary*)dict;

@end
