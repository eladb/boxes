//
//  boxesAppDelegate.m
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZAppDelegate.h"
#import "BZPickupView.h"
#import "BZDropView.h"
#import "BZDiagnosticsView.h"

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

    UINavigationController* pickupNav = [[[UINavigationController alloc] initWithRootViewController:[[BZPickupView new] autorelease]] autorelease];
    pickupNav.tabBarItem.title = @"Pick-up";
    pickupNav.tabBarItem.image = [UIImage imageNamed:@"06-magnify.png"];

    UINavigationController* dropNav = [[[UINavigationController alloc] initWithRootViewController:[[BZDropView new] autorelease]] autorelease];
    dropNav.tabBarItem.title = @"Drop";
    dropNav.tabBarItem.image = [UIImage imageNamed:@"07-map-marker.png"];
    
    UINavigationController* diagNav = [[[UINavigationController alloc] initWithRootViewController:[[BZDiagnosticsView new] autorelease]] autorelease];
    diagNav.tabBarItem.title = @"Diag";
    diagNav.tabBarItem.image = [UIImage imageNamed:@"20-gear2.png"];
    
    [controller setViewControllers:[NSArray arrayWithObjects:pickupNav,dropNav,diagNav,nil]];
                                    
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
