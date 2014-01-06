//
//  TVAAmount.m
//  TVA
//
//  Created by loïc Abadie on 02/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TVAAmount.h"

@interface TVAAmount()
- (void)getTVAData;
- (void)archivingCustomData:(id)Data toFile:(NSString*)fileName;
- (id)unarchiveCustomData:(NSString*)path;
@end

@implementation TVAAmount
@synthesize currentTVA,
			lastSelection,
			_tvaList;

#define DATARESOURCE @"tvaList"

- (void)TVAAmountHaschanged:(NSUInteger)selection{
	if(selection > [_tvaList count]) return;
	currentTVA		= [[_tvaList objectAtIndex:selection] doubleValue];
	lastSelection	= selection;
}

- (void)addAmount:(double)amount{
	[_tvaList addObject: [NSNumber numberWithDouble: amount]];
	[self TVAAmountHaschanged: [_tvaList count]-1];
}

- (void)deleteAmount:(NSUInteger)indexe{
	[_tvaList removeObjectAtIndex:indexe];
	if(lastSelection >= [_tvaList count]){
		lastSelection--;
		[self TVAAmountHaschanged:lastSelection];
	}
}

#pragma mark archive
- (void)archivingTVA{
	NSArray* dataCustom = [NSArray arrayWithObjects:_tvaList, [NSNumber numberWithUnsignedInteger:lastSelection], nil];
	[self archivingCustomData:dataCustom toFile:DATARESOURCE];
}

- (void)getTVAData{
	NSArray* localData	= [self unarchiveCustomData:DATARESOURCE];
	
	if(!localData){
		NSString* path		= [[NSBundle mainBundle] pathForResource:DATARESOURCE ofType:@"plist"];
		_tvaList			= [[NSMutableArray alloc] initWithArray:[NSArray arrayWithContentsOfFile:path]];
	}
	else{
		_tvaList			= [[NSMutableArray alloc] initWithArray:[localData objectAtIndex:0]];
		lastSelection		= [[localData objectAtIndex:1] unsignedIntegerValue];
	}
}

- (void)archivingCustomData:(id)Data toFile:(NSString*)fileName{
	NSString *docsPath	= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];	
	[NSKeyedArchiver	archiveRootObject: Data
									toFile: [docsPath stringByAppendingPathComponent:fileName]];
}

- (id)unarchiveCustomData:(NSString*)path{
	NSString *docsPath	= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];	
	return [NSKeyedUnarchiver unarchiveObjectWithFile:[docsPath stringByAppendingPathComponent:path]];
}

#pragma mark alloc/dealloc
- (id) init{
	if(self = [super init])
		[self getTVAData];
	
	return self;
}

- (void)dealloc{
	[_tvaList release];
	[super dealloc];
}
@end
