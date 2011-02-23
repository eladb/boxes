//
//  boxesAppDelegate.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZAppDelegate.h"
#import "BZNearByView.h"
#import "BZNearByMapView.h"

@implementation BZAppDelegate

@synthesize window;
@synthesize location;
@synthesize settings;
@synthesize backend;

// dealloc
- (void)dealloc 
{
    [window release];
    [controller release];
    
    [location release];
    [settings release];
    [backend release];
    [super dealloc];
}

// called after the app finished launching
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    settings = [BZSettings new];
    location = [[BZLocation alloc] initWithSettings:settings];
    backend = [[BZBackend alloc] initWithSettings:settings andLocation:location];
    
    controller = [UITabBarController new];

    UINavigationController* listNavigation = [[[UINavigationController alloc] initWithRootViewController:[[BZNearByView new] autorelease]] autorelease];
    listNavigation.tabBarItem.title = @"List";
    
    UINavigationController* mapNavigation = [[[UINavigationController alloc] initWithRootViewController:[[BZNearByMapView new] autorelease]] autorelease];
    mapNavigation.tabBarItem.title = @"Map";
    
    [controller setViewControllers:[NSArray arrayWithObjects:listNavigation,mapNavigation,nil]];
                                    
    [window addSubview:controller.view];
    [window makeKeyAndVisible];
    
    return YES;
}

@end

@implementation BZAppDelegate (Instance)

// returns the single instance of the app delegate
+ (BZAppDelegate*)app
{
    BZAppDelegate* delegate = (BZAppDelegate*) [[UIApplication sharedApplication] delegate];
    NSAssert(delegate, @"delegate is still not initialized");
    return delegate;
}

@end
