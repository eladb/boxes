//
//  BZNearByView.h
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "BZBackend.h"

@interface BZPickupView : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate>
{
    NSArray* boxes;
    UITableView* boxesTableView;
}

@property (nonatomic, retain) IBOutlet UITableView* boxesTableView;

@end
