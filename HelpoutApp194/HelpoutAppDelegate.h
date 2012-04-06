//
//  HelpoutAppDelegate.h
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/19/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "KeychainItemWrapper.h"


@interface HelpoutAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, unsafe_unretained, getter=isAlreadyLoggedIn) BOOL loggedIn;
@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) KeychainItemWrapper *keychain;

@property (strong, nonatomic) CLLocationManager *myLocationManager;
@property (nonatomic, unsafe_unretained, getter=isExecutingInBackground) BOOL executingInBackground;
@property (nonatomic) UIBackgroundTaskIdentifier bgtask;

@end
