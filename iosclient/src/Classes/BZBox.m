//
//  BZBox.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZBox.h"
#import "BZAppDelegate.h"
#import "NSString+Extensions.h"

@interface BZBox (Private)

- (id)initWithBoxId:(NSString*)aBoxId 
       dropLocation:(CLLocation*)aDropLocation 
        dropMessage:(NSString*)aDropMessage 
     pickupLocation:(CLLocation*)aPickupLocation;

@end


@implementation BZBox

@synthesize dropLocation;
@synthesize boxId;
@synthesize dropMessage;
@synthesize pickupLocation;

- (void)dealloc
{
    [boxId release];
    [dropMessage release];
    [dropLocation release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

- (CLLocationDistance)distanceFromCurrentLocation
{
    CLLocation* currentLocation = [[[BZAppDelegate app] location] currentLocation];
    return [currentLocation distanceFromLocation:dropLocation];
}

- (BOOL)isDropped
{
    return (pickupLocation == nil);
}

@end

@implementation BZBox (Dictionary)

+ (id)boxFromDictionary:(NSDictionary*)dict
{
    NSString* boxid = [dict objectForKey:@"boxid"];
    if (!boxid) return nil;
    
    NSString* message = [dict objectForKey:@"drop_message"];
    
    CLLocation* dropLocation = [[dict objectForKey:@"drop_location"] locationValue];
    CLLocation* pickupLocation = [[dict objectForKey:@"picked_at"] locationValue];
    
    return [[[BZBox alloc] initWithBoxId:boxid dropLocation:dropLocation dropMessage:message pickupLocation:pickupLocation] autorelease];
}

@end

@implementation BZBox (History)

- (NSArray*)history
{
    return history;
}

// loads the box history and calls this callback when completed.
- (void)loadHistoryWithCompletionBlock:(void(^)(void))finishedBlock failedBlock:(ASIBasicBlock)failedBlock
{
    NSString* query = [NSString stringWithFormat:@"history?boxid=%@",self.boxId];
    ASIHTTPRequest* req = [[[BZAppDelegate app] backend] requestWithQuery:query];
    
    if (failedBlock) [req setFailedBlock:failedBlock];
    
    [req setCompletionBlock:^
     {
         NSDictionary* response = [[[BZAppDelegate app] backend] parsedResponse:req];
         NSLog(@"History: %@", response);
         
         // parse history
         NSArray* entries = [response objectForKey:@"history"];
         if (entries)
         {
             NSMutableArray* newHistory = [NSMutableArray array];
             for (NSDictionary* historyEntryDict in entries)
             {
                 BZBoxHistoryItem* item = [BZBoxHistoryItem fromDictionary:historyEntryDict];
                 [newHistory addObject:item];
             }
             
             [history release];
             history = [newHistory retain];
         }
         
         // call finished block if defined
         if (finishedBlock)  finishedBlock();
     }];

    [req start];
}

@end

@implementation BZBox (Operations)

- (void)pickupWithCompletionBlock:(void(^)(NSString*))finishedBlock failedBlock:(ASIBasicBlock)failedBlock
{
    NSString* query = [NSString stringWithFormat:@"pickup?boxid=%@",self.boxId];
    ASIHTTPRequest* req = [[[BZAppDelegate app] backend] requestWithQuery:query];
    if (failedBlock) [req setFailedBlock:failedBlock];
    [req setCompletionBlock:^
     {
         NSString* pickupMessage = [req responseString];

         // refresh history and call callback only after we have a refreshed history that now contains the pickup.
         [self loadHistoryWithCompletionBlock:^ { if (finishedBlock) finishedBlock(pickupMessage); } failedBlock:failedBlock];
     }];
    
    [req start];
}

- (void)dropAtLocation:(CLLocation*)location andMessage:(NSString*)message WithCompletionBlock:(void(^)(NSString*))finishedBlock failedBlock:(ASIBasicBlock)failedBlock
{
    NSString* query = [NSString stringWithFormat:@"drop?boxid=%@&lat=%g&long=%g&message=%@",self.boxId, location.coordinate.latitude, location.coordinate.longitude, message];
    ASIHTTPRequest* req = [[[BZAppDelegate app] backend] requestWithQuery:query];
    if (failedBlock) [req setFailedBlock:failedBlock];
    [req setCompletionBlock:^
     {
         NSString* message = [req responseString];
         
         // refresh history and call callback only after we have a refreshed history that now contains the pickup.
         [self loadHistoryWithCompletionBlock:^ { if (finishedBlock) finishedBlock(message); } failedBlock:failedBlock];
     }];
    
    [req start];
}

@end

@implementation BZBox (Private)

- (id)initWithBoxId:(NSString*)aBoxId dropLocation:(CLLocation*)aDropLocation dropMessage:(NSString*)aDropMessage pickupLocation:(CLLocation*)aPickupLocation
{
    if (self = [super init])
    {
        boxId = [aBoxId retain];
        dropLocation = [aDropLocation retain];
        dropMessage = [aDropMessage retain];
        pickupLocation = [aPickupLocation retain];
    }
    return self;
}

@end