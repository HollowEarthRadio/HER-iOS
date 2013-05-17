//
//  iPhoneStreamingPlayerViewController.h
//  iPhoneStreamingPlayer
//
//  Created by Matt Gallagher on 28/10/08.
//  Copyright Matt Gallagher 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AudioStreamer;

@interface iPhoneStreamingPlayerViewController : UIViewController
{
	IBOutlet UIButton *button;
	AudioStreamer *streamer;
	IBOutlet UIView *volumeSlider;
	IBOutlet UILabel *positionLabel;
	IBOutlet UILabel *titleLabel;
	IBOutlet UIImageView *background;
	IBOutlet UIButton *infoButton;
}

- (IBAction)buttonPressed:(id)sender;
- (IBAction)infoButtonPressed:(id)sender;

@property (nonatomic, retain)IBOutlet UILabel *titleLabel;
@property (nonatomic, retain)IBOutlet UIImageView *background;
@property (nonatomic, retain)IBOutlet UIButton *infoButton;



@end

