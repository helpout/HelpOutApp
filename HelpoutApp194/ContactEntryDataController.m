//
//  ContactEntryDataController.m
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/20/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "ContactEntryDataController.h"
#import "ContactEntry.h"

@interface ContactEntryDataController ()
- (void)initializeDefaultDataList;
@end

@implementation ContactEntryDataController

@synthesize masterContactEntryList = _masterContactEntryList;

- (void)initializeDefaultDataList {
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    self.masterContactEntryList = contactList;
    [self addNewContactWithName:@"Jen" number:@"19144838934"];
}

- (void)setMasterContactEntryList:(NSMutableArray *)newList {
    if (_masterContactEntryList != newList) {
        _masterContactEntryList = [newList mutableCopy];
    }
}

- (NSUInteger)countOfList {
    return [self.masterContactEntryList count];
}

- (ContactEntry *)objectInListAtIndex:(NSUInteger)theIndex {
    return [self.masterContactEntryList objectAtIndex:theIndex];
}


- (void)addNewContactWithName:(NSString *)inputName number:(NSString *)inputNumber {
    ContactEntry *contact;
    contact = [[ContactEntry alloc] initWithName:inputName number:inputNumber];
    [self.masterContactEntryList addObject:contact];
}

- (id)init {
    if (self = [super init]) {
        [self initializeDefaultDataList];
        return self;
    }
    return nil;
}

@end
