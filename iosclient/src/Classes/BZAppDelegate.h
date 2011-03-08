//
//  boxesAppDelegate.h
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZLocation.h"
#import "BZSettings.h"
#import "BZBackend.h"

@interface BZAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow* window;
    BZLocation* location;
    BZBackend* backend;
    BZSettings* settings;
    UITabBarController* controller;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, readonly) BZLocation* location;
@property (nonatomic, readonly) BZSettings* settings;
@property (nonatomic, readonly) BZBackend* backend;

@end

@interface BZAppDelegate (Instance)

// returns the single instance of the app delegate
+ (BZAppDelegate*)app;

@end