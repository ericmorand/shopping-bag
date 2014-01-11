// 
//  Sale.m
//  ShoppingBag
//
//  Created by Eric on 25/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Sale.h"

#import "Customer.h"
#import "Invoice.h"
#import "PaymentMethod.h"
#import "SaleLine.h"
#import "TaxRate.h"

@interface Sale (Private)

@end

@implementation Sale 

@dynamic totalTTC;
@dynamic totalTax;
@dynamic discountedTotalHT;
@dynamic discountedTotalTTC;
@dynamic discountRate;
@dynamic saleNumber;
@dynamic date;
@dynamic totalHT;
@dynamic customer;
@dynamic paymentMethod;
@dynamic saleLines;
@dynamic invoice;

+ (NSSet *)keyPathsForValuesAffectingDisplayName {
	return [NSSet setWithObjects:@"saleNumber", nil];
}

+ (NSSet *)keyPathsForValuesAffectingStatusIcon {
	return [NSSet setWithObjects:@"paymentMethod", nil];
}

+ (NSArray *)indexedValuesKeys {return [NSArray arrayWithObjects:@"saleNumber", nil];}
+ (NSArray *)uniqueValuesKeys {return [NSArray arrayWithObjects:@"saleNumber", nil];}

- (NSString *)uniqueSaleNumber {
	NSNumber * nextAutoIncrementedSaleNumber = [self nextAutoIncrementedValueForKey:@"saleNumber"];
	
	return [NSString stringWithFormat:@"%@", nextAutoIncrementedSaleNumber];
}

- (NSString *)displayName {
	NSString * displayName = nil;
	
	displayName = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Sale", @""), [self saleNumber]];
	
	return displayName;
}

- (NSImage *)statusIcon {	
	NSImage * statusIcon = nil;
	
	PaymentMethod * paymentMethod = [self paymentMethod];
	
	statusIcon = ( paymentMethod == nil ? [NSImage imageNamed:@"StatusRed"] : [NSImage imageNamed:@"StatusGreen"] );
	
	return statusIcon;
}

#pragma mark -
#pragma mark GETTERS

- (NSImage *)icon {
	return [NSImage imageNamed:@"Sales"];
}

- (NSArray *)amountByTaxRate {
	NSMutableArray *result = [NSMutableArray array];
	NSMutableDictionary *taxRateAndAmount = nil;
	NSDecimalNumber *productTaxRate = nil;
	NSDecimalNumber *taxAmount = nil;
	
	NSPredicate *predicate = nil;
	NSArray *filteredArray = nil;
		
	for (SaleLine * saleLine in [self saleLines]) {
		// Search dictionary
		
		productTaxRate = saleLine.productTaxRate;
		predicate = [NSPredicate predicateWithFormat:@"taxRate == %@", productTaxRate];
		filteredArray = [result filteredArrayUsingPredicate:predicate];
		
		if ([filteredArray count] > 0) {
			taxRateAndAmount = [filteredArray objectAtIndex:0];
		}
		else {
			taxRateAndAmount = [NSMutableDictionary dictionary];
			
			[taxRateAndAmount setObject:productTaxRate forKey:@"taxRate"];
			[taxRateAndAmount setObject:[NSDecimalNumber zero] forKey:@"taxAmount"];
			
			[result addObject:taxRateAndAmount];
		}
		
		taxAmount = [taxRateAndAmount objectForKey:@"taxAmount"];
		
		taxAmount = [taxAmount decimalNumberByAdding:[saleLine.lineTotalHT decimalNumberByMultiplyingBy:saleLine.productTaxRate]];
		
		[taxRateAndAmount setObject:taxAmount forKey:@"taxAmount"];
	}
	
	return [NSArray arrayWithArray:result];
}

#pragma mark -
#pragma mark SETTERS

- (void)addSaleLine:(SaleLine *)saleLine {	
	[self addSaleLinesObject:saleLine];
	[self beginKeyValueObservingForSaleLine:saleLine];
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

#pragma mark -
#pragma mark KVO

- (void)beginKeyValueObserving {
	[self addObserver:self forKeyPath:@"saleLines" options:0 context:nil];
	[self addObserver:self forKeyPath:@"totalHT" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"totalTTC" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"discountedTotalHT" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"discountedTotalTTC" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"discountRate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	
	for (SaleLine * saleLine in [self saleLines]) {
		[self beginKeyValueObservingForSaleLine:saleLine];
	}
}

- (void)beginKeyValueObservingForSaleLine:(SaleLine *)saleLine {
	[saleLine addObserver:self forKeyPath:@"lineTotalTTC" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	id oldValue = [change valueForKey:NSKeyValueChangeOldKey];
	id newValue = [change valueForKey:NSKeyValueChangeNewKey];

	if ([newValue isEqual:oldValue])
	{
		return;
	}
	
	if ([keyPath isEqualToString:@"saleLines"] || [keyPath isEqualToString:@"lineTotalHT"] || [keyPath isEqualToString:@"lineTotalTTC"]) {
		[self computeTotalHTAndTTC];
	}
	
	if ([keyPath isEqualToString:@"totalHT"] || [keyPath isEqualToString:@"totalTTC"]) {
		[self computeDiscountedTotalHTAndTTC];
	}
	
	if ([keyPath isEqualToString:@"discountedTotalTTC"]) {
		[self computeTotalTax];
	}
	
	if ([keyPath isEqualToString:@"discountRate"]) {
		[self computeDiscountedTotalHTAndTTC];
	}
}

#pragma mark -
#pragma mark COMPUTED VALUES

- (void)computeTotalHTAndTTC {
	[self setTotalHT:[self valueForKeyPath:@"saleLines.@sum.lineTotalHT"]];
	[self setTotalTTC:[self valueForKeyPath:@"saleLines.@sum.lineTotalTTC"]];
}

- (void)computeDiscountedTotalHTAndTTC {
	if (nil != [self discountRate])
	{
		[self setDiscountedTotalHT:[[self totalHT] decimalNumberBySubtractingRate:[self discountRate]]];
		[self setDiscountedTotalTTC:[[self totalTTC] decimalNumberBySubtractingRate:[self discountRate]]];
	}
}

- (void)computeTotalTax {
	if ( nil != [self discountedTotalHT] )
	{
		NSDecimalNumber * result = nil;
		
		result = [[self discountedTotalTTC] decimalNumberBySubtracting:[self discountedTotalHT]];
		
		[self setTotalTax:result];
	}
}

#pragma mark -
#pragma mark MISC

- (void)awakeFromFetch {
	[super awakeFromFetch];
}

- (void)awakeFromInsert {
	[super awakeFromInsert];
}

- (void)setDefaultValues {
	self.saleNumber = [self uniqueSaleNumber];
	self.discountRate = [NSDecimalNumber zero];
	self.date = [NSDate date];
	self.totalHT = [NSDecimalNumber zero];
	self.totalTTC = [NSDecimalNumber zero];
	self.discountedTotalHT = [NSDecimalNumber zero];
	self.discountedTotalTTC = [NSDecimalNumber zero];
	self.totalTax = [NSDecimalNumber zero];
}

@end
