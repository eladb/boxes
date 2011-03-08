//
//  BZDropContentView.h
//  boxes
//
//  Created by eladb on 3/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BZBox.h"

@interface BZDropContentView : UIViewController 
{
    UITextField* dropMessageText;
    BZBox* box;
}

@property (nonatomic, retain) IBOutlet UITextField* dropMessageText;
@property (nonatomic, retain) BZBox* box;

- (IBAction)dropClicked:(id)sender;

@end
