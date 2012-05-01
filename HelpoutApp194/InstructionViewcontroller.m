//
//  InstructionViewcontroller.m
//  HelpoutApp194
//
//  Created by Jennifer Goett on 4/30/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "InstructionViewcontroller.h"

@interface InstructionViewcontroller ()

@end

@implementation InstructionViewcontroller

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
	// Do any additional setup after loading the view.
        [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"instructionscreen"]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
