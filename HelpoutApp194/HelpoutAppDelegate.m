//
//  HelpoutAppDelegate.m
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/19/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "HelpoutAppDelegate.h"

@implementation HelpoutAppDelegate

@synthesize window = _window;

@synthesize loggedIn;
@synthesize username = _username;
@synthesize keychain = _keychain;

@synthesize myLocationManager = _myLocationManager;
@synthesize executingInBackground;

-(BOOL) isExecutingInBackground {
    return executingInBackground;
}

-(BOOL) isAlreadyLoggedIn {
    return loggedIn;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        sleep(2);
    // Override point for customization after application launch.
    NSLog(@"WHEEEEEEEEE");
    if ([CLLocationManager locationServicesEnabled]) {
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.myLocationManager.delegate=self;
        self.myLocationManager.purpose = @"To send location data to the server";
        [self.myLocationManager startUpdatingLocation];
        NSLog(@"Started monitoring location.");
        
    }
    else{
        NSLog(@"Location services not enabled.");
    }
    // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   // self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    self.executingInBackground = YES;
    
    NSLog(@"Stopping regular location updates.");
    [self.myLocationManager stopUpdatingLocation];
    [self.myLocationManager startMonitoringSignificantLocationChanges];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    self.executingInBackground = NO;
    
    NSLog(@"Starting regular location updates.");
    [self.myLocationManager stopMonitoringSignificantLocationChanges];
    [self.myLocationManager startUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    self.executingInBackground = NO;
    SEL mySelector = @selector(showLogin);
    [self performSelector:(mySelector) withObject:nil afterDelay:0];
}

- (void)showLogin {
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    UIViewController *loginController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    if (!self.isAlreadyLoggedIn) {
        [self.window.rootViewController presentModalViewController:loginController animated:YES];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void) locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    /*We received the new location*/
    
    if ([self isExecutingInBackground]) {
        /*We are in the background; send info to server*/
        NSLog(@"Operating in the background");
        //[self sendLocationToServer:newLocation];
    }
    else {
        /*We are in foreground; print the lat and lon in the labels*/
        NSLog(@"Operating in the foreground");
        
        if([self isAlreadyLoggedIn] && newLocation.horizontalAccuracy <= 100.0f) { 
            [self.myLocationManager stopUpdatingLocation]; 
        }
        else {
            [self sendLocationToServer:newLocation];
        }
        NSLog(@"Latitude = %f", newLocation.coordinate.latitude);
        NSLog(@"Longitude = %f", newLocation.coordinate.longitude);
    }
    
}


-(void) sendLocationToServer:(CLLocation *)location {
    // REMEMBER. We are running in the background if this is being executed.
    // We can't assume normal network access.
    // bgTask will be defined as an instance variable of type UIBackgroundTaskIdentifier
    
    // Note that the expiration handler block simply ends the task. It is important that we always
    // end tasks that we have started.  
    
    NSString *lat = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    
    // NSLog(@"Location post parameter string is %@", post_params);
    
    NSLog(@"in send location to server");
    
    NSURL *url = [NSURL URLWithString:@"http://afternoon-moon-5773.heroku.com/locations/updateFromPhone"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];;
    [request setHTTPBody:[[NSString stringWithFormat:@"&username=dbob&lon=%@&lat=%@", lon, lat] dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *stringResponse = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding]; 
    NSLog(@"%@",stringResponse);
    
}


@end
