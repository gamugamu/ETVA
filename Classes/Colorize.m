//
//  Colorize.m
//  LCDRetro-Poo
//
//  Created by loïc Abadie on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Colorize.h"


@implementation Colorize

+ (UIColor*) swatch:(uint)color{
	switch (color) {
		case MARINEBLUE: return [UIColor colorWithRed:35.f/255.f green:38.f/255.f blue:56.f/255.f alpha:1]; break;
		case LIGHTBLUE: return [UIColor colorWithRed:31.f/255.f green:222.f/255.f blue:1 alpha:1]; break;
		case LIGHTORANGE: return [UIColor colorWithRed:1 green:190.f/255.f blue:0 alpha:1]; break;

		default: return 0;
	}
}
@end
