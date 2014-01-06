//
//  TVAAmount.h
//  TVA
//
//  Created by loïc Abadie on 02/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TVAAmount : NSObject{}
- (void)TVAAmountHaschanged:(NSUInteger)selection;
- (void)archivingTVA;
- (void)addAmount:(double)amount;
- (void)deleteAmount:(NSUInteger)indexe;
@property(nonatomic, readonly)double currentTVA;
@property(nonatomic, readonly)NSUInteger lastSelection;
@property(nonatomic, readonly)NSMutableArray* _tvaList;
@end
