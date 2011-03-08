//
//  BZBoxHistoryItem.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZBoxHistoryItem.h"
#import "DictionaryExtensions.h"
#import "NSString+Extensions.h"

@implementation BZBoxHistoryItem

@synthesize dropLocation;
@synthesize dropMessage;
@synthesize dropImage;
@synthesize dropTimestamp;
@synthesize nextPicker;
@synthesize nextPickerTimestamp;

- (void)dealloc
{
    [dropLocation release];
    [dropMessage release];
    [dropImage release];
    [dropTimestamp release];
    [nextPicker release];
    [nextPickerTimestamp release];
    [super dealloc];
}

@end

@implementation BZBoxHistoryItem (Dictionary)

+ (BZBoxHistoryItem*)fromDictionary:(NSDictionary*)dict
{
    BZBoxHistoryItem* newItem = [BZBoxHistoryItem new];
    if (!newItem) return nil;
    
    newItem.dropMessage = [dict objectForKey:@"drop_message"];
    newItem.dropLocation = [dict locationForGeoPtKey:@"drop_location"];
    newItem.dropImage = nil;
    newItem.dropTimestamp = [[dict objectForKey:@"drop_timestamp"] dateValue];
    newItem.nextPicker = [dict objectForKey:@"next_picker"];
    newItem.nextPickerTimestamp = [[dict objectForKey:@"next_picker_timestamp"] dateValue];
    
    return newItem;
}

@end