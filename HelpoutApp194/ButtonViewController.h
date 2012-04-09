//
//  ButtonViewController.h
//  HelpoutApp194
//
//  Created by Jennifer Goett on 3/20/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface ButtonViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
    AVAudioRecorder *audioRecorder;
    AVAudioPlayer *audioPlayer;
}

@property (strong, nonatomic) IBOutlet UIButton *recordButton;
- (IBAction)startRecording;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;
- (IBAction)stopRecording;

@property (strong, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)playRecording;

@property (unsafe_unretained, nonatomic) BOOL hasRecordedAMessage;
@property (strong, nonatomic) NSString *soundFileURLPath;

- (IBAction)getHelp:(id)sender;

@end
