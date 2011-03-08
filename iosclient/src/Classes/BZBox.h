//
//  BZBox.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "BZBoxHistoryItem.h"

@interface BZBox : NSObject 
{
    CLLocation* dropLocation;
    CLLocation* pickupLocation;
    NSString* dropMessage;
    NSString* boxId;
    NSArray* history;
    BOOL isDropped;
}

@property (nonatomic, readonly) NSString* boxId;
@property (nonatomic, readonly) CLLocation* dropLocation;
@property (nonatomic, readonly) CLLocation* pickupLocation;
@property (nonatomic, readonly) NSString* dropMessage;
@property (nonatomic, readonly) CLLocationDistance distanceFromCurrentLocation;
@property (nonatomic, readonly) BOOL isDropped; // indicates if a box is currently dropped or picked up

@end

@interface BZBox (Dictionary)

+ (id)boxFromDictionary:(NSDictionary*)dict;

@end

@interface BZBox (History)

@property (nonatomic, readonly) NSArray* history;

// loads the box history and calls this callback when completed.
- (void)loadHistoryWithCompletionBlock:(void(^)(void))finishedBlock failedBlock:(ASIBasicBlock)failedBlock;

@end

@interface BZBox (Operations)

- (void)pickupWithCompletionBlock:(void(^)(NSString*))finishedBlock failedBlock:(ASIBasicBlock)failedBlock;
- (void)dropAtLocation:(CLLocation*)location andMessage:(NSString*)message WithCompletionBlock:(void(^)(NSString*))finishedBlock failedBlock:(ASIBasicBlock)failedBlock;

@end