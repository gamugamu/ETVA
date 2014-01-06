//
//  IButton.m
//  TVA
//
//  Created by loïc Abadie on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "IButton.h"


@implementation IButton

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
	[[NSNotificationCenter defaultCenter] postNotificationName:IBUTTONNAME object: [[NSNumber numberWithInteger: [self tag]] stringValue]];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
}
@end
