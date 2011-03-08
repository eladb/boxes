//
//  MenuItem.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MTMenuItem : NSObject 
{
    NSString* title;
    UIImage* image;
    
    // actionable item
    SEL selector;
    id selectorTarget;
    
    // navigation item
    UIViewController* viewController;
    UINavigationController* navigationController;
}

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) UIImage* image;

- (id)initWithTitle:(NSString*)itemTitle; 
+ (id)itemWithTitle:(NSString*)itemTitle;
- (id)initWithTitle:(NSString*)itemTitle andImage:(UIImage*)aImage;
+ (id)itemWithTitle:(NSString*)itemTitle andImage:(UIImage*)aImage;

// performs the action associated with the item (either navigate via the navigation controller or execute the selector)
- (void)performAction;

// changes the design of a cell for this item
- (void)designCell:(UITableViewCell*)cell;

@end

@interface MTMenuItem (Action)

@property (nonatomic, readonly) BOOL isAction;

// item will perform an action
- (id)initWithTitle:(NSString*)itemTitle target:(id)aSelectorTarget selector:(SEL)aSelector;
+ (id)itemWithTitle:(NSString*)itemTitle target:(id)aSelectorTarget selector:(SEL)aSelector;
- (id)initWithTitle:(NSString*)itemTitle image:(UIImage*)aImage target:(id)aSelectorTarget selector:(SEL)aSelector;
+ (id)itemWithTitle:(NSString*)itemTitle image:(UIImage*)aImage target:(id)aSelectorTarget selector:(SEL)aSelector;

@end

@interface MTMenuItem (Navigation)

@property (nonatomic, readonly) BOOL isNavigation;

// item will cause navigation to another view controller
- (id)initWithTitle:(NSString*)itemTitle navigateTo:(UIViewController*)aViewController viaController:(UINavigationController*)aNavigationController;
+ (id)itemWithTitle:(NSString*)itemTitle navigateTo:(UIViewController*)aViewController viaController:(UINavigationController*)aNavigationController;
- (id)initWithTitle:(NSString*)itemTitle image:(UIImage*)aImage navigateTo:(UIViewController*)aViewController viaController:(UINavigationController*)aNavigationController;
+ (id)itemWithTitle:(NSString*)itemTitle image:(UIImage*)aImage navigateTo:(UIViewController*)aViewController viaController:(UINavigationController*)aNavigationController;

@end
