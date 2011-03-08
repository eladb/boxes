//
//  BZUser.m
//  boxes
//
//  Created by eladb on 3/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BZUser.h"

static NSString* const kUserTokenDefaultsKey = @"userToken";
static int kUserTokenLength = 6;

@interface BZUser (Private)

- (NSString*)generatedToken;

@end

@implementation BZUser

- (void)dealloc
{
    [cachedToken release];
    [super dealloc];
}

- (NSString*)token
{
    if (!cachedToken)
    {
        NSString* token = [[NSUserDefaults standardUserDefaults] objectForKey:kUserTokenDefaultsKey];
        if (!token)
        {
            token = [self generatedToken];
            NSLog(@"New user token: %@", token);
            [[NSUserDefaults standardUserDefaults] setValue:token forKey:kUserTokenDefaultsKey];
        }
        
        cachedToken = [token retain];
    }
    
    return cachedToken;
}

@end

@implementation BZUser (Private)

- (NSString*)generatedToken
{
    NSMutableString* result = [NSMutableString string];
    for (int i = 0; i < kUserTokenLength; ++i)
    {
        char nextChar = ('A' + arc4random() % ('Z'-'A'));
        [result appendFormat:@"%c", nextChar];
    }
    
    return result;
}

@end