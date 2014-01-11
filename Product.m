// 
//  Product.m
//  ShoppingBag
//
//  Created by Eric on 07/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "Product.h"

#import "Brand.h"
#import "ProductCategory.h"
#import "ProductFamily.h"
#import "ProviderProduct.h"
#import "Sale.h"
#import "StockAlert.h"
#import "StockMovement.h"
#import "TaxRate.h"
#import "Provider.h"
#import "SBMOCHelper+Brand.h"
#import "SBMOCHelper+ProductFamily.h"

@interface Product (Private)

- (NSString *)uniqueName;
- (void)setDefaultValues;

- (void)computeUnitPriceHT;
- (void)computeUnitPriceTTC;

@end

@implementation Product 

@dynamic isDiscontinued;
@dynamic reference;
@dynamic versoIcon;
@dynamic unitPriceTTC;
@dynamic name;
@dynamic unitPriceHT;
@dynamic rectoIconData;
@dynamic currentStock;
@dynamic discontinuedDate;
@dynamic rectoIcon;
@dynamic versoIconData;
@dynamic barcodeImageData;
@dynamic barcode;
@dynamic barcodeImage;
@dynamic notes;
@dynamic brand;
@dynamic stockMovements;
@dynamic stockAlert;
@dynamic productFamily;
@dynamic productCategories;
@dynamic sales;
@dynamic providerProducts;
@dynamic taxRate;
@dynamic salePriceIncludesTax;

+ (NSArray *)indexedValuesKeys {return [NSArray arrayWithObjects:@"name", nil];}
+ (NSArray *)uniqueValuesKeys {return [NSArray arrayWithObjects:@"name", nil];}

+ (NSSet *)keyPathsForValuesAffectingBrandName {
	return [NSSet setWithObjects:@"brand", @"brand.name", nil];
}

+ (NSSet *)keyPathsForValuesAffectingProductFamilyName {
	return [NSSet setWithObjects:@"productFamily", @"productFamily.name", nil];
}

#pragma mark -
#pragma mark GETTERS

- (NSImage *)rectoIcon {
	return [NSImage imageNamed:@"Products"];
}

- (NSString *)brandName {
	return self.brand.name;
}

- (NSString *)productFamilyName {
	return self.productFamily.name;
}

- (Provider *)primaryProvider {
	Provider *result = nil;
	NSArray *tmpArray = [self.providerProducts allObjects];
	
	if ([tmpArray count] > 0) {
		result = ((ProviderProduct *)[tmpArray objectAtIndex:0]).provider;
	}
	
	return result;
}

#pragma mark -
#pragma mark SETTERS

- (void)setBrandName:(NSString *)aString {
	Brand *newBrand = [[SBMOCHelper sharedHelper] fetchBrandWithName:aString inManagedObjectContext:[self managedObjectContext]];
	
	self.brand = newBrand;
}

- (void)setProductFamilyName:(NSString *)aString {
	ProductFamily *newProductFamily = [[SBMOCHelper sharedHelper] fetchProductFamilyWithName:aString inManagedObjectContext:[self managedObjectContext]];
	
	self.productFamily = newProductFamily;
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateBrandName:(id *)valueRef error:(NSError **)outError {
	NSString * newName = (NSString *)*valueRef;
	Brand * newBrand = nil;
		
	if (nil != newName) {
		newBrand = [[SBMOCHelper sharedHelper] fetchBrandWithName:newName inManagedObjectContext:[self managedObjectContext]];
	}
	
	return (newName == nil || newBrand != nil);
}

- (BOOL)validateProductFamilyName:(id *)valueRef error:(NSError **)outError {
	NSString * newName = (NSString *)*valueRef;
	ProductFamily * newProductFamily = nil;
	
	if (nil != newName) {
		newProductFamily = [[SBMOCHelper sharedHelper] fetchProductFamilyWithName:newName inManagedObjectContext:[self managedObjectContext]];
	}
	
	return (newName == nil || newProductFamily != nil);
}

- (BOOL)validateBarcode:(id *)valueRef error:(NSError **)outError {
	NSString * newBarcode = *valueRef;
	
	if ( nil != newBarcode )
	{
		NKDBarcode * barcode = [[[NKDEAN13Barcode alloc] initWithContent:newBarcode printsCaption:NO] autorelease];
		
		return [barcode isContentValid];
	}
	
    return YES;
}

- (BOOL)validateBrand: (id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateCurrentStock:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateDiscontinuedDate:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateIsDiscontinued:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateNotes:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateProductFamily:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateRectoIcon: (id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateReference:(id *)valueRef error:(NSError **)outError {
	return YES;
}

- (BOOL)validateStockAlert:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateTaxRate:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateUnitPriceHT:(id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateVersoIcon: (id *)valueRef error:(NSError **)outError {
    return YES;
}

- (BOOL)validateName:(id *)valueRef error:(NSError **)outError  {		
//	NSString * errorString = nil;
//	NSString * suggestionString = nil;
//	NSDictionary * userInfo = nil;
//	NSError * error = nil;
//	
//	// Le nom du compte doit etre defini
//	
//	if ( *valueRef == nil )
//	{
//		errorString = NSLocalizedStringFromTable(@"ProductNameBlank", @"ErrorMessagesLocalized", @"");
//		suggestionString = NSLocalizedStringFromTable(@"ProductNameBlankSuggestion", @"ErrorMessagesLocalized", @"");
//		
//		userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, suggestionString, NSLocalizedRecoverySuggestionErrorKey, nil];
//		
//		error = [[[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationErrorMinimum userInfo:userInfo] autorelease];
//		
//		if (nil != outError) {
//			*outError = error;
//		}
//		
//		return NO;
//	}
	
    return YES;	
}

- (BOOL)validateUnitPriceTTC:(id *)valueRef error:(NSError **)outError  {
	return YES;
}

#pragma mark _
#pragma mark MISC

- (void)setDefaultValues {
	self.name = [self uniqueName];
	//self.rectoIcon = [NSImage imageNamed:@"NSApplicationIcon"];
	self.unitPriceHT = [NSDecimalNumber zero];

	// L'exécution d'une fetch request pendant qu'un objet est inséré
	// pose problème et fait apparaître l'objet en double au sein du array controller
	// http://lists.apple.com/archives/cocoa-dev/2005/Sep/msg00175.html
	
	[self performSelector:@selector(setDefaultTaxRate) withObject:self afterDelay:0];
}

- (void)setDefaultTaxRate {	
	NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription * entity = [NSEntityDescription entityForName:@"TaxRate" inManagedObjectContext:self.managedObjectContext];
	NSPredicate * predicate = [NSPredicate predicateWithFormat:@"rate == %@", [NSDecimalNumber decimalNumberWithString:@"0.196"]];
	
	[fetchRequest setEntity:entity];
	[fetchRequest setPredicate:predicate];
	
	NSArray * results = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
	if ([results count] > 0) {
		self.taxRate = [results objectAtIndex:0];
	}
}

- (NSString *)uniqueName {	
	NSString * defaultName = NSLocalizedString(@"NewProduct", nil);
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

- (void)awakeFromFetch {
	[super awakeFromFetch];
	
	//NSLog(@"salePriceIncludesTax = %@", self.salePriceIncludesTax);
}

- (void)awakeFromInsert {
	[super awakeFromInsert];
}

//- (void)willSave {	
//	NSImage * icon = nil;
//	id tmpValue = nil;
//	
//	// Barcode
//	
//	tmpValue = nil;
//	
//    icon = [self primitiveValueForKey:@"barcodeImage"];
//	
//	if ( nil != icon )
//	{
//		//tmpValue = [NSKeyedArchiver archivedDataWithRootObject:icon];
//	}
//	
//	[self setPrimitiveValue:tmpValue forKey:@"barcodeImageData"];
//	
//	// Recto
//	
//    icon = [self primitiveValueForKey:@"rectoIcon"];	
//	
//    if ( icon != nil )
//	{
//        //tmpValue = [NSKeyedArchiver archivedDataWithRootObject:icon];
//    }
//	
//	[self setPrimitiveValue:nil forKey:@"rectoIconData"];
//	
//	// Verso
//	
//	tmpValue = nil;
//	
//    icon = [self primitiveValueForKey:@"versoIcon"];
//	
//    if ( icon != nil )
//	{
//        //tmpValue = [NSKeyedArchiver archivedDataWithRootObject:icon];
//    }
//	
//	[self setPrimitiveValue:nil forKey:@"versoIconData"];
//	
//	// Super
//    
//	[super willSave];
//}

#pragma mark -
#pragma mark KVO

- (void)beginKeyValueObserving {		
	[self addObserver:self forKeyPath:@"unitPriceHT" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];		
	[self addObserver:self forKeyPath:@"unitPriceTTC" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"taxRate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
	[self addObserver:self forKeyPath:@"taxRate.rate" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
}

- (void)stopKeyValueObserving {		
	[self removeObserver:self forKeyPath:@"unitPriceHT"];		
	[self removeObserver:self forKeyPath:@"unitPriceTTC"];
	[self removeObserver:self forKeyPath:@"taxRate"];
	[self removeObserver:self forKeyPath:@"taxRate.rate"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	id oldValue = [change valueForKey:NSKeyValueChangeOldKey];
	id newValue = [change valueForKey:NSKeyValueChangeNewKey];
	
	NSLog(@"*** PRODUCT observeValueForKeyPath : %@ - newValue = %@", keyPath, newValue);	
	
	if ([newValue isEqual:oldValue]) {
		return;
	}
	
	if ([keyPath isEqualToString:@"unitPriceHT"]) {
		if (![self.salePriceIncludesTax boolValue]) {
			[self computeUnitPriceTTC];
		}
	}
	
	if ([keyPath isEqualToString:@"unitPriceTTC"]) {
		if ([self.salePriceIncludesTax boolValue]) {
			[self computeUnitPriceHT];
		}
	}
	
	if ([keyPath isEqualToString:@"taxRate"] || [keyPath isEqualToString:@"taxRate.rate"]) {
		if ([self.salePriceIncludesTax boolValue]) {
			[self computeUnitPriceHT];
		}
		else {
			[self computeUnitPriceTTC];
		}
	}
}

#pragma mark -
#pragma mark COMPUTED VALUES

- (void)computeUnitPriceHT {
	self.unitPriceHT = [self.unitPriceTTC decimalNumberByRemovingRate:self.taxRate.rate];
		
	for (ProviderProduct * providerProduct in self.providerProducts) {
		[providerProduct computeDerivedValues];
	}	
}

- (void)computeUnitPriceTTC {
	self.unitPriceTTC = [self.unitPriceHT decimalNumberByAddingRate:self.taxRate.rate];
		
	for (ProviderProduct * providerProduct in self.providerProducts) {
		[providerProduct computeDerivedValues];
	}
}

#pragma mark -
#pragma mark STOCK VALUE SUPPORT

- (NSDecimalNumber *)greatestProviderPrice {
	return [self.providerProducts valueForKey:@"@max.providerPriceHT"];
}

- (NSDecimalNumber *)stockValueForProvider:(Provider *)provider {
	NSDecimalNumber * stockValue = [NSDecimalNumber zero];
	
	NSDecimalNumber * providerPriceHT = nil;
	NSDecimalNumber * maxProviderPriceHT = [NSDecimalNumber zero];
	NSDecimalNumber * currentStock = nil;
		
	for (ProviderProduct * aProviderProduct in self.providerProducts) {
		providerPriceHT = [aProviderProduct providerPriceHT];
		
		// On ne retourne une valeur de stock positivie que si le fournisseur est
		// le fournisseur le plus cher parmi tous les fournisseurs du produit
		
		if ([providerPriceHT isGreaterThan:maxProviderPriceHT]) {
			maxProviderPriceHT = providerPriceHT;
			
			if ( [aProviderProduct provider] == provider ) {
				stockValue = maxProviderPriceHT;
			}
			else {
				stockValue = [NSDecimalNumber zero];
			}
		}
	}
	
	currentStock = [NSDecimalNumber decimalNumberWithDecimal:[[self currentStock] decimalValue]];
	
	if ([currentStock isNegative]) {
		currentStock = [NSDecimalNumber zero];
	}
	
	stockValue = [stockValue decimalNumberByMultiplyingBy:currentStock];
	
	return stockValue;
}

- (ProviderProduct *)mostExpensiveProviderProduct; {
	ProviderProduct * result = nil;
	
	NSDecimalNumber * greatestProviderPrice = [NSDecimalNumber zero];
	NSDecimalNumber * providerPriceHT = nil;
	
	for (ProviderProduct * aProviderProduct in self.providerProducts) {
		providerPriceHT = [aProviderProduct providerPriceHT];
		
		if ( [providerPriceHT isGreaterThan:greatestProviderPrice] ) {
			result = aProviderProduct;
		}
	}
	
	return result;
}

- (Provider *)firstProvider {
	Provider * result = nil;
		
	if ([self.providerProducts count] > 0) {	
		result = [[[self.providerProducts allObjects] objectAtIndex:0] provider];
	}
	
	return result;
}

@end
