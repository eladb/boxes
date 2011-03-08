//
//  SimulateLocation.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"

@interface BZSimulateLocation : UIViewController <ASIHTTPRequestDelegate>
{
    MKMapView* map;
    UIButton* realLocationButton;
    NSMutableArray* currentAnnotations;
}

@property (nonatomic, retain) IBOutlet MKMapView* map;
@property (nonatomic, retain) IBOutlet UIButton* realLocationButton;

- (IBAction)realLocationClicked:(id)sender;

@end
