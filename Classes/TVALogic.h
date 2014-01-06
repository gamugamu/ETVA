//
//  TVALogic.h
//  TVA
//
//  Created by loïc Abadie on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MiniCalculator.h"
@class TVAAmount;
@interface TVALogic : MiniCalculator
- (id)initWithTVA:(TVAAmount*)amount;
- (double)currentTva;
- (NSString*)TVAAmount;
- (NSString*)valueHT;
- (NSString*)valueTTC;
@property(nonatomic, assign)TVAAmount* tvaAmount;
@property(nonatomic, assign)BOOL ttc;
@end
