//
//  ContactEntry.h
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/20/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactEntry : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *number;

-(id)initWithName:(NSString *)name number:(NSString *)number;


@end
