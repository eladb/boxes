//
//  BZDropView.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface BZDropView : UIViewController <UITableViewDelegate, UITableViewDataSource, ASIHTTPRequestDelegate>
{
    UITableView* boxes;
    NSArray* myBoxes;
}

@property (nonatomic, retain) IBOutlet UITableView* boxes;

@end
