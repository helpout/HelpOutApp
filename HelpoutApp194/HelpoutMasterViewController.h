//
//  HelpoutMasterViewController.h
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/19/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface HelpoutMasterViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate>

- (IBAction)sendContactListToServer:(id)sender;

@end
