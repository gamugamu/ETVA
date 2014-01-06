//
//  TVAViewController.h
//  TVA
//
//  Created by loïc Abadie on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TVAViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIApplicationDelegate> {

}
- (IBAction)tvaPressed:(id)sender;
- (IBAction)addtvaPressed:(id)sender;
- (IBAction)InfoPressed:(id)sender;
- (IBAction)InfoDismissPressed:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel*			_outputC;
@property (nonatomic, retain) IBOutlet UILabel*			_TVAAMountLabel;
@property (nonatomic, retain) IBOutlet UILabel*			_amountHt;
@property (nonatomic, retain) IBOutlet UILabel*			_amountttc;
@property (nonatomic, retain) IBOutlet UILabel*			_recapPrice;
@property (nonatomic, retain) IBOutlet UILabel*			_recapTVA;
@property (nonatomic, retain) IBOutlet UILabel*			_amounttva;
@property (nonatomic, retain) IBOutlet UILabel*			_currentTVAState;
@property (nonatomic, retain) IBOutlet UIButton*		_buttonTVA;
@property (nonatomic, retain) IBOutlet UIPickerView*	_picker;
@property (nonatomic, retain) IBOutlet UIView*			_whoIam;

@end

