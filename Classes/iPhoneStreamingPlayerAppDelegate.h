//
//  iPhoneStreamingPlayerAppDelegate.h
//  iPhoneStreamingPlayer
//
//  Created by Matt Gallagher on 28/10/08.
//  Copyright Matt Gallagher 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iPhoneStreamingPlayerViewController;
@class FirstLaunchViewController;

@interface iPhoneStreamingPlayerAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	iPhoneStreamingPlayerViewController *viewController;
	BOOL firstLaunch;
	NSMutableURLRequest *theRequest;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPhoneStreamingPlayerViewController *viewController;
@property (nonatomic, retain) FirstLaunchViewController *firstLaunchViewController;

-(void)sendProviderDeviceToken:(NSString*)devTokenBytes;
@end

