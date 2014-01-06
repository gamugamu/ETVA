//
//  MiniCalculator.h
//  TVA
//
//  Created by loïc Abadie on 02/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MiniCalculator : NSObject
- (void)addMutableNumber:(NSString*)number;
- (void)equal;
- (void)add;
- (void)minus;
- (void)multiply;
- (void)divide;
- (void)erase;
@property (nonatomic, retain) NSString* displayValue;
@end
