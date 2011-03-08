//
//  BZUser.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BZUser : NSObject 
{
    NSString* cachedToken;
}

@property (nonatomic, readonly) NSString* token;

@end
