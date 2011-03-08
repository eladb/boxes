//
//  MTMenuTableView.h
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTMenuSection.h"
#import "MTMenuItem.h"

@interface MTMenuTableView : UITableView <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* sections;
}

@property (nonatomic, readonly) NSArray* sections;

- (void)addSection:(MTMenuSection*)newSection;
- (MTMenuSection*)addSectionWithTitle:(NSString*)title;

@end
