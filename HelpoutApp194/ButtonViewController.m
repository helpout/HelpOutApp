//
//  ButtonViewController.m
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/20/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "ButtonViewController.h"
#import "SVProgressHUD.h"
#import "HelpoutAppDelegate.h"

@interface ButtonViewController ()

@end

@implementation ButtonViewController
@synthesize playButton;
@synthesize stopButton;
@synthesize recordButton;
@synthesize hasRecordedAMessage;
@synthesize soundFileURLPath;


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
    
    /////THIS IS WHERE I'LL ADD THE CODE FOR DISPLAYING THE INSTRUCTIONS SCREEN AT FIRST LAUNCH
    
    
    //#define kAppHasRunBeforeKey @"appFirstTimeRun"
   // if (![[[NSUserDefaults standardUserDefaults] valueForKey:kAppHasRunBeforeKey] boolValue]) { 
        //welcome code here -- see bookmarked links on how to do this
       // [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAppHasRunBeforeKey];
   // }
    
    
    ////THIS IS WHERE THAT ENDS
    
    playButton.enabled = NO;
    stopButton.enabled = NO;
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    soundFileURLPath = [soundFileURL absoluteString];
    
    NSDictionary *recordSettings = [NSDictionary 
                                    dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:AVAudioQualityMin],
                                    AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], 
                                    AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], 
                                    AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:44100.0], 
                                    AVSampleRateKey,
                                    nil];
    
    NSError *error = nil;
    
    audioRecorder = [[AVAudioRecorder alloc]
                     initWithURL:soundFileURL
                     settings:recordSettings
                     error:&error];
    
    if (error)
    {
        NSLog(@"error: %@", [error localizedDescription]);
        
    } else {
        [audioRecorder prepareToRecord];
    }

}

- (void)viewDidUnload
{
    [self setRecordButton:nil];
    [self setStopButton:nil];
    [self setPlayButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)startRecording {
    NSLog(@"Start recording");
    if (!audioRecorder.recording)
    {
        playButton.enabled = NO;
        stopButton.enabled = YES;
        [audioRecorder record];
    }

}

- (IBAction)stopRecording {
    NSLog(@"Stop recording");
    stopButton.enabled = NO;
    playButton.enabled = YES;
    recordButton.enabled = YES;
    
    if (audioRecorder.recording)
    {
        [audioRecorder stop];
    } else if (audioPlayer.playing) {
        [audioPlayer stop];
    }
    
    hasRecordedAMessage = YES;
}

- (IBAction)playRecording {
    NSLog(@"Play recording");
    if (!audioRecorder.recording)
    {
        stopButton.enabled = YES;
        recordButton.enabled = NO;
        
        //if (audioPlayer)
          //  [audioPlayer release];
        NSError *error;
        
        audioPlayer = [[AVAudioPlayer alloc] 
                       initWithContentsOfURL:audioRecorder.url                                    
                       error:&error];
        
        audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@", 
                  [error localizedDescription]);
        else
            [audioPlayer play];
    }

}

- (IBAction)getHelp:(id)sender {
    [SVProgressHUD show];
    
    HelpoutAppDelegate *appDelegate = (HelpoutAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *user = appDelegate.username;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    if (!hasRecordedAMessage) {
        NSLog(@"They haven't recorded a message");
        NSURL *url = [NSURL URLWithString:@"http://afternoon-moon-5773.heroku.com/mass_send_text"];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[[NSString stringWithFormat:@"&data=none"] dataUsingEncoding:NSUTF8StringEncoding]];    
        
    }
    else {
        NSLog(@"They recorded a message");
        
        //other way of doing this
        [request setURL:[NSURL URLWithString:@"http://afternoon-moon-5773.heroku.com/audios/create_from_phone"]];
        [request setHTTPMethod:@"POST"];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"recording\"; filename=\"recording.caf\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"&username=%@&data=%@", user, [NSData dataWithContentsOfFile:soundFileURLPath]] dataUsingEncoding:NSUTF8StringEncoding]];
        //[body appendData:];
        
        // set request body
        [request setHTTPBody:body];
        NSLog(@"Request is %@", request);

        
        
        /*ORIGINAL WAY OF DOING THIS
        NSURL *url = [NSURL URLWithString:@"http://afternoon-moon-5773.heroku.com/audios/create_from_phone"];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        NSData *body = [NSData dataWithContentsOfFile:soundFileURLPath];
       // NSString *body = @"Random text here";
        NSLog(@"The file path (message) is %@", soundFileURLPath);
        [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[[NSString stringWithFormat:@"&username=%@&data=%@", user, body] dataUsingEncoding:NSUTF8StringEncoding]];
         */
    }

    NSHTTPURLResponse *response;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *stringResponse = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding]; 
    NSLog(@"%@",stringResponse);
        
    
    //[response statusCode] == 200 && 
    if (urlData != nil)
    {
        //it worked
        [SVProgressHUD dismiss];
    }
    else  // something went wrong
    {
        [SVProgressHUD dismissWithError:@"Error"];
    }
}


/*Delegate methods for audio recording
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player 
                      successfully:(BOOL)flag
{
    recordButton.enabled = YES;
    stopButton.enabled = NO;
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player 
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording: (AVAudioRecorder *)recorder 
                          successfully:(BOOL)flag
{
}

-(void)audioRecorderEncodeErrorDidOccur: (AVAudioRecorder *)recorder 
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}*/

@end
