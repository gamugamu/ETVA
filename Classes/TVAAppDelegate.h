//
//  TVAAppDelegate.h
//  TVA
//
//  Created by loïc Abadie on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TVAViewController;

@interface TVAAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

