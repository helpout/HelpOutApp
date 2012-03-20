//
//  ContactEntryDataController.h
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/20/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContactEntry;

@interface ContactEntryDataController : NSObject

@property (nonatomic, copy) NSMutableArray *masterContactEntryList;

- (NSUInteger)countOfList;

- (ContactEntry *)objectInListAtIndex:(NSUInteger)theIndex;

- (void)addNewContactWithName:(NSString *)inputName number:(NSString *)inputNumber;

@end
