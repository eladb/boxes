//
//  BZBoxView.h
//  boxes
//
//  Created by eladb on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BZBoxView : UIViewController 
{
    UITextView* boxInfoTextView;
    NSString* boxId;
}

@property (nonatomic, retain) NSString* boxId;
@property (nonatomic, retain) IBOutlet UITextView* boxInfoTextView;

- (IBAction)pickupClicked:(id)sender;

@end
