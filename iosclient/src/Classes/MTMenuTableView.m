//
//  MTMenuTableView.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MTMenuTableView.h"

static NSString *const kCellIdentifier = @"MTMenuTableViewCellIdentifier";

@implementation MTMenuTableView

@synthesize sections;

- (void)dealloc
{
    [sections release];
    [super dealloc];
}

- (void)addSection:(MTMenuSection*)newSection
{
    if (!sections)
    {
        sections = [NSMutableArray new];
    }
    
    if (!self.delegate)
    {
        self.delegate = self;
    }
    
    if (!self.dataSource)
    {
        self.dataSource = self;
    }
    
    [sections addObject:newSection];
}

- (MTMenuSection*)addSectionWithTitle:(NSString*)title
{
    MTMenuSection* newSection = [MTMenuSection sectionWithTitle:title];
    [self addSection:newSection];
    return newSection;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    MTMenuSection* s = [sections objectAtIndex:section];
    return s.title;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    MTMenuSection* s = [sections objectAtIndex:section];
    return s.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    MTMenuSection* section = [sections objectAtIndex:[indexPath section]];
    MTMenuItem* item = [section.menuItems objectAtIndex:[indexPath row]];
    
    [item designCell:cell];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTMenuSection* section = [sections objectAtIndex:[indexPath section]];
    MTMenuItem* item = [section.menuItems objectAtIndex:[indexPath row]];
    [item performAction];
}

@end
