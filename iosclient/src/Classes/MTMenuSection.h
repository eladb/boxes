//
//  MenuSection.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTMenuItem.h"

@interface MTMenuSection : NSObject 
{
    NSString* title;
    NSMutableArray* menuItems;
}

@property (nonatomic, readonly) NSString* title;
@property (nonatomic, readonly) NSArray* menuItems;

- (id)initWithTitle:(NSString*)sectionTitle;
+ (id)sectionWithTitle:(NSString*)sectionTitle;

- (void)addItem:(MTMenuItem*)newItem;

@end
