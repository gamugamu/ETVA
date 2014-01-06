//
//  TVALogic.m
//  TVA
//
//  Created by loïc Abadie on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TVALogic.h"
#import "TVAAmount.h"

@interface TVALogic()
- (NSString*)htFormat;
- (NSString*)ttcFormat;
- (double)tvaAdded;
@end

@implementation TVALogic
@synthesize ttc,
			tvaAmount;

#pragma mark TVAcalculator
#define TVAFORMAT @"%.2lf"

- (NSString*)TVAAmount{
	return (ttc)? [self ttcFormat]:[self htFormat];
}

- (NSString*)ttcFormat{
	double doubleValue = [super.displayValue doubleValue] + [self tvaAdded];
	return  [NSString stringWithFormat: TVAFORMAT, doubleValue];
}

- (NSString*)htFormat{
	double doubleValue = [super.displayValue doubleValue] / (tvaAmount.currentTVA / 100 +1);
	return  [NSString stringWithFormat: TVAFORMAT, doubleValue];
}

- (double)tvaAdded{
	return tvaAmount.currentTVA / 100 * [super.displayValue doubleValue];
}

- (double)tvaMinus{
	return [super.displayValue doubleValue] - [[self htFormat] doubleValue];
}

- (NSString*)valueHT{
	return (ttc)? super.displayValue : [self htFormat];
}

- (NSString*)valueTTC{
	return (ttc)? [self ttcFormat] : super.displayValue;
}

- (double)currentTva{
	return (ttc)? [self tvaAdded] : [self tvaMinus];
}

#pragma mark init/dealloc
- (id)initWithTVA:(TVAAmount*)amount{
	if(self = [super init]){
		tvaAmount = amount;
	}
	return self;
}
- (void)dealloc{
	
	[super			dealloc];
}
@end
