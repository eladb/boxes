//
//  MenuSection.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MTMenuSection.h"

@implementation MTMenuSection

@synthesize title;
@synthesize menuItems;

- (void)dealloc
{
    [title release];
    [menuItems release];
    [super dealloc];
}

- (id)initWithTitle:(NSString*)sectionTitle
{
    if (self = [super init])
    {
        title = [sectionTitle retain];
        menuItems = [NSMutableArray new];
    }
    
    return self;
}

+ (id)sectionWithTitle:(NSString*)sectionTitle
{
    return [[[MTMenuSection alloc] initWithTitle:sectionTitle] autorelease];
}

- (void)addItem:(MTMenuItem*)newItem
{
    [menuItems addObject:newItem];
}

@end
