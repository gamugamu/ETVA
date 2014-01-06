//
//  Colorize.h
//  LCDRetro-Poo
//
//  Created by loïc Abadie on 27/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Colorize : NSObject

typedef enum {
	MARINEBLUE,
	LIGHTBLUE,
	LIGHTORANGE
}colorPanel;

+ (UIColor*) swatch:(uint)color;
@end
