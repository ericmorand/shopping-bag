// 
//  SaleLine.m
//  ShoppingBag
//
//  Created by Eric on 18/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "SaleLine.h"

#import "Product.h"
#import "TaxRate.h"
#import "Sale.h"
#import "StockMovement.h"

@implementation SaleLine 

@dynamic quantity;
@dynamic productDiscountPriceHT;
@dynamic productDiscountPriceTTC;
@dynamic productTaxRate;
@dynamic productBasePriceTTC;
@dynamic discountRate;
@dynamic lineTotalTTC;
@dynamic productBasePriceHT;
@dynamic lineTotalHT;
@dynamic product;
@dynamic stockMovement;
@dynamic sale;

@synthesize creationDate;

- (NSString *)description {
	return [NSString stringWithFormat:@"SaleLine => sale : %@ - quantite : %@ - productBasePriceHT = %@", self.sale, self.quantity, self.productBasePriceHT];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateDiscountRate:(id *)valueRef error:(NSError **)outError {
	NSDecimalNumber * discountRate = *valueRef;
	
	NSString * errorString = nil;
	NSString * suggestionString = nil;
	NSDictionary * userInfo = nil;
	NSError * error = nil;
	
	if (([discountRate isGreaterThan:[NSDecimalNumber one]]) || ([discountRate isNegative])) {
		errorString = NSLocalizedStringFromTable(@"InvalidDiscountRate", @"ErrorMessages", @"");
		suggestionString = NSLocalizedStringFromTable(@"InvalidDiscountRateSuggestion", @"ErrorMessages", @"");
		
		userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, suggestionString, NSLocalizedRecoverySuggestionErrorKey, nil];
		
		error = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationErrorMinimum userInfo:userInfo] autorelease];
		
		if (nil != outError) {
			*outError = error;
		}
		
		return NO;
	}
	
    return YES;
}

- (BOOL)validateProductDiscountPriceTTC:(id *)valueRef error:(NSError **)outError {
	NSDecimalNumber * productDiscountPriceTTC = *valueRef;
	NSDecimalNumber * productBasePriceTTC = self.productBasePriceTTC;
	
	NSString * errorString = nil;
	NSString * suggestionString = nil;
	NSDictionary * userInfo = nil;
	NSError * error = nil;
	
	if ([productDiscountPriceTTC isGreaterThan:productBasePriceTTC]) {
		errorString = NSLocalizedStringFromTable(@"DiscountPriceGreaterThanBasePrice", @"ErrorMessages", @"");
		suggestionString = NSLocalizedStringFromTable(@"DiscountPriceGreaterThanBasePriceSuggestion", @"ErrorMessages", @"");
		
		userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, suggestionString, NSLocalizedRecoverySuggestionErrorKey, nil];
		
		error = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationErrorMinimum userInfo:userInfo] autorelease];
		
		if (nil != outError) {
			*outError = error;
		}
		
		return NO;
	}
	
    return YES;
}

#pragma mark -
#pragma mark DERIVED VALUES

- (void)computeProductBasePriceTTC {
	if (nil != self.productTaxRate) {
		self.productBasePriceTTC = [self.productBasePriceHT decimalNumberByAddingRate:self.productTaxRate];
	}
}

- (void)computeProductDiscountPriceHT {
	if (nil != self.discountRate) {
		self.productDiscountPriceHT = [self.productBasePriceHT decimalNumberBySubtractingRate:self.discountRate];
	}
}

- (void)computeProductDiscountPriceTTC {
	if (nil != self.productTaxRate) {
		self.productDiscountPriceTTC = [self.productDiscountPriceHT decimalNumberByAddingRate:self.productTaxRate];
	}
}

- (void)computeDiscountRate {
	if (nil != self.productBasePriceTTC) {
		NSDecimalNumber * result = nil;
		
		result = [self.productDiscountPriceTTC decimalNumberByDividingBy:self.productBasePriceTTC];
		
		if (nil != result) {
			result = [[NSDecimalNumber one] decimalNumberBySubtracting:result];
		}
		
		self.discountRate = result;
	}
}

- (void)computeLineTotals {
	if (nil != self.quantity) {
		self.lineTotalHT = [self.productDiscountPriceHT decimalNumberByMultiplyingBy:self.quantity];
		self.lineTotalTTC = [self.productDiscountPriceTTC decimalNumberByMultiplyingBy:self.quantity];
	}
}

#pragma mark -
#pragma mark KVO

- (void)beginKeyValueObserving {	
	[self addObserver:self forKeyPath:@"product" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];		
	[self addObserver:self forKeyPath:@"productBasePriceHT" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"productDiscountPriceHT" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"productDiscountPriceTTC" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"quantity" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"discountRate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"productTaxRate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];	
}

- (void)stopKeyValueObserving {	
	[self removeObserver:self forKeyPath:@"product"];		
	[self removeObserver:self forKeyPath:@"productBasePriceHT"];
	[self removeObserver:self forKeyPath:@"productDiscountPriceHT"];
	[self removeObserver:self forKeyPath:@"productDiscountPriceTTC"];
	[self removeObserver:self forKeyPath:@"quantity"];
	[self removeObserver:self forKeyPath:@"discountRate"];
	[self removeObserver:self forKeyPath:@"productTaxRate"];	
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	id oldValue = [change valueForKey:NSKeyValueChangeOldKey];
	id newValue = [change valueForKey:NSKeyValueChangeNewKey];
	
	NSLog(@"*** SALELINE observeValueForKeyPath : %@ - newValue = %@, shouldCOmpute = %d", keyPath, newValue, shouldComputeDerivedValues);	
	
	if ([newValue isEqual:oldValue]) {
		return;
	}
	
	if ([keyPath isEqualToString:@"product"]) {
		self.productBasePriceHT = self.product.unitPriceHT;
		self.productTaxRate = self.product.taxRate.rate;
	}
	
	if ([keyPath isEqualToString:@"productBasePriceHT"]) {
		[self computeProductBasePriceTTC];
		[self computeProductDiscountPriceHT];
	}
	
	if ([keyPath isEqualToString:@"discountRate"]) {
		if (shouldComputeDerivedValues) {
			shouldComputeDerivedValues = NO;
			
			[self computeProductDiscountPriceHT];
			[self computeProductDiscountPriceTTC];
			
			shouldComputeDerivedValues = YES;
		}
	}
	
	if ([keyPath isEqualToString:@"productDiscountPriceHT"]) {
		if (shouldComputeDerivedValues) {
			shouldComputeDerivedValues = NO;
			
			[self computeProductDiscountPriceTTC];
			[self computeDiscountRate];

			shouldComputeDerivedValues = YES;
		}
	}
	
	if ([keyPath isEqualToString:@"productDiscountPriceTTC"]) {
		if (shouldComputeDerivedValues) {
			shouldComputeDerivedValues = NO;
			
			[self computeProductDiscountPriceHT];
			[self computeDiscountRate];
			
			shouldComputeDerivedValues = YES;
		}
	}
	
	if ([keyPath isEqualToString:@"productTaxRate"]) {
		if (shouldComputeDerivedValues) {
			shouldComputeDerivedValues = NO;
			
			[self computeProductBasePriceTTC];
			[self computeProductDiscountPriceTTC];
			
			shouldComputeDerivedValues = YES;
		}
	}
	
	[self computeLineTotals];
}

@end
