//
//  iPhoneStreamingPlayerViewController.m
//  iPhoneStreamingPlayer
//
//  Created by Matt Gallagher on 28/10/08.
//  Copyright Matt Gallagher 2008. All rights reserved.
//

#import "iPhoneStreamingPlayerViewController.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>


@implementation iPhoneStreamingPlayerViewController
@synthesize titleLabel,background, infoButton;

- (void)setButtonImage:(UIImage *)image
{
	[button.layer removeAllAnimations];
	[button setImage:image forState:0];
}

- (void)viewDidLoad
{
	
	UIImage *image = [UIImage imageNamed:@"playbutton.png"];
	titleLabel = [[UILabel alloc]init];
	titleLabel.text = @"Hollow Earth Radio!";
	titleLabel.hidden = false;
	titleLabel.textAlignment = NSTextAlignmentCenter;
	[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
	titleLabel.frame = CGRectMake(10,5,300,25);
	titleLabel.textColor = [UIColor blackColor];
	titleLabel.backgroundColor = [UIColor clearColor];
	infoButton.frame = CGRectMake(290, 420, 30, 30);
	
	[self.view addSubview:titleLabel];
	[self setButtonImage:image];
	[background setImage:[UIImage imageNamed:@"es4.png"]];
	//[self.view addSubview:infoButton];
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
}

- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [button frame];
	button.layer.anchorPoint = CGPointMake(0.5, 0.5);
	button.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
	
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
	
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[button.layer addAnimation:animation forKey:@"rotationAnimation"];
	
	[CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self spinButton];
	}
}
- (IBAction)infoButtonPressed:(id)sender {
	NSLog(@"test");
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
	if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause ) {
		[self buttonPressed:nil];
	}
}

-(BOOL)canBecomeFirstResponder {
	return YES;
}


- (IBAction)buttonPressed:(id)sender
{
	
	if (!streamer)
	{
		NSURL *url = [NSURL URLWithString:@"http://67.212.189.10:9042/"];
		streamer = [[AudioStreamer alloc] initWithURL:url];
		streamer.uiController = self;
		
		titleLabel.text = @"Starting radio ...";
		
		[background setImage:[UIImage imageNamed:@"es-final.png"]];
		
		// load all the frames of our animation
		background.animationImages = [NSArray arrayWithObjects:
																	[UIImage imageNamed:@"es4.png"],
																	[UIImage imageNamed:@"es4-2.png"],
																	[UIImage imageNamed:@"es4-3.png"],
																	[UIImage imageNamed:@"es4-4.png"],
																	[UIImage imageNamed:@"es4-5.png"],
																	[UIImage imageNamed:@"es4-6.png"],
																	[UIImage imageNamed:@"es4-7.png"],
																	[UIImage imageNamed:@"es-final.png"], nil];
		
		// all frames will execute in 1.75 seconds
		background.animationDuration = 1;
		// repeat the annimation forever
		background.animationRepeatCount = 1;
		// start animating
		[background startAnimating];
		
		[streamer
		 addObserver:self
		 forKeyPath:@"isPlaying"
		 options:0
		 context:nil];
		[streamer start];
		
		[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
		
		[self spinButton];
	}
	else
	{
		[button.layer removeAllAnimations];
		[titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20]];
		titleLabel.text = @"Hollow Earth Radio!";
		// load all the frames of our animation
		[background setImage:[UIImage imageNamed:@"es4.png"]];
		
		background.animationImages = [NSArray arrayWithObjects:
																	[UIImage imageNamed:@"es-final.png"],
																	[UIImage imageNamed:@"es4-7.png"],
																	[UIImage imageNamed:@"es4-6.png"],
																	[UIImage imageNamed:@"es4-5.png"],
																	[UIImage imageNamed:@"es4-4.png"],
																	[UIImage imageNamed:@"es4-3.png"],
																	[UIImage imageNamed:@"es4-2.png"],
																	[UIImage imageNamed:@"es4.png"],nil];
		
		// all frames will execute in 1.75 seconds
		background.animationDuration = 1;
		// repeat the annimation forever
		background.animationRepeatCount = 1;
		// start animating
		[background startAnimating];
		
		
		[streamer stop];
		
	}
	
	
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
												change:(NSDictionary *)change context:(void *)context
{
	if ([keyPath isEqual:@"isPlaying"])
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		if ([(AudioStreamer *)object isPlaying])
		{
			[self
			 performSelector:@selector(setButtonImage:)
			 onThread:[NSThread mainThread]
			 withObject:[UIImage imageNamed:@"stopbutton.png"]
			 waitUntilDone:NO];
		}
		else
		{
			[streamer removeObserver:self forKeyPath:@"isPlaying"];
			[streamer release];
			streamer = nil;
			
			[self
			 performSelector:@selector(setButtonImage:)
			 onThread:[NSThread mainThread]
			 withObject:[UIImage imageNamed:@"playbutton.png"]
			 waitUntilDone:NO];
		}
		
		[pool release];
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change
												context:context];
}

- (BOOL)textFieldShouldReturn:(UITextField *)sender
{
	[self buttonPressed:sender];
	return NO;
}

@end
