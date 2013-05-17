//
//  iPhoneStreamingPlayerAppDelegate.m
//  iPhoneStreamingPlayer
//
//  Created by Matt Gallagher on 28/10/08.
//  Copyright Matt Gallagher 2008. All rights reserved.
//

#import "iPhoneStreamingPlayerAppDelegate.h"
#import "iPhoneStreamingPlayerViewController.h"

@implementation iPhoneStreamingPlayerAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize firstLaunchViewController;

static NSString *pushHost = @"http://yoda.blackpixel.com:3010";

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Override point for customization after app launch
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
	
	//[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}


- (void)dealloc {
	[viewController release];
	[window release];
	[super dealloc];
}

// Delegation methods
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
	NSString *dt = [devToken description], *cleanedUpString;
	cleanedUpString = [dt stringByReplacingOccurrencesOfString:@"<" withString:@""];
	cleanedUpString = [cleanedUpString stringByReplacingOccurrencesOfString:@">" withString:@""];
	cleanedUpString =   [cleanedUpString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSLog(@"cleanedUpString %@", cleanedUpString);
	
	[self sendProviderDeviceToken:(NSString*)cleanedUpString]; // custom method
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	NSLog(@"Error in registration. Error: %@", err);
}

-(void)sendProviderDeviceToken:(NSString*)_devTokenBytes {
	NSString *paramsString = [NSString stringWithFormat:@"udids/add_token?device_token=%@", _devTokenBytes];
	
	NSString *theUrlString =   [NSString stringWithFormat:@"%@/%@", pushHost, paramsString];
	NSURL *theURL = [NSURL URLWithString:theUrlString];
	theRequest = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0f];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[theRequest setValue:@"Lux iPhone Client" forHTTPHeaderField:@"User-Agent"];
	
	NSURLResponse *theResponse = NULL;
	NSError *theError = NULL;
	NSData *theResponseData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&theError];
	
	NSString *theResponseString = [[[NSString alloc] initWithData:theResponseData encoding:NSASCIIStringEncoding] autorelease];
	NSLog(@"RESPONSE : theResponseString %@", theResponseString);
	
}




@end
