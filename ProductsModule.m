//
//  ProductsModule.m
//  ShoppingBag
//
//  Created by alt on 04/11/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "ProductsModule.h"

#import "Brand.h"
#import "BrandsModule.h"
#import "Inventory.h"
#import "Product.h"
#import "ProductCategory.h"
#import "ProductCategoriesModule.h"
#import "ProductFamily.h"
#import "ProductFamiliesModule.h"
#import "Provider.h"
#import "ProviderProduct.h"
#import "ProvidersModule.h"
#import "StockMovement.h"
#import "StockSnapshot.h"
#import "TaxRate.h"
#import "TaxRatesModule.h"

#import "IncomingProductsManager.h"

@interface ProductsModule (Private)

- (void)addProduct;

@end

@implementation ProductsModule

@synthesize currentProviderProduct;

- (id)initWithContext:(NSManagedObjectContext *)aContext userInfo:(NSDictionary *)aDictionary {
	self = [super initWithContext:aContext userInfo:aDictionary];
	
	if (nil != self) {
		// Sort descriptors
		
		NSSortDescriptor * sortDescriptor = nil;
		
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:TRUE selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
		
		self.objectsArrayControllerSortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
	}
	
	return self;
}

- (void)awakeFromNib {
}

#pragma mark -
#pragma mark GETTERS

@synthesize selection;

- (NSString *)name {
	return @"Products";
}

- (NSString *)entityName {
	return @"Product";
}

- (NSArray *)searchFieldPredicateIdentifiers {
	return [NSArray arrayWithObjects:
		@"Name",
		@"NameBeginsWith",
		@"Barcode",
		@"Provider",
		@"Reference",
		@"ProductFamily",
		@"Brand",
		@"ProductCategory",
		@"Notes",
		@"Tax",
		@"StockMovementReason",
		nil];
}

- (NSString *)predicateFormatForSearchFieldPredicateIdentifier:(NSString *)predicateIdentifier singleCriteriaFiltering:(BOOL)singleCriteriaFiltering {
	if ( [predicateIdentifier isEqualToString:@"Name"] )
	{
		return @"name CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"NameBeginsWith"] )
	{
		return @"name BEGINSWITH[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"Barcode"] )
	{
		return @"barcode CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"Provider"] )
	{
		return @"(ANY providerProducts.provider.name BEGINSWITH[cd] $value) OR (ANY providerProducts.provider.name ENDSWITH[cd] $value)";
	}
	else if ( [predicateIdentifier isEqualToString:@"Reference"] )
	{
		return @"reference CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"ProductFamily"] )
	{
		return @"productFamily.name CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"Brand"] )
	{
		return @"brand.name CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"ProductCategory"] )
	{
		return @"(ANY productCategories.name BEGINSWITH[cd] $value) OR (ANY productCategories.name ENDSWITH[cd] $value)";
	}
	else if ( [predicateIdentifier isEqualToString:@"Notes"] )
	{
		return @"notes CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"Tax"] )
	{
		return @"taxRate.name CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"StockMovementReason"] )
	{
		if (singleCriteriaFiltering) {
			return @"(ANY stockMovements.reason CONTAINS[cd] $value)";
		}
	}
	
	return nil;
}

- (ProviderProduct *)currentProviderProduct {
	return currentProviderProduct;
}

//- (NSArray *)providersSortDescriptors {
//	NSSortDescriptor * sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
//	
//	return [NSArray arrayWithObjects:sortDescriptor, nil];
//}

- (NSArray *)providerProductsSortDescriptors {
	NSSortDescriptor * sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"provider.name" ascending:YES] autorelease];
	
	return [NSArray arrayWithObjects:sortDescriptor, nil];
}

- (NSArray *)stockMovementsSortDescriptors {
	NSSortDescriptor * sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO] autorelease];
	
	return [NSArray arrayWithObjects:sortDescriptor, nil];
}

#pragma mark READONLY

- (Product *)currentProduct {
	return (Product *)[self currentObject];
}

#pragma mark -
#pragma mark SETTERS

- (void)setNewStockValue:(int)newInt {newStockValue = newInt;}

- (NSRect)setupMultipleObjectsRightStackViewWithFrame:(NSRect)multipleObjectsDetailsViewFrame
{	
	// ...

	[generalViewProductCategoriesPlusMinusView setTarget:self];
	[generalViewProductCategoriesPlusMinusView setPlusAction:@selector(openProductCategoriesBrowser:)];
	[generalViewProductCategoriesPlusMinusView setMinusAction:@selector(removeSelectedProductCategories:)];
	[[generalViewProductCategoriesPlusMinusView minusButton] bind:@"enabled" toObject:productCategoriesArrayController withKeyPath:@"selectedObjects.@count" options:nil];


	[providersViewProviderProductsPlusMinusView setTarget:self];
	[providersViewProviderProductsPlusMinusView setPlusAction:@selector(openProvidersBrowser:)];
	[providersViewProviderProductsPlusMinusView setMinusAction:@selector(removeSelectedProviderProducts:)];
	[[providersViewProviderProductsPlusMinusView minusButton] bind:@"enabled" toObject:providerProductsArrayController withKeyPath:@"selectedObjects.@count" options:nil];	
	
	return [super setupMultipleObjectsRightStackViewWithFrame:multipleObjectsDetailsViewFrame];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateSelectedBrandName:(id *)valueRef error:(NSError **)outError
{
	NSString * newBrandName = (NSString *)*valueRef;
	Brand * selectedBrand = nil;
	
	NSLog (@"validateSelectedBrandName = %@", newBrandName);
	
	if ( nil != newBrandName )
	{
		selectedBrand = [[BrandsModule moduleWithContext:managedObjectContext] managedObjectWithValue:newBrandName forKey:@"name"];
		
		if ( nil == selectedBrand )
		{
			return NO;
		}
	}
	
	// ...
	
	NSArray * selectedProducts = [objectsArrayController selectedObjects];
	
	for (Product *aProduct in selectedProducts) {		
		[aProduct setBrand:selectedBrand];
	}
	
	return YES;
}

- (BOOL)validateSelectedProductFamilyName:(id *)valueRef error:(NSError **)outError
{
	NSString * newProductFamilyName = (NSString *)*valueRef;
	ProductFamily * selectedProductFamily = nil;
	
	NSLog (@"validateSelectedProductFamilyName = %@", newProductFamilyName);
	
	if ( nil != newProductFamilyName )
	{
		selectedProductFamily = [[ProductFamiliesModule moduleWithContext:managedObjectContext] managedObjectWithValue:newProductFamilyName forKey:@"name"];
		
		if ( nil == selectedProductFamily )
		{
			return NO;
		}
	}
	
	// ...
	
	NSArray * selectedProducts = [objectsArrayController selectedObjects];
	Product * aProduct = nil;		
	
	for ( aProduct in selectedProducts )
	{		
		[aProduct setProductFamily:selectedProductFamily];
	}
	
	return YES;
}

#pragma mark -
#pragma mark MISC

- (void)didSelect {
	[super didSelect];
	
	//NSLog (@"didSelect");
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barcodeScannerDidEndScanning:) name:FKBarcodeScannerDidEndScanningNotification object:nil];
	
	//NSLog (@"/didSelect");
	
	/*NSEnumerator * productsEnum = [[objectsArrayController arrangedObjects] objectEnumerator];
	Product * aProduct = nil;
	
	while ( aProduct = [productsEnum nextObject] )
	{
		[aProduct setBarcodeImage:nil];
	}*/
}

- (void)didUnselect
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKBarcodeScannerDidEndScanningNotification object:nil];
}

- (void)barcodeScannerDidEndScanning:(NSNotification *)notification
{
	NSLog (@"barcodeScannerDidEndScanning");
	
	FKBarcodeScanner * barcodeScanner = [notification object];
	NSString * barcodeString = [barcodeScanner lastScannedString];
	
	// ...
		
	NSWindow * window = [moduleView window];
	
	if ( [window firstResponderTextField] == barcodeTextField )
	{
		[[objectsArrayController selectedObjects] makeObjectsPerformSelector:@selector(setBarcode:) withObject:barcodeString];
	}
	else
	{
		// On recherche les produits dont le code barre est barcodeString
		
		NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
		NSEntityDescription * fetchEntity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:managedObjectContext];
		NSPredicate * fetchPredicate = [NSPredicate predicateWithFormat:@"barcode LIKE %@", barcodeString];
		
		[fetchRequest setEntity:fetchEntity];
		[fetchRequest setPredicate:fetchPredicate];
		
		NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
		
		if ( [results count] > 0 )
		{
			[objectsArrayController setSelectedObjects:results];
		}
		else
		{
			NSBeep();
		}
	}
}

#pragma mark -
#pragma mark LAYOUT

- (void)finalizeSetupModuleViewUsingFullStyle {
	[multipleObjectsLeftTableView sizeLastColumnToFit];
}

- (void)finalizeSetupModuleViewUsingMiniStyle
{
	[super finalizeSetupModuleViewUsingMiniStyle];
	
	// ...
	
	NSTableColumn * iconTableColumn = [[multipleObjectsLeftTableView tableColumns] objectAtIndex:0];
	
	//[iconTableColumn setWidth:16.0];
	//[iconTableColumn setMinWidth:16.0];
	//[iconTableColumn setMaxWidth:16.0];
}

#pragma mark -
#pragma mark MULTIPLE VALUES SUPPORT

- (NSArray *)intersectionOfProductCategories
{
	NSMutableSet * intersectionOfProductCategories = nil;
	
	NSArray * selectedProducts = [objectsArrayController selectedObjects];
	Product * aProduct = nil;
	
	for ( aProduct in selectedProducts )
	{		
		if ( nil == intersectionOfProductCategories )
		{
			intersectionOfProductCategories = [NSMutableSet setWithSet:[aProduct mutableSetValueForKey:@"productCategories"]];
		}
		else
		{
			[intersectionOfProductCategories intersectSet:[aProduct mutableSetValueForKey:@"productCategories"]];
		}
	}
	
	return [intersectionOfProductCategories allObjects];
}

- (NSArray *)intersectionOfProviderProducts
{
	NSMutableArray * intersectionOfProviderProducts = [NSMutableArray array];
	
	NSArray * selectedProducts = [objectsArrayController selectedObjects];
	Product * aProduct = nil;
	NSMutableSet * intersectionOfProvidersSet = nil;
	
	NSArray * providerProductsArray = nil;
	ProviderProduct * aProviderProduct = nil;
	
	// On commence par recuperer la liste des fournisseurs communs aux produits selectionnes
	
	for ( aProduct in selectedProducts )
	{
		if ( nil == intersectionOfProvidersSet )
		{
			intersectionOfProvidersSet = [NSMutableSet setWithSet:[aProduct mutableSetValueForKeyPath:@"providerProducts.provider"]];
		}
		else
		{
			[intersectionOfProvidersSet intersectSet:[aProduct mutableSetValueForKeyPath:@"providerProducts.provider"]];
		}
	}
	
	// ...
	
	FKMultipleValuesProxy * aProxy = nil;
	
	NSArray * intersectionOfProviders = [intersectionOfProvidersSet allObjects];
	Provider * aProvider = nil;
	
	for ( aProvider in intersectionOfProviders )
	{
		aProxy = [[[FKMultipleValuesProxy alloc] init] autorelease];
		
		for ( aProduct in selectedProducts )
		{
			providerProductsArray = [[aProduct mutableSetValueForKey:@"providerProducts"] allObjects];
			
			for ( aProviderProduct in providerProductsArray )
			{
				if ( [aProviderProduct provider] == aProvider )
				{
					[aProxy addObject:aProviderProduct];
				}
			}
		}
		
		[intersectionOfProviderProducts addObject:aProxy];
	}
	
	return intersectionOfProviderProducts;
}

#pragma mark -
#pragma mark ACTIONS

- (void)addProductAction:(id)sender
{
	[self addObject];
}

- (void)listViewEditButtonAction:(id)sender
{
	[self editCurrentProduct];
}

- (void)editProductAction:(id)sender
{
	[self editSelectedObject];
}

- (void)deleteAction:(id)sender
{
	[self deleteSelectedObjects];
}

- (void)exportPanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo {
	if (returnCode == NSOKButton) {				
		NSMutableArray * csvArray = [NSMutableArray array];		
		NSMutableString * csvString = [NSMutableString string];
		NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		FKDecimalFormatter * decimalFormatter = [[[FKDecimalFormatter alloc] init] autorelease];
		FKPercentFormatter * percentFormatter = [[[FKPercentFormatter alloc] init] autorelease];
		
		[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		
		NSError * error = nil;

		// En-tete
		
		[csvArray addObject:NSLocalizedString(@"Reference", @"")];
		[csvArray addObject:NSLocalizedString(@"Code barre", @"")];
		[csvArray addObject:NSLocalizedString(@"Marque", @"")];
		[csvArray addObject:NSLocalizedString(@"Famille", @"")];
		[csvArray addObject:NSLocalizedString(@"Stock actuel", @"")];
		[csvArray addObject:NSLocalizedString(@"En vente", @"")];
		[csvArray addObject:NSLocalizedString(@"Nom", @"")];
		[csvArray addObject:NSLocalizedString(@"Notes", @"")];
		[csvArray addObject:NSLocalizedString(@"Prix de vente HT", @"")];
		[csvArray addObject:NSLocalizedString(@"Prix d'achat HT", @"")];
		[csvArray addObject:NSLocalizedString(@"Taux de TVA", @"")];
		[csvArray addObject:NSLocalizedString(@"Fournisseur", @"")];
		
		[csvString appendFormat:@"%@\n", [csvArray componentsJoinedByString:@";"]];
		
		// ...
		
		for (Product * aProduct in [objectsArrayController arrangedObjects]) {				
			ProviderProduct * mainProviderProduct = nil;
			Provider * mainProvider = nil;
			
			if ([aProduct.providerProducts count] > 0) {
				
				mainProviderProduct = (ProviderProduct *)[[aProduct.providerProducts allObjects] objectAtIndex:0];
				mainProvider = mainProviderProduct.provider;
			}
			
			csvArray = [NSMutableArray array];
			
			[csvArray addObject:[self csvStringForValue:aProduct.reference]];
			[csvArray addObject:[self csvStringForValue:aProduct.barcode]];
			[csvArray addObject:[self csvStringForValue:aProduct.brand.name]];
			[csvArray addObject:[self csvStringForValue:aProduct.productFamily.name]];
			[csvArray addObject:[self csvStringForValue:aProduct.currentStock]];
			[csvArray addObject:[self csvStringForValue:aProduct.isDiscontinued]];	
			[csvArray addObject:[self csvStringForValue:aProduct.name]];
			[csvArray addObject:[self csvStringForValue:aProduct.notes]];
			[csvArray addObject:[self csvStringForValue:aProduct.unitPriceHT formatter:decimalFormatter]];
			
			if (mainProviderProduct != nil) {
				[csvArray addObject:[self csvStringForValue:mainProviderProduct.providerPriceHT formatter:decimalFormatter]];
			}
			else {
				[csvArray addObject:[self csvStringForValue:[NSString string]]];
			}
			
			[csvArray addObject:[self csvStringForValue:aProduct.taxRate.rate formatter:percentFormatter]];
			[csvArray addObject:[self csvStringForValue:mainProvider.name]];
			
			[csvString appendFormat:@"%@\n", [csvArray componentsJoinedByString:@";"]];
		}
		
		if (![csvString writeToFile:[sheet filename] atomically:YES encoding:NSUnicodeStringEncoding error:&error]) {
			[self presentError:error];
		}
	}
}

/*- (void)receiveProductsAction:(id)sender
{
	IncomingProductsManager * incomingProductsManager = [[[IncomingProductsManager alloc] initWithWindowNibName:@"IncomingProducts"] autorelease];
	
	NSWindow * incomingProductsWindow = [incomingProductsManager window];
	
	[NSApp beginSheet:incomingProductsWindow modalForWindow:[moduleView window]
		modalDelegate:self
	   didEndSelector:nil
		  contextInfo:nil];
}*/

#pragma mark ACTIONS : REMOVE

- (IBAction)removeSelectedProviderProducts:(id)sender{	
	NSArray * selectedProducts = [objectsArrayController selectedObjects];
	Product * aProduct = nil;
	
	// Recuperation de la liste des ProviderProduct selectionnees
	
	NSArray * selectedProviderProducts = [providerProductsArrayController selectedObjects];
	ProviderProduct * aProviderProduct = nil;
	
	for (aProduct in selectedProducts) {
		for (aProviderProduct in selectedProviderProducts) {
			[aProduct removeProviderProductsObject:aProviderProduct];
			[managedObjectContext deleteObject:aProviderProduct];
		}
	}
}

- (IBAction)removeSelectedProductCategories:(id)sender
{
	// ...
	
	NSArray * selectedProducts = [objectsArrayController selectedObjects];
	Product * aProduct = nil;
	
	// Recuperation de la liste des categories selectionnees
	
	NSArray * selectedCategories = [productCategoriesArrayController selectedObjects];
	NSEnumerator * categoriesEnumerator = nil;
	ProductCategory * aCategory = nil;
	
	for ( aProduct in selectedProducts )
	{
		
		for ( aCategory in selectedCategories )
		{
			[aProduct removeProductCategoriesObject:aCategory];
		}
	}
}

#pragma mark BROWSERS

- (IBAction)openProductCategoriesBrowser:(id)sender
{
	ProductCategoriesModule * productCategoriesModule = [ProductCategoriesModule moduleWithContext:managedObjectContext];
	
	// ...
	
	NSArray * selectedProductCategories = nil;
	NSEnumerator * productCategoriesEnumerator = nil;
	Provider * aProductCategory = nil;
	
	// ...
	
	[productCategoriesModule showBrowserWindowModalForWindow:[NSApp mainWindow] selectedObjects:&selectedProductCategories];
	
	// ...
	
	ProviderProduct * newProviderProduct = nil;
	
	NSArray * selectedProducts = [objectsArrayController selectedObjects];
	Product * aProduct = nil;
	
	for ( aProduct in selectedProducts )
	{
		
		for ( aProductCategory in selectedProductCategories )
		{
			[aProduct addProductCategoriesObject:aProductCategory];
		}
	}
}

- (IBAction)openProvidersBrowser:(id)sender {
	ProvidersModule * providersModule = [ProvidersModule moduleWithContext:managedObjectContext];
	NSArray * selectedProviders = nil;
	
	[providersModule showBrowserWindowModalForWindow:[NSApp mainWindow] selectedObjects:&selectedProviders];
	
	ProviderProduct * newProviderProduct = nil;	
	NSArray * selectedProducts = [objectsArrayController selectedObjects];
	
	for (Product * aProduct in selectedProducts) {
		for (Provider * aProvider in selectedProviders) {
			newProviderProduct = [NSEntityDescription insertNewObjectForEntityForName:@"ProviderProduct" inManagedObjectContext:managedObjectContext];
			
			[newProviderProduct setProduct:aProduct];
			[newProviderProduct setProvider:aProvider];
			
			[aProduct addProviderProductsObject:newProviderProduct];
		}
	}
}

- (IBAction)openStockCorrectionSheet:(id)sender
{	
	[self setNewStockValue:[[[objectsArrayController selection] valueForKey:@"currentStock"] intValue]];
	
	[NSApp beginSheet:stockCorrectionSheet
	   modalForWindow:[NSApp mainWindow]
		modalDelegate:self
	   didEndSelector:@selector(stockCorrectionSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (IBAction)closeStockCorrectionSheet:(id)sender
{	
	[NSApp endSheet:stockCorrectionSheet returnCode:[sender tag]];
}

- (void)stockCorrectionSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{	
	[sheet makeFirstResponder:nil];
	[sheet orderOut:self];

	NSLog (@"DEBUT stockCorrectionSheetDidEnd");	
	
	if (returnCode == NSOKButton) {
		NSArray * selectedProducts = [objectsArrayController selectedObjects];
		Product * aProduct = nil;
		
		StockMovement * aStockMovement = nil;
		
		int oldStockValue = 0;
		int stockDelta = 0;
		
		for ( aProduct in selectedProducts )
		{
			oldStockValue = [[aProduct currentStock] intValue];
			
			stockDelta = newStockValue - oldStockValue;
			
			if ( stockDelta != 0 )
			{					
				// On verifie s'il y a un inventaire en cours...
				
				Inventory * runningInventory = [Inventory runningInventory];
								
				// ...et si c'est le cas, on lui affecte le mouvement de stock
				
				if ( nil != runningInventory )
				{									
					// Par precaution, on verifie que le produit n'ait pas deja fait l'objet d'un
					// mouvement de stock au cours de l'inventaire, auquel cas on met simplement
					// a jour la variation de quantite
					
					NSMutableSet * stockMovements = [runningInventory mutableSetValueForKey:@"stockMovements"];
					NSEnumerator * stockMovementsEnumerator = [stockMovements objectEnumerator];
					
					while ( aStockMovement = [stockMovementsEnumerator nextObject] )
					{
						if ( [aStockMovement product] == aProduct )
						{							
							break;
						}
					}
					
					if ( nil == aStockMovement )
					{
						// ...
						
						aStockMovement = [NSEntityDescription insertNewObjectForEntityForName:@"StockMovement" inManagedObjectContext:[aProduct managedObjectContext]];
						
						[aStockMovement setProduct:aProduct];
					}
					else
					{
						// On recupere la photographie initiale du stock de l'inventaire
						
						NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
						NSEntityDescription * entity = [NSEntityDescription entityForName:@"StockSnapshotLine" inManagedObjectContext:managedObjectContext];
						NSPredicate * predicate = [NSPredicate predicateWithFormat:@"stockSnapshot == %@ AND product == %@", [runningInventory beginStockSnapshot], aProduct];
						
						[fetchRequest setEntity:entity];
						[fetchRequest setPredicate:predicate];
						
						NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
						
						StockSnapshotLine * aLine = nil;
						
						NSNumber * initialStock = nil;
						
						if ( [results count] > 0 )
						{
							aLine = [results objectAtIndex:0];
							
							initialStock = [aLine quantity];
						}
						else
						{
							// Le produit n'est pas present dans la photographie de stock initiale
							// de l'inventaire : il s'agit d'un produit qui a ete ajoute en cours
							// d'inventaire, son stock initial est donc nul
							
							initialStock = [NSNumber numberWithInt:0];
						}
						
						[aProduct setCurrentStock:initialStock];
						
						stockDelta = newStockValue - [initialStock intValue];
					}
					
					[aStockMovement setDate:[NSDate date]];
					[aStockMovement setQuantity:[NSNumber numberWithInt:stockDelta]];
					[aStockMovement setInventory:runningInventory];
					[aStockMovement setReason:[NSString stringWithFormat:@"Inventaire '%@'", [runningInventory name]]];
				}
				
				// ...
				
				if (nil == aStockMovement) {
					aStockMovement = [NSEntityDescription insertNewObjectForEntityForName:@"StockMovement" inManagedObjectContext:[aProduct managedObjectContext]];
					
					[aStockMovement setProduct:aProduct];
					[aStockMovement setDate:[NSDate date]];
					[aStockMovement setReason:newStockReason];
					[aStockMovement setQuantity:[NSNumber numberWithInt:stockDelta]];
				}
				
				NSLog(@" aStockMovement = %@", aStockMovement);
				
				// ...
				
				[aProduct setCurrentStock:[NSNumber numberWithInt:newStockValue]];
				
				NSLog(@"  aProduct = %@", aStockMovement);
			}
		}
	}
	
	// ...
	
	NSError *error = nil;
	
	if (![managedObjectContext save:&error]) {
		NSLog(@"******ERREUR*********");
		NSLog(@"%@", error);
		
		[self presentError:error];
	}
	
	NSLog (@"FIN stockCorrectionSheetDidEnd");	
}

- (IBAction)testAction:(id)sender
{
}

- (void)printDialogSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	[super printDialogSheetDidEnd:sheet returnCode:returnCode contextInfo:contextInfo];
		
	NSPrintInfo* prInfo = [ NSPrintInfo sharedPrintInfo ];
	
	[prInfo setVerticallyCentered:NO];
	[prInfo setTopMargin:0.0];
	[prInfo setLeftMargin:0.0];
	[prInfo setRightMargin:0.0];
	[prInfo setBottomMargin:0.0];
	[prInfo setOrientation:NSLandscapeOrientation];
	[prInfo setHorizontalPagination:NSFitPagination ]; // scales to fit page width
		
	[[[[testWebView mainFrame] frameView] documentView] print:self];
}

#pragma mark -
#pragma mark MODULE SUPPORT

#pragma mark -
#pragma mark FKStackView DELEGATE

- (unsigned)stackViewNumberOfStackedViews:(FKStackView *)aStackView
{
	return 3;
}

- (NSView *)stackView:(FKStackView *)aStackView stackedViewAtIndex:(int)viewIndex
{
	switch (viewIndex)
	{
		case 0 : {return generalView;}
		case 1 : {return providersView;}
		case 2 : {return stockView;}
		case 3 : {return imagesView;}
	}
	
	return nil;
}

- (void)stackView:(FKStackView *)stackView finalizeStackedView:(FKStackableView **)stackedView atIndex:(unsigned)viewIndex
{	
	FKStackableView * theView = *stackedView;
	
	switch (viewIndex)
	{
		case 0 :
		{
			[theView setTitle:NSLocalizedString(@"GeneralInformations", @"")];
			[theView setImage:[NSImage imageNamed:@"NSInfo"]];
			[theView setFirstResponder:generalViewFirstResponder];
			[theView setLastResponder:generalViewLastResponder];
			
			break;
		}
		case 1 :
		{
			[theView setTitle:@"Tarifs et fournisseurs"];
			[theView setFirstResponder:providersViewFirstResponder];
			[theView setLastResponder:providersViewLastResponder];
			
			break;
		}
		case 2 :
		{
			[theView setTitle:@"Stock"];
			[theView setFirstResponder:stockViewFirstResponder];
			[theView setLastResponder:stockViewLastResponder];
			
			break;
		}
		case 3 :
		{
			[theView setTitle:@"Images"];
			[theView setFirstResponder:imagesViewFirstResponder];
			[theView setLastResponder:imagesViewLastResponder];
			
			break;
		}
	}
}

#pragma mark -
#pragma mark FKModuleToolbar DELEGATE

- (int)moduleToolbarNumberOfAreas:(FKModuleToolbar *)aToolbar {
	int moduleToolbarNumberOfAreas = [super moduleToolbarNumberOfAreas:aToolbar];
	
	if ( aToolbar == multipleObjectsFilterBar )
	{
		moduleToolbarNumberOfAreas = 2;
	}
	else if ( aToolbar == multipleObjectsToolbar )
	{
		moduleToolbarNumberOfAreas = 1;
	}
	
	return moduleToolbarNumberOfAreas;
}

- (NSArray *)moduleToolbarItemIdentifiers:(FKModuleToolbar *)aToolbar forAreaAtIndex:(int)areaIndex {
	NSArray * moduleToolbarItemIdentifiers = [super moduleToolbarItemIdentifiers:aToolbar forAreaAtIndex:areaIndex];
	
	if ( aToolbar == multipleObjectsFilterBar ) {
		if ( areaIndex == 0 ) {
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"All", @"InStock", @"OutOfStock", nil];
		}
		else if ( areaIndex == 1 ) {
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"All", @"NotDiscontinued", @"Discontinued", nil];
		}
	}
	else if ( aToolbar == multipleObjectsToolbar ) {
		if ( areaIndex == 0 ) {
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"AddProduct", @"Delete", FKModuleToolbarSeparatorItemIdentifier, @"ReceiveProducts", nil];
		}
	}
	
	return moduleToolbarItemIdentifiers;
}

- (BOOL)validateModuleToolbarItem:(FKModuleToolbarItem *)theItem {
	NSString * itemIdentifier = [theItem itemIdentifier];
	
	if ([itemIdentifier isEqualToString:@"Delete"]) {
		return NO;
	}	
	
	if ([itemIdentifier isEqualToString:@"EditProduct"] ||
		[itemIdentifier isEqualToString:@"Delete"]) {
		return (nil != self.currentProduct);
	}
		
	return YES;
}

#pragma mark -
#pragma mark FKModuleFilterBar DELEGATE

- (NSString *)filterBar:(FKModuleFilterBar *)aToolbar predicateFormatForItemIdentifier:(NSString *)anItemIdentifier
{
	if ( [anItemIdentifier isEqualToString:@"All"] ) {return @"TRUEPREDICATE";}
	else if ( [anItemIdentifier isEqualToString:@"InStock"] ) {return @"currentStock > 0";}
	else if ( [anItemIdentifier isEqualToString:@"OutOfStock"] ) {return @"currentStock < 1";}	
	else if ( [anItemIdentifier isEqualToString:@"NotDiscontinued"] ) {return @"isDiscontinued == FALSE";}	
	else if ( [anItemIdentifier isEqualToString:@"Discontinued"] ) {return @"isDiscontinued == TRUE";}	
	return nil;
}

#pragma mark -
#pragma mark NSTableView DATASOURCE

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
	NSMutableArray * draggedProductsURIs = [NSMutableArray array];
	
	NSArray * draggedProductsArray = [(NSArray *)[objectsArrayController arrangedObjects] objectsAtIndexes:rowIndexes];
	Product * aDraggedProduct = nil;
	
	NSURL * aDraggedProductURI = nil;
	
	for ( aDraggedProduct in draggedProductsArray )
	{
		aDraggedProductURI = [[aDraggedProduct objectID] URIRepresentation];
		
		[draggedProductsURIs addObject:aDraggedProductURI];
	}
	
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:draggedProductsURIs];
	
	[pboard declareTypes:[NSArray arrayWithObject:ProductPBoardDataType] owner:self];
    [pboard setData:data forType:ProductPBoardDataType];
	
	return YES;
}

#pragma mark -
#pragma mark LAYOUT

@synthesize productCategoriesArrayController;
@synthesize providerProductsArrayController;
@synthesize generalView;
@synthesize generalViewFirstResponder;
@synthesize generalViewLastResponder;
@synthesize generalViewProductCategoriesPlusMinusView;
@synthesize providersView;
@synthesize providersViewFirstResponder;
@synthesize providersViewLastResponder;
@synthesize providersViewProviderProductsPlusMinusView;
@synthesize imagesView;
@synthesize imagesViewFirstResponder;
@synthesize imagesViewLastResponder;
@synthesize stockView;
@synthesize stockViewFirstResponder;
@synthesize stockViewLastResponder;
@synthesize barcodeTextField;
@synthesize currentProductCategory;
@synthesize stockCorrectionSheet;
@synthesize printDialogMatrix;
@synthesize printMatrixPopUpButton;
@synthesize testView;
@synthesize testWebView;
@synthesize newStockValue;
@synthesize newStockReason;

@end
