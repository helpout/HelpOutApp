//
//  ContactEntry.m
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/20/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "ContactEntry.h"

@implementation ContactEntry

@synthesize name = _name, number = _number;


-(id)initWithName:(NSString *)name number:(NSString *)number {
    self = [super init];
    if (self) {
        _name = name;
        _number = number;
        return self;
    }
    return nil;
}

@end
