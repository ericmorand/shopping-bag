// 
//  ProviderProduct.m
//  ShoppingBag
//
//  Created by Eric on 07/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "ProviderProduct.h"

#import "Product.h"
#import "Provider.h"
#import "TaxRate.h"

@interface ProviderProduct (Private)

- (void)computeProviderPriceTTC;
- (void)computeTauxMarge;
- (void)computeTauxMarque;
- (void)computeCoefficientMultiplicateur;
- (void)computeProductUnitPriceFromTauxMarge;
- (void)computeProductUnitPriceFromTauxMarque;
- (void)computeProductUnitPriceFromCoefficientMultiplicateur;

@end

@implementation ProviderProduct 

@dynamic tauxMarge;
@dynamic tauxMarque;
@dynamic coefficientMultiplicateur;
@dynamic providerPriceTTC;
@dynamic providerReference;
@dynamic providerPriceHT;
@dynamic product;
@dynamic provider;

- (void)dealloc {
	[super dealloc];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateCoefficientMultiplicateur:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateProduct:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateProvider:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateProviderPriceHT:(id *)valueRef error:(NSError **)outError {	
	NSDecimalNumber * providerPriceHT = *valueRef;
	
	NSString * errorString = nil;
	NSString * suggestionString = nil;
	NSDictionary * userInfo = nil;
	NSError * error = nil;
	
	// ...
	
	if ([providerPriceHT isNegative])
	{
		errorString = NSLocalizedStringFromTable(@"ProviderPriceNegative", @"ErrorMessagesLocalized", @"");
		suggestionString = NSLocalizedStringFromTable(@"ProviderPriceNegativeSuggestion", @"ErrorMessagesLocalized", @"");
		
		userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, suggestionString, NSLocalizedRecoverySuggestionErrorKey, nil];
		
		error = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationErrorMinimum userInfo:userInfo] autorelease];
		
		if (nil != outError) {
			*outError = error;
		}
		
		return NO;
	}
	
    return YES;
}

- (BOOL)validateProviderPriceTTC: (id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateTauxMarge:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateTauxMarque:(id *)valueRef error:(NSError **)outError {
	NSDecimalNumber * tauxMarque = *valueRef;
	
	NSString * errorString = nil;
	NSString * suggestionString = nil;
	NSDictionary * userInfo = nil;
	NSError * error = nil;
	
	// Le taux de marque doit etre strictement inferieur a 100%, sauf si le prix
	// d'achat HT est egal a zero, auquel cas le taux de marque peut etre egal a 100%
	
	if (tauxMarque != NSNotApplicableMarker) 
	{
		if ([tauxMarque isGreaterThanOrEqualTo:[NSDecimalNumber one]] && ![[self providerPriceHT] isEqualToZero])
		{
			errorString = NSLocalizedStringFromTable(@"TauxMarqueGreaterOrEqualToHundred", @"ErrorMessages", @"");
			suggestionString = NSLocalizedStringFromTable(@"TauxMarqueGreaterOrEqualToHundredSuggestion", @"ErrorMessages", @"");
			
			userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, suggestionString, NSLocalizedRecoverySuggestionErrorKey, nil];
			
			error = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationErrorMinimum userInfo:userInfo] autorelease];
			
			if (nil != outError) {
				*outError = error;
			}
			
			return NO;
		}
	}
	
    return YES;
}

#pragma mark -

- (void)beginKeyValueObserving {	
	[self addObserver:self forKeyPath:@"product" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"providerPriceHT" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];		
	[self addObserver:self forKeyPath:@"providerPriceTTC" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"tauxMarge" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"tauxMarque" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"coefficientMultiplicateur" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)stopKeyValueObserving {	
	[self removeObserver:self forKeyPath:@"product"];
	[self removeObserver:self forKeyPath:@"providerPriceHT"];		
	[self removeObserver:self forKeyPath:@"providerPriceTTC"];
	[self removeObserver:self forKeyPath:@"tauxMarge"];
	[self removeObserver:self forKeyPath:@"tauxMarque"];
	[self removeObserver:self forKeyPath:@"coefficientMultiplicateur"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	id oldValue = [change valueForKey:NSKeyValueChangeOldKey];
	id newValue = [change valueForKey:NSKeyValueChangeNewKey];
	
	NSLog(@"*** PROVIDER %@ PRODUCT observeValueForKeyPath : %@ - newValue = %@, shouldCOmpute = %d", self.provider.name, keyPath, newValue, shouldComputeDerivedValues);
	
	if ([newValue isEqual:oldValue]) {
		return;
	}
	
	if ([keyPath isEqualToString:@"providerPriceHT"] ||
		[keyPath isEqualToString:@"product"]) {
		[self computeDerivedValues];
	}
	
	if ([keyPath isEqualToString:@"tauxMarge"]) {
		if (shouldComputeDerivedValues) {
			shouldComputeDerivedValues = NO;
		
			[self computeProductUnitPriceFromTauxMarge];
			[self computeTauxMarque];
			[self computeCoefficientMultiplicateur];
		
			shouldComputeDerivedValues = YES;
		}
	}
	
	if ([keyPath isEqualToString:@"tauxMarque"]) {
		if (shouldComputeDerivedValues) {
			shouldComputeDerivedValues = NO;
		
			[self computeProductUnitPriceFromTauxMarque];
			[self computeTauxMarge];
			[self computeCoefficientMultiplicateur];
		
			shouldComputeDerivedValues = YES;
		}
	}
	
	if ([keyPath isEqualToString:@"coefficientMultiplicateur"]) {		
		if (shouldComputeDerivedValues) {
			shouldComputeDerivedValues = NO;
			
			[self computeProductUnitPriceFromCoefficientMultiplicateur];
			[self computeTauxMarge];
			[self computeTauxMarque];
			
			shouldComputeDerivedValues = YES;
		}
	}
}

#pragma mark -
#pragma mark COMPUTED VALUES

- (void)computeProviderPriceTTC {
	self.providerPriceTTC = [self.providerPriceHT decimalNumberByAddingRate:self.product.taxRate.rate];
}

- (void)computeTauxMarge {
	// Tmg = ((PV HT - PA HT) / PA HT)

	NSDecimalNumber * result = nil;

	if ((nil != self.providerPriceHT) && (![self.providerPriceHT isEqualToZero])) {
		result = [self.product.unitPriceHT decimalNumberBySubtracting:self.providerPriceHT];
		result = [result decimalNumberByDividingBy:self.providerPriceHT];
	}

	self.tauxMarge = result;
}

- (void)computeTauxMarque {
	// Tmq = ((PV HT - PA HT) / PV HT)

	NSDecimalNumber * result = nil;

	if ((nil != self.product.unitPriceHT ) && (![self.product.unitPriceHT isEqualToZero]) && (![self.providerPriceHT isEqualToZero]))
	{
		result = [self.product.unitPriceHT decimalNumberBySubtracting:self.providerPriceHT];
		result = [result decimalNumberByDividingBy:self.product.unitPriceHT];
	}

	self.tauxMarque = result;
}

- (void)computeCoefficientMultiplicateur {
	// Cm = PV TTC / PA HT	
	
	NSDecimalNumber * result = nil;	

	if ( ![self.providerPriceHT isEqualToZero] ) {			
		result = [self.product.unitPriceTTC decimalNumberByDividingBy:self.providerPriceHT];
	}
	
	self.coefficientMultiplicateur = result;
}

- (void)computeProductUnitPriceFromTauxMarge {		
	NSDecimalNumber * result = nil;
	
	if (self.tauxMarge != nil) {
		result = [self.tauxMarge decimalNumberByMultiplyingBy:self.providerPriceHT];
		result = [result decimalNumberByAdding:self.providerPriceHT];
				
		if ([self.product.salePriceIncludesTax boolValue]) {
			self.product.unitPriceTTC = [result decimalNumberByAddingRate:self.product.taxRate.rate];
		}
		else {
			self.product.unitPriceHT = result;
		}
	}
}
		
- (void)computeProductUnitPriceFromTauxMarque {
	NSDecimalNumber * result = nil;	
	
	// Theoriquement, le taux de marque devrait toujours etre strictement inferieur a 100%
	// (voir la methode de validation dans la classe Product), mais au cas ou et pour
	// eviter une eventuelle division par zero, on effectue une verification
	// avant d'effectuer les calculs
	
	if ((self.tauxMarque != nil ) && [self.tauxMarque isLessThan:[NSDecimalNumber one]])
	{
		result = [[NSDecimalNumber one] decimalNumberBySubtracting:self.tauxMarque];
		result = [self.providerPriceHT decimalNumberByDividingBy:result];
				
		if ([self.product.salePriceIncludesTax boolValue]) {
			self.product.unitPriceTTC = [result decimalNumberByAddingRate:self.product.taxRate.rate];
		}
		else {
			self.product.unitPriceHT = result;
		}
	}
}

- (void)computeProductUnitPriceFromCoefficientMultiplicateur {
	NSDecimalNumber * result = nil;		
	
	if (self.coefficientMultiplicateur != nil)
	{
		result = [self.providerPriceHT decimalNumberByMultiplyingBy:self.coefficientMultiplicateur];
				
		if ([self.product.salePriceIncludesTax boolValue]) {
			self.product.unitPriceTTC = result;
		}
		else {
			self.product.unitPriceHT = [result decimalNumberByRemovingRate:self.product.taxRate.rate];
		}
	}
}

#pragma mark MISC

- (void)computeDerivedValues {
	if (shouldComputeDerivedValues) {
		shouldComputeDerivedValues = NO;
		
		[self computeProviderPriceTTC];
		[self computeTauxMarge];
		[self computeTauxMarque];
		[self computeCoefficientMultiplicateur];
		
		shouldComputeDerivedValues = YES;
	}
}

- (void)awakeFromFetch {	
	[super awakeFromFetch];
}

- (void)awakeFromInsert {
	[super awakeFromFetch];
}

- (void)didTurnIntoFault {	
	[super didTurnIntoFault];
}

@end
