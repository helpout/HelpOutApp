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
#import "ASIFormDataRequest.h"

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
    
    playButton.enabled = NO;
    stopButton.enabled = NO;
    
    NSArray *dirPaths;
    NSString *docsDir;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"sound.wav"];
    
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
        NSHTTPURLResponse *response;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *stringResponse = [[NSString alloc] initWithData:urlData encoding:NSASCIIStringEncoding]; 
        NSLog(@"%@",stringResponse);
    }
    else {
        NSLog(@"They recorded a message");

        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        
        NSString* urlString = @"http://jennifergoett.com/helpout_tests/audiotest.php";
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        
        NSMutableData *body = [NSMutableData data];
        
        //sound file
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"data\"; filename=\"%@.wav\"\r\n", user] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithContentsOfURL:audioRecorder.url]];
        [body appendData:[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

        
        //text
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString: user] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString: @"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //close the form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
          
        
        // set request body
        [request setHTTPBody:body];
        
        // send the request (submit the form) and get the response
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@", returnString);
    }     
        
    [SVProgressHUD dismiss];
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
