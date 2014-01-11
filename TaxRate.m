// 
//  TaxRate.m
//  ShoppingBag
//
//  Created by Eric on 06/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "TaxRate.h"
#import "Product.h"

@implementation TaxRate 

@dynamic name;
@dynamic rate;
@dynamic products;

+ (TaxRate *)taxRateInContext:(NSManagedObjectContext *)aContext {
	return [[[TaxRate alloc] initWithEntity:[NSEntityDescription entityForName:@"TaxRate" inManagedObjectContext:aContext] insertIntoManagedObjectContext:aContext] autorelease];
}

+ (NSSet *)keyPathsForValuesAffectingDisplayName {
	return [NSSet setWithObjects:@"name", @"rate", nil];
}

- (NSString *)displayName {
	FKPercentFormatter * percentFormatter = [[[FKPercentFormatter alloc] init] autorelease];
	
	NSString * rateAsString = [percentFormatter stringForObjectValue:[self rate]];
	
    return [NSString stringWithFormat:@"%@ : %@", [self name], rateAsString];
}

- (NSImage *)icon {
	return [NSImage imageNamed:@"TaxRates"];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateName:(id *)valueRef error:(NSError **)outError  {
	NSString * descriptionString = nil;
	NSString * suggestionString = nil;
	NSDictionary * userInfo = nil;
	NSError * error = nil;
	
	// Le nom du taux de taxe doit etre defini
	
	if ( *valueRef == nil )
	{
		descriptionString = NSLocalizedStringFromTable(@"BlankTaxRateNameDescription", @"ErrorMessages", @"");
		suggestionString = NSLocalizedStringFromTable(@"BlankTaxRateNameSuggestion", @"ErrorMessages", @"");
		
		userInfo = [NSDictionary dictionaryWithObjectsAndKeys:descriptionString, NSLocalizedDescriptionKey, suggestionString, NSLocalizedRecoverySuggestionErrorKey, nil];
		
		error = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationErrorMinimum userInfo:userInfo] autorelease];
		
		if (nil != outError) {
			*outError = error;
		}
		
		return NO;
	}
	
    return YES;	
}

- (BOOL)validateRate:(id *)valueRef error:(NSError **)outError  {
    return YES;
}

#pragma mark -
#pragma mark KVO

#pragma mark -
#pragma mark DEFAULT VALUES

- (void)setDefaultValues {
	self.name = [self uniqueName];
}

- (NSString *)uniqueName {
	NSString * defaultName = NSLocalizedString(@"NewTaxRate", nil);
	NSString * uniqueName = defaultName;
	
//	unsigned index = 0;
//	
//	FKMOCIndexesManager * defaultIndexesManager = [FKMOCIndexesManager defaultManager];
//	
//	while ( ![defaultIndexesManager validateValue:&uniqueName forIndexedKey:@"name" ofObject:self] )
//	{		
//		index++;
//		
//		uniqueName = [defaultName stringByAppendingFormat:@" (%d)", index];
//	}
	
	return uniqueName;
}

#pragma mark -
#pragma mark KVO

- (void)beginKeyValueObserving {	
	[self addObserver:self forKeyPath:@"rate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)stopKeyValueObserving {	
	[self removeObserver:self forKeyPath:@"rate"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	id oldValue = [change valueForKey:NSKeyValueChangeOldKey];
	id newValue = [change valueForKey:NSKeyValueChangeNewKey];
	
	if ([newValue isEqual:oldValue]) {
		return;
	}
	
	if ([keyPath isEqualToString:@"rate"]) {
		for (Product * product in self.products) {
			[product computeUnitPriceTTC];
		}
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

@end
