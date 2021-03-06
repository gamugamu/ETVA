//
//  RateMe.m
//  TVA
//
//  Created by loïc Abadie on 17/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RateMe.h"

@interface RateMe()<UIAlertViewDelegate>
+ (void)displayMessage:(NSDictionary*)info;
+ (void)checkKeysConformity:(NSDictionary*)info;
@end

#define REVIEWLINK						@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id="
#define RATEDONE						@"ReviewRequestReviewedForVersion"
#define RATEDONTBOTHERME				@"ReviewRequestDontAsk"
#define RATENEXTTIME					@"ReviewRequestNextTimeToAsk"
#define KeySessionCountSinceLastAsked	@"ReviewRequestSessionCountSinceLastAsked"
#define KEY_APPID						@"appId"
#define KEY_TITLE						@"title"
#define KEY_MESSAGE						@"message"
#define KEY_CONFIRM						@"confirmLabel"
#define KEY_CANCEL						@"cancelLabel"
#define KEY_INVALIDATE					@"invalidateLabel"

@implementation RateMe
#define TWODAYS	60*60*23*2
#define LATER	60*60*23

static NSString* appId;
+ (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	
	switch (buttonIndex){
		case 0: // remind me later
			[defaults setDouble:CFAbsoluteTimeGetCurrent()+LATER forKey: RATENEXTTIME];
			break;
			
		case 1: // rate it now
		{
			NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
			[defaults setValue:version forKey:RATEDONE];
			
			NSString* iTunesLink = [NSString stringWithFormat:@"%@%@", REVIEWLINK, appId];
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
			break;
		}
			
		case 2: // don't ask again
			[defaults setBool:YES forKey:RATEDONTBOTHERME];
			break;
		default:
			break;
	}
	
	[appId release];
}

+ (void)displayMessage:(NSDictionary*)info{
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle: [info objectForKey:KEY_TITLE]
													message: [info objectForKey:KEY_MESSAGE]
												   delegate: self 
										  cancelButtonTitle: [info objectForKey:KEY_CANCEL]
										  otherButtonTitles: [info objectForKey:KEY_CONFIRM],
															 [info objectForKey:KEY_INVALIDATE], nil];
	[alert show];
	[alert release];
}

+ (void)displayReviewMe:(NSDictionary*)userInfo{
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[RateMe checkKeysConformity: userInfo];

	if ([defaults boolForKey: RATEDONTBOTHERME])	return;
	
	NSString* version			= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	NSString* reviewedVersion	= [defaults stringForKey: RATEDONE];
	
	if ([reviewedVersion isEqualToString:version])	return;

	const double currentTime = CFAbsoluteTimeGetCurrent();
	
	if (![defaults objectForKey: RATENEXTTIME]){
		[defaults setDouble:currentTime + TWODAYS forKey:RATENEXTTIME];
		return;
	}

	double nextTime = [defaults doubleForKey:RATENEXTTIME];
	if (currentTime < nextTime)						return;
	
	[RateMe displayMessage: userInfo];
	appId = [[userInfo objectForKey: KEY_APPID] retain];
}

+ (void)checkKeysConformity:(NSDictionary*)info{
	NSSet* userKeys = [NSSet setWithArray: [info allKeys]];
	NSSet* conformSet = [NSSet setWithObjects: KEY_APPID, KEY_TITLE, KEY_MESSAGE, KEY_CONFIRM, KEY_CANCEL, KEY_INVALIDATE, nil];
	
	if(![userKeys isEqualToSet:conformSet])
		[NSException raise:@"Alert message - label conformity" format:@"one of these keys are missing %@", conformSet];
}

@end
