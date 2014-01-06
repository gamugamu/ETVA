//
//  tvaAddAmount.h
//  TVA
//
//  Created by loïc Abadie on 06/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVAAmount.h"

@interface tvaAddAmount : UIViewController
- (IBAction)goBack:(id)sender;
- (IBAction)deletePressed:(id)sender;
- (IBAction)addedPressed:(id)sender;
- (id)initWithTvaAmount:(TVAAmount*)tvaAmount;
@end
