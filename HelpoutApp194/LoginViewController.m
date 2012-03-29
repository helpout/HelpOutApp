//
//  LoginViewController.m
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/20/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "LoginViewController.h"
#import "HelpoutAppDelegate.h"
#import "SVProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize username = _username;
@synthesize password = _password;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}




- (IBAction)setLoggedIn:(id)sender {
    HelpoutAppDelegate *appDelegate = (HelpoutAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *user = appDelegate.username;
    
    //send post request to database to check if the username and password entered are correct
    
    [SVProgressHUD show];
    
    NSURL *url = [NSURL URLWithString:@"URL-TO-SEND-DISTRESS-TEXT"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[[NSString stringWithFormat:@"msg=%@", user] dataUsingEncoding:NSUTF8StringEncoding]];
    NSHTTPURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *stringResponse = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding]; 
    NSLog(@"%@",stringResponse);
    
    
    if ([response statusCode] == 200 && urlData != nil)
    {
        //it worked
        [SVProgressHUD dismiss];
    }
    else  // something went wrong
    {
        [SVProgressHUD dismissWithError:@"Error"];
    }

    
    //if so, add the username and password to the keychain
    if ([self.username text])
        [appDelegate.keychain setObject:[self.username text] forKey:(__bridge id)kSecAttrAccount];
    if ([self.password text])
        [appDelegate.keychain setObject:[self.password text] forKey:(__bridge id)kSecValueData];    	    

    //and set loggedIn to yes
    if (self.username) {
        appDelegate.loggedIn = YES;
        appDelegate.username = [self.username text];
    }
    
    
}
@end
