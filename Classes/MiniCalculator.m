//
//  MiniCalculator.m
//  TVA
//
//  Created by loïc Abadie on 02/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MiniCalculator.h"
#include <math.h>
#include "CcalculetTag.h"

@interface MiniCalculator()
- (void) makeStringChangewithTag:(ccustomCalculetTag)tag;
@property (nonatomic, assign) ccustomCalculetTag lastAction;
@property (nonatomic, retain) NSString* _computeValue;
@property (nonatomic, retain) NSString* _stackValue;
@property (nonatomic, retain) NSString* _redoValue;
@end

@implementation MiniCalculator
@synthesize		displayValue,
				_computeValue,
				_stackValue,
				_redoValue,
				lastAction;

#define OUTPUTFORMAT @"%.12lf"
#define INPUTVOID @""

#pragma mark calculator
- (void)addMutableNumber:(NSString*)number{
	[self set_computeValue: [_computeValue stringByAppendingString:number]];
	[self			setDisplayValue: [NSString stringWithString:_computeValue]];
}

- (void)equal{
	static ccustomCalculetTag redoAction = 0;
	
	switch (lastAction) {
		case CLPLUS:		[self add];			break;
		case CLMINUS:		[self minus];		break;
		case CLMULTIPLY:	[self multiply];	break;
		case CLDIVIDE:		[self divide];		break;
		case CLMATCH:		[self set_computeValue:  [NSString stringWithString:_redoValue]];
							switch (redoAction) {
									case CLPLUS:		[self add];			break;
									case CLMINUS:		[self minus];		break;
									case CLMULTIPLY:	[self multiply];	break;
									case CLDIVIDE:		[self divide];		break;
                                    default: break;
							}
        default: break;
	}
	
	redoAction = lastAction;
	lastAction = CLMATCH;
}

- (void)add{
	[self set_stackValue: [NSString stringWithFormat: OUTPUTFORMAT, [_computeValue doubleValue] + [_stackValue doubleValue]]];
	[self makeStringChangewithTag: CLPLUS];
}

- (void)erase{
	[self set_stackValue: INPUTVOID];
	[self makeStringChangewithTag: CLERASE];
}

- (void)minus{
	if([_computeValue isEqualToString:INPUTVOID]){
		_computeValue	= @"-0";
		[self	setDisplayValue: [NSString stringWithString:_computeValue]];
			if(lastAction == CLMATCH) lastAction = CLMINUS;
		return;
	}
	
	else if([_stackValue isEqualToString:INPUTVOID]){
		[self	set_stackValue: _computeValue];
		[self makeStringChangewithTag: CLMINUS];
		return;
	}
	else{	
		[self	set_stackValue: [NSString stringWithFormat:OUTPUTFORMAT,[_stackValue doubleValue] - fabs([_computeValue doubleValue])]];
		[self makeStringChangewithTag: (lastAction == CLMATCH)? CLMINUS : lastAction];
	}
}

- (void)multiply{
	[self set_stackValue:  ([_stackValue doubleValue])? [NSString stringWithFormat: OUTPUTFORMAT,([_computeValue doubleValue])? [_stackValue doubleValue] * [_computeValue doubleValue] : [_stackValue doubleValue]] :
														[NSString stringWithFormat: OUTPUTFORMAT, [_computeValue doubleValue]]];
	[self makeStringChangewithTag: CLMULTIPLY];
}

- (void)divide{
	[self set_stackValue: ([_stackValue doubleValue])?	[NSString stringWithFormat: OUTPUTFORMAT, ([_computeValue doubleValue])? [_stackValue doubleValue] / [_computeValue doubleValue] : [_stackValue doubleValue]] :
														[NSString stringWithFormat: OUTPUTFORMAT, [_computeValue doubleValue]]];
	[self makeStringChangewithTag: CLDIVIDE];
}

#pragma mark private Methods
- (void) makeStringChangewithTag:(ccustomCalculetTag)tag{
	lastAction		= tag;
	[self			setDisplayValue: [NSString stringWithString:_stackValue]];
	[self			set_redoValue: [NSString stringWithString:_computeValue]];
	[self			set_computeValue: INPUTVOID];
}

#pragma mark init/dealloc
- (id)init{
	if(self = [super init]){
		_computeValue	= [[NSString alloc] init];
		_stackValue		= [[NSString alloc] init];
		_redoValue		= [[NSString alloc] init];
		displayValue	= [[NSString alloc] init];
	}
	return self;
}
- (void)dealloc{
	[displayValue	release];
	[_redoValue		release];
	[_computeValue	release];
	[_stackValue	release];	
	[super			dealloc];
}
@end
