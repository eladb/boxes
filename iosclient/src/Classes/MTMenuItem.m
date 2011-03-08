//
//  MenuItem.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MTMenuItem.h"

@implementation MTMenuItem

@synthesize title;
@synthesize image;

- (void)dealloc
{
    [title release];
    [image release];
    [selectorTarget release];
    [navigationController release];
    [viewController release];
    [super dealloc];
}

- (id)initWithTitle:(NSString*)itemTitle
{
    return [self initWithTitle:itemTitle andImage:nil];
}

+ (id)itemWithTitle:(NSString*)itemTitle
{
    return [[[MTMenuItem alloc] initWithTitle:itemTitle] autorelease];
}

- (id)initWithTitle:(NSString*)itemTitle andImage:(UIImage*)aImage
{
    if (self = [super init])
    {
        title = [itemTitle retain];
        image = [aImage retain];
    }
    return self;
}

+ (id)itemWithTitle:(NSString*)itemTitle andImage:(UIImage*)aImage
{
    return [[[MTMenuItem alloc] initWithTitle:itemTitle andImage:aImage] autorelease];
}

// performs the action associated with the item (either navigate via the navigation controller or execute the selector)
- (void)performAction
{
    if (self.isNavigation)
    {
        [navigationController pushViewController:viewController animated:YES];
    }
    else if (selectorTarget) 
    {
        [selectorTarget performSelector:selector];
    }
}

- (void)designCell:(UITableViewCell*)cell
{
    // set the title
    cell.textLabel.text = self.title;
    
    if (image)
    {
        cell.imageView.image = image;
    }
    
    // if this is a navigation item, add a disclosure indicator
    if (self.isNavigation)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
}

@end

@implementation MTMenuItem (Action)

// item will perform an action
- (id)initWithTitle:(NSString*)itemTitle target:(id)aSelectorTarget selector:(SEL)aSelector;
{
    return [self initWithTitle:itemTitle image:nil target:aSelectorTarget selector:aSelector];
}

+ (id)itemWithTitle:(NSString*)itemTitle target:(id)aSelectorTarget selector:(SEL)aSelector
{
    return [[[MTMenuItem alloc] initWithTitle:itemTitle target:aSelectorTarget selector:aSelector] autorelease];
}

- (id)initWithTitle:(NSString*)itemTitle image:(UIImage*)aImage target:(id)aSelectorTarget selector:(SEL)aSelector
{
    if (self = [self initWithTitle:itemTitle andImage:aImage])
    {
        selector = aSelector;
        selectorTarget = [aSelectorTarget retain];
    }
    return self;
}

+ (id)itemWithTitle:(NSString*)itemTitle image:(UIImage*)aImage target:(id)aSelectorTarget selector:(SEL)aSelector
{
    return [[[MTMenuItem alloc] initWithTitle:itemTitle image:aImage target:aSelectorTarget selector:aSelector] autorelease];
}


- (BOOL)isAction
{
    return selectorTarget != nil;
}

@end

@implementation MTMenuItem (Navigation)

- (BOOL)isNavigation
{
    return viewController != nil;
}

// item will cause navigation to another view controller
- (id)initWithTitle:(NSString*)itemTitle navigateTo:(UIViewController*)aViewController viaController:(UINavigationController*)aNavigationController
{
    return [self initWithTitle:itemTitle image:nil navigateTo:aViewController viaController:aNavigationController];
}

+ (id)itemWithTitle:(NSString*)itemTitle navigateTo:(UIViewController*)aViewController viaController:(UINavigationController*)aNavigationController
{
    return [[[MTMenuItem alloc] initWithTitle:itemTitle navigateTo:aViewController viaController:aNavigationController] autorelease];
}

- (id)initWithTitle:(NSString*)itemTitle image:(UIImage*)aImage navigateTo:(UIViewController*)aViewController viaController:(UINavigationController*)aNavigationController
{
    if (self = [self initWithTitle:itemTitle andImage:aImage])
    {
        navigationController = [aNavigationController retain];
        viewController = [aViewController retain];
    }
    return self;
}

+ (id)itemWithTitle:(NSString*)itemTitle image:(UIImage*)aImage navigateTo:(UIViewController*)aViewController viaController:(UINavigationController*)aNavigationController
{
    return [[[MTMenuItem alloc] initWithTitle:itemTitle image:aImage navigateTo:aViewController viaController:aNavigationController] autorelease];
}

@end
