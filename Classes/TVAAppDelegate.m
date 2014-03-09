//
//  TVAAppDelegate.m
//  TVA
//
//  Created by loïc Abadie on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TVAAppDelegate.h"
#import "TVAViewController.h"
#import "RateMe.h"
#import "GGarchiver.h"

@interface TVAAppDelegate ()
@property(nonatomic, retain)TVAViewController *viewController;
- (void)transition:(UIView*)view;
@end

@implementation TVAAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self tvaControllerDependingOnIphoneSreenHeightSize];
	[self transition: viewController.view];
	[self.window addSubview: viewController.view];
    [self.window makeKeyAndVisible];

	[RateMe displayReviewMe: [GGarchiver unarchiveData: @"ReviewMe"]];

    return YES;
}

- (void)transition:(UIView*)view{
	view.alpha = 0;
	[UIView animateWithDuration:.5 animations:^(void) {view.alpha = 1;}];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[viewController applicationDidEnterBackground: application];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

#pragma mark -

- (void)tvaControllerDependingOnIphoneSreenHeightSize{
    self.viewController = [[TVAViewController alloc] initWithNibName:
                           IS_IPHONE_5? @"TVAViewController-568h" : @"TVAViewController"
                                                              bundle: nil];
    NSLog(@"---> %u", IS_IPHONE_5);
}
@end
