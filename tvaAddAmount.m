//
//  tvaAddAmount.m
//  TVA
//
//  Created by loïc Abadie on 06/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "tvaAddAmount.h"
#import "Preference.h"
#import "Colorize.h"

@interface tvaAddAmount()
- (BOOL)authorizeValue:(double)value;
- (void)callError:(NSString*)reason;
- (void)addTvaValue:(double)tvaValue;
@property(nonatomic, assign) TVAAmount* addedAmount;
@property(nonatomic, assign) UILabel* tvaAddedLabel;
@property(nonatomic, assign) UILabel* tvacurrentLabel;
@property(nonatomic, assign) UIPickerView* currentTvaPicker;
@end

@implementation tvaAddAmount
@synthesize addedAmount,
			tvaAddedLabel,
			tvacurrentLabel,
			currentTvaPicker;

#define PICKERCREATETVATAG 1
#define LABELTOTALTVATAG 2
#define LABELNEWTVATAG 3
#define PICKERCURRENTTVATAG 4
#define MAXTVALIST 30
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
	if(pickerView.tag == PICKERCREATETVATAG)	return 20.f;
	else										return 40.f;
}


static NSInteger newVat[2];
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	if(pickerView.tag == PICKERCREATETVATAG){
		newVat[component]	= row;
		tvaAddedLabel.text	= [NSString stringWithFormat:@"%ld.%.2ld%%", newVat[0], (long)newVat[1]];
	}
	
	else
		tvacurrentLabel.text	= [NSString stringWithFormat:PRICEFORMATADD, [[[addedAmount _tvaList] objectAtIndex:row] doubleValue]];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	UILabel* pRow	= [[[UILabel alloc] init] autorelease];
	[pRow			setBackgroundColor: [UIColor clearColor]];
	[pRow			setTextColor: [Colorize swatch:MARINEBLUE]];
	
	if(pickerView.tag == PICKERCREATETVATAG){
		pRow.font = [UIFont fontWithName:POLICEH4 size:22.f];
	 	pRow.text = [NSString stringWithFormat:@"%ld",(long)row];
	}
	
	else{
		pRow.font = [UIFont fontWithName:POLICEH3 size:16.f];
		pRow.text = [NSString stringWithFormat:PRICEFORMATADD,[[[addedAmount _tvaList] objectAtIndex:row] doubleValue] ];
	}
	[pRow sizeToFit];
	
	return pRow;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	if(pickerView.tag == PICKERCREATETVATAG)	return 2;
	else										return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	if(pickerView.tag == PICKERCREATETVATAG)	return 100;
	else										return [[addedAmount _tvaList] count];
}

#pragma mark buttonLogic
- (IBAction)deletePressed:(id)sender{
	if([addedAmount._tvaList count] == 1)
		[self callError: [NSString stringWithFormat:@"Au moins une tva est nécessaire."]];
	
	else{
		NSString* info		= [NSString stringWithFormat:@"Êtes-vous sûr de vouloir supprimer définitivement la TVA à %@ ?", tvacurrentLabel.text];
		UIAlertView* alert	= [[UIAlertView alloc] initWithTitle:@"Suppression TVA" 
											 message:info
											delegate:self 
								   cancelButtonTitle:@"non" 
								   otherButtonTitles:@"oui", nil];
		[alert show];
		[alert release];
	}
}

- (IBAction)addedPressed:(id)sender{
	double newVat						= [tvaAddedLabel.text doubleValue];
	if([self authorizeValue: newVat])	[self addTvaValue: newVat];
}

- (IBAction)goBack:(id)sender{
	[self dismissViewControllerAnimated: YES
                             completion: nil];
}

#pragma mark checkLogic
- (BOOL)authorizeValue:(double)value{
	__block BOOL authorize = YES;
	if(!value){
		[self callError: [NSString stringWithFormat:@"La taxe ne peut être nulle."]];
		return authorize = NO;
	}
	else if([addedAmount._tvaList count] >= MAXTVALIST){
		[self callError: [NSString stringWithFormat:@"Le nombre maximum de taxes a été atteint: %u.", MAXTVALIST]];
		return authorize = NO;
	}
		
	[addedAmount._tvaList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if([obj doubleValue] == value){
			[self		callError: [NSString stringWithFormat:@"Cette taxe existe déjà."]];
			authorize	= NO;
			*stop		= YES;
		}
	}];
	
	return authorize;
}

- (void)addTvaValue:(double)tvaValue{
	[addedAmount					addAmount: tvaValue];
	[currentTvaPicker				reloadAllComponents];
	[currentTvaPicker				selectRow: [addedAmount._tvaList count]-1 inComponent:0 animated:YES];
	double value					= [[[addedAmount _tvaList] objectAtIndex: [addedAmount._tvaList count]-1] doubleValue];
	tvacurrentLabel.text			=  [NSString stringWithFormat:PRICEFORMATADD, value];
}

- (void)callError:(NSString*)reason{
	UIAlertView* alert	= [[UIAlertView alloc] initWithTitle:@"Erreur" 
													 message:reason
													delegate:self 
										   cancelButtonTitle:@"retour" 
										   otherButtonTitles:nil];	
	[alert show];
	[alert release];
}

#pragma mark delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(buttonIndex){
		[addedAmount					deleteAmount:[currentTvaPicker selectedRowInComponent:0]];
		[currentTvaPicker				reloadAllComponents];
		tvacurrentLabel.text			= [NSString stringWithFormat:@"%@%%", [[addedAmount _tvaList] objectAtIndex: [currentTvaPicker selectedRowInComponent:0]]];
	}
}

#pragma mark display
- (void)viewWillAppear:(BOOL) animated{
	newVat[0]				= 0;
	newVat[1]				= 0;
	tvacurrentLabel.text	= [NSString stringWithFormat:@"%@%%", [[addedAmount _tvaList] objectAtIndex: 0]];
	tvaAddedLabel.text		= [NSString stringWithFormat:@"%ldd.%.2ldd%%",newVat[0], newVat[1]];;
}

#pragma mark alloc/dealloc
- (id)initWithTvaAmount:(TVAAmount*)tvaAmount{
	if(self = [super init]){
		addedAmount			= tvaAmount;
		tvaAddedLabel		= (UILabel*)[self.view viewWithTag:LABELNEWTVATAG];
		tvacurrentLabel		= (UILabel*)[self.view viewWithTag:LABELTOTALTVATAG];
		currentTvaPicker	= (UIPickerView*)[self.view viewWithTag:PICKERCURRENTTVATAG];
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
