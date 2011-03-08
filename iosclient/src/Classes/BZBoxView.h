//
//  BZBoxView.h
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"
#import "BZBox.h"

@interface BZBoxView : UIViewController <ASIHTTPRequestDelegate, UITableViewDataSource, UITableViewDelegate>
{
    BZBox* box;

    UITextView* boxInfoTextView;
    UITableView* historyTable;
    MKMapView* historyMap;
    
    NSMutableArray* currentAnnotations;
}

@property (nonatomic, retain) IBOutlet UITextView* boxInfoTextView;
@property (nonatomic, retain) IBOutlet UITableView* historyTable;
@property (nonatomic, retain) IBOutlet MKMapView* historyMap;

@property (nonatomic, retain) BZBox* box;

- (IBAction)pickupClicked:(id)sender;
- (IBAction)dropClicked:(id)sender;

@end
