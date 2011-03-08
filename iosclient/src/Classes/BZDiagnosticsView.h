//
//  DiagnosticsView.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTMenuTableView.h"

@interface BZDiagnosticsView : UIViewController 
{
    MTMenuTableView* menu;
}

@property (nonatomic, retain) IBOutlet MTMenuTableView* menu;

@end
