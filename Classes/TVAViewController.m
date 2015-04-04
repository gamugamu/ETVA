//
//  TVAViewController.m
//  TVA
//
//  Created by loïc Abadie on 01/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TVAViewController.h"
#import "IButton.h"
#import "TVALogic.h"
#import "CcalculetTag.h"
#import "TVAAmount.h"
#import "tvaAddAmount.h"
#import "Colorize.h"
#import "Preference.h"
#include <math.h>

@interface TVAViewController()
- (void)displayOutput;
- (void)displayCompositeTVA;
- (void)displaySwitchedTVA;
- (uint)outputLenght;
- (void)decorateText;
- (void)popUpAndAppear:(UIView*)popView;
@property (nonatomic, retain)TVALogic* _tvaLogic;
@property (nonatomic, retain)TVAAmount* _tvaAmount;
@property (nonatomic, assign)uint pointPrecision;
@property (nonatomic, assign)BOOL isMax;
@property (nonatomic, assign)uint currentButtonPressed;

@end

@implementation TVAViewController
@synthesize _outputC,
			_tvaLogic,
			_buttonTVA,
			_tvaAmount,
			_TVAAMountLabel,
			_amountHt,
			_amountttc,
			_amounttva,
			_recapPrice,
			_currentTVAState,
			_recapTVA,
			_picker,
			_whoIam,
			pointPrecision,
			currentButtonPressed,
			isMax;

#define INFOTAXETAG 60
#define BGDINFOHT	61
#define BGDINFOTCT	62
#define TAG_MINIHT	30
#define TAG_MINITTC	31

#pragma mark buttons action

-(IBAction)tvaPressed:(id)sender{
	_tvaLogic.ttc				= !_tvaLogic.ttc;	
	[_buttonTVA setSelected:	  ![_buttonTVA isSelected]];
	[self displayCompositeTVA];
}

- (IBAction)addtvaPressed:(id)sender{
	tvaAddAmount* addAmount				= [[tvaAddAmount alloc] initWithTvaAmount: _tvaAmount];
	addAmount.modalTransitionStyle		= UIModalTransitionStyleFlipHorizontal;
    [self presentViewController: addAmount
                       animated: YES
                     completion: nil];
	[addAmount release];
}

- (IBAction)InfoPressed:(id)sender{
	_whoIam.alpha = 0;
	[self.view addSubview: _whoIam];
	[UIView animateWithDuration: 1
					 animations: ^{ _whoIam.alpha = .8;}];
}

- (IBAction)InfoDismissPressed:(id)sender{
	[UIView animateWithDuration: .5f
					 animations: ^{ _whoIam.alpha = 0;}
					 completion: ^(BOOL finished) {[_whoIam removeFromSuperview];}];
}

#pragma mark display animation
- (void)popUpAndAppear:(UIView*)popView{
	[self.view addSubview: popView];
	popView.alpha = 0;
	[UIView animateWithDuration:.5f 
					 animations:^{popView.alpha = 1;}];
}

#pragma mark display Logic
- (void)viewWillAppear:(BOOL)animated{	
	[_picker	reloadAllComponents];
}

- (void)viewDidAppear:(BOOL)animated{
	NSUInteger current = _tvaAmount.lastSelection;
	[_picker	selectRow:current  inComponent:0 animated:YES];
	[_tvaAmount TVAAmountHaschanged: current];
	[self		displaySwitchedTVA];
	[self		displayCompositeTVA];
}

- (void)viewDidLoad {
	_tvaLogic								= [[TVALogic alloc] initWithTVA: _tvaAmount = [[TVAAmount alloc] init]];
	[[NSNotificationCenter defaultCenter]	addObserver:self selector:@selector(getName:) name:IBUTTONNAME object:nil];
	[self									decorateText];
	
	//if([FirstTime isFirstTime])				[self.view	addSubview: [_helpViewManager display]];
    [super									viewDidLoad];
}

#define POINTFORMAT @"."
#define LENGHTLIMIT 9
#define FLOATLIMIT 3
#define MAXVALUE	9999999999
#define MAXDISPLAYVALUE	@"9999999999"
#define MAXDISPLAYPOINTVALUE	@"9999999.99"
#define MAXDISPLAYPOINTMINUSVALUE	@"99999999.9"

#define showPressedButton(){\
	currentButtonPressed = value;\
	[self.view viewWithTag:value].alpha = .3f;\
}
- (void)getName:(NSNotification*)notification{
	uint value				= [[notification object] intValue];
	static int lastValue	= 100;
	
	if([self outputLenght] > LENGHTLIMIT && (value < CLPOINT && lastValue < CLPOINT))			return; // output lenght must not exceed LENGHLIMIT, exept if you erase it
	if(pointPrecision >= FLOATLIMIT && value < CLPOINT)											return; // you can't add more than FLOATLIMIT float numbers, but you can use others buttons modifier
	if(pointPrecision && value == CLPOINT)														return; // you can't press anymore on Float Point Button if you're already on point mode.
	if(value > CLPOINT && (lastValue > CLPOINT && (value != CLERASE && value != CLMINUS)))		return; // you can't press two times on the same button modifier exept for erasing data;
	if([_tvaLogic.displayValue doubleValue] > MAXVALUE && value != CLERASE)						return; // you can't pass if we are at max value
	
	[self.view viewWithTag:currentButtonPressed].alpha = 1;
	switch (value) {
		case		CLPOINT:	pointPrecision++;
								[_tvaLogic addMutableNumber:POINTFORMAT];
								showPressedButton();						break;
		case		CLMATCH:	[_tvaLogic equal];							break;
		case		CLPLUS:		[_tvaLogic add];							break;
		case		CLMINUS:	[_tvaLogic minus];							
								showPressedButton();						break;
		case		CLMULTIPLY:	[_tvaLogic multiply];
								showPressedButton();						break;
		case		CLDIVIDE:	[_tvaLogic divide];							
								showPressedButton();						break;
		case		CLERASE:	[_tvaLogic erase];							break;
		default:	(pointPrecision)? pointPrecision++ : 0;
					[_tvaLogic addMutableNumber: [notification object]];	break;
	}
	
	if(value > CLPOINT)		pointPrecision = 0;
	if(pointPrecision >= FLOATLIMIT) pointPrecision = FLOATLIMIT;

	lastValue		= (value != CLMATCH)? value : -1;
	[self			displayOutput];
	[self			displayCompositeTVA];
}

- (void)displaySwitchedTVA{
	static BOOL isTTC			= YES;
	
	if(isTTC == _tvaLogic.ttc)	return;
	_currentTVAState.text								= (isTTC)? @"ht": @"ttc";
	_recapTVA.text										= (isTTC)? @"ht": @"ttc";
	[self.view viewWithTag:BGDINFOHT].backgroundColor	= (!isTTC)? [UIColor clearColor]:[Colorize swatch: LIGHTORANGE];
	[self.view viewWithTag:BGDINFOTCT].backgroundColor	= (isTTC)? [UIColor clearColor]:[Colorize swatch: LIGHTORANGE];
	UIButton* htminiBtn			= (UIButton*)[self.view viewWithTag:TAG_MINIHT];
	UIButton* ttcminiBtn		= (UIButton*)[self.view viewWithTag:TAG_MINITTC];
	[htminiBtn setSelected:		isTTC];
	[ttcminiBtn setSelected:	!isTTC];
	isTTC						= _tvaLogic.ttc;
}

#define MUTABLEDISPLAYFORMAT static NSString *formats[]	= {@"%.0f", @"%.0f", @"%.1f", @"%.2f", @"%.2f"}
- (void)displayOutput{
	MUTABLEDISPLAYFORMAT;
	NSString* amount				= [_tvaLogic displayValue];
	static uint	lastpointPrecision	= 0;
	
	if([amount doubleValue] >= MAXVALUE){
		_outputC.text					= MAXDISPLAYVALUE;
		isMax							= YES;
	}
	
	else {
		BOOL isFloat			= [amount rangeOfString:@"."].length;
		BOOL isFloatNull		= [amount rangeOfString:@".00"].length;
		if(!pointPrecision){
			if(isFloat)
				_outputC.text		= [NSString stringWithFormat:formats[(isFloatNull)? 0:FLOATLIMIT], [_tvaLogic.displayValue doubleValue]];
			else
				_outputC.text		= [NSString stringWithFormat:formats[0], [_tvaLogic.displayValue doubleValue]];
		}
		else{
			_outputC.text			= [NSString stringWithFormat:formats[pointPrecision], [_tvaLogic.displayValue doubleValue]];
			lastpointPrecision = pointPrecision;
		}
		isMax = NO;
	}
	// if it is a float
	if(_outputC.text.length > LENGHTLIMIT + 1){
		NSRange floatValue = [_outputC.text rangeOfString:@"."];
		floatValue.location++;
		floatValue.length = 2;
	
		if(lastpointPrecision == FLOATLIMIT)
			_outputC.text = MAXDISPLAYPOINTVALUE;
		
		else if(fabs([_outputC.text doubleValue]) < [MAXDISPLAYPOINTMINUSVALUE doubleValue])
			_outputC.text = [NSString stringWithFormat:formats[2], [_tvaLogic.displayValue doubleValue]];
			
		else
			_outputC.text = MAXDISPLAYPOINTMINUSVALUE;
		isMax = YES;
	}
	
	[_tvaLogic setDisplayValue: _outputC.text];
}

- (uint)outputLenght{
	MUTABLEDISPLAYFORMAT;
	return (uint)[[NSString stringWithFormat: formats[pointPrecision],
             [_tvaLogic.displayValue doubleValue]] length];
}

#define NULLDISPLAYFORMAT @"0"
- (void)displayCompositeTVA{
	float value = [_tvaLogic.displayValue floatValue];

	if(isMax){
		_amountHt.text		= @"max";
		_amountttc.text		= @"max";
		_amounttva.text		= @"max";
		_recapPrice.text	= @"max";
		
	}
	else if(value <= 0){
		_amountHt.text		= @"0";
		_amountttc.text		= @"0";
		_amounttva.text		= @"0";
		_recapPrice.text	= @"0";
	}
	else{
		NSString* ttc		= [NSString stringWithFormat:PRICEFORMAT, [[_tvaLogic valueTTC] doubleValue]];
		NSString* ht		= [NSString stringWithFormat:PRICEFORMAT, [[_tvaLogic valueHT] doubleValue]];
		_amountHt.text		= ht;
		_amountttc.text		= ttc;
		_amounttva.text		= [NSString stringWithFormat:PRICEFORMAT, [_tvaLogic currentTva]];
		_recapPrice.text	= (_tvaLogic.ttc)? ttc: ht;
	}
	
	_TVAAMountLabel.text	= [NSString stringWithFormat:PRICEFORMATADD, _tvaAmount.currentTVA];
	[self displaySwitchedTVA];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	return 40.f;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	[_tvaAmount TVAAmountHaschanged:row];
	[self displayCompositeTVA];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	UILabel* pRow		= [[[UILabel alloc] init] autorelease];
	pRow.text			=  [NSString stringWithFormat:PRICEFORMATADD, [[[_tvaAmount _tvaList] objectAtIndex:row] doubleValue]];
	pRow.textAlignment	= NSTextAlignmentLeft;

	[pRow			setBackgroundColor: [UIColor clearColor]];
	[pRow			setFont: [UIFont fontWithName:POLICEH3 size:15.f]];
	[pRow			setTextColor: [Colorize swatch:MARINEBLUE]];
	[pRow			sizeToFit];

	return pRow;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [[_tvaAmount _tvaList] count];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[_tvaAmount archivingTVA];
}

- (void)decorateText{
	UILabel* change			= (UILabel*)[self.view viewWithTag:60];
	change.text				= @"€";
	[change					setFont: [UIFont fontWithName:POLICEH1 size:25.f]];
	[_currentTVAState		setFont: [UIFont fontWithName:POLICEH1 size:45.f]];
	[_TVAAMountLabel		setFont: [UIFont fontWithName:POLICEH1 size:15.f]];
	[_recapPrice			setFont: [UIFont fontWithName:POLICEH1 size:45.f]];
	[_recapTVA				setFont: [UIFont fontWithName:POLICEH1 size:14.f]];
	[_amountHt				setFont: [UIFont fontWithName:POLICEH2 size:13.f]];
	[_amountttc				setFont: [UIFont fontWithName:POLICEH2 size:13.f]];
	[_amounttva				setFont: [UIFont fontWithName:POLICEH2 size:13.f]];
}

- (void)viewDidUnload {
	[[NSNotificationCenter defaultCenter]	removeObserver:self];
	_recapPrice			= nil;
	_amounttva			= nil;
	_TVAAMountLabel		= nil;
	_amountttc			= nil;
	_amountHt			= nil;
	_tvaAmount			= nil;
	_buttonTVA			= nil;
	_tvaLogic			= nil;
	_outputC			= nil;
	_currentTVAState	= nil;
	_recapTVA			= nil;
	_picker				= nil;
}


- (void)dealloc {
	[_whoIam			release];
	[_picker			release];
	[_recapTVA			release];
	[_currentTVAState	release];
	[_recapPrice		release];
	[_amounttva			release];
	[_TVAAMountLabel	release];
	[_amountttc			release];
	[_amountHt			release];
	[_tvaAmount			release];
	[_buttonTVA			release];
	[_tvaLogic			release];
	[_outputC			release];
    [super				dealloc];
}

@end
