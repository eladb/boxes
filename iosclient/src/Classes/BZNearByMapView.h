//
//  BZNearByMapView.h
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ASIHTTPRequest.h"

@interface BZNearByMapView : UIViewController <ASIHTTPRequestDelegate, MKMapViewDelegate>
{
    MKMapView *mapView;
    NSMutableArray* currentAnnotations;
}

@property (nonatomic, retain) IBOutlet MKMapView* mapView;

@end
