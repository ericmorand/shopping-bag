//
//  SalesModule.m
//  ShoppingBag
//
//  Created by Eric on 01/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "SalesModule.h"
#import "CustomersModule.h"
#import "PaymentMethodsModule.h"
#import "ProductsModule.h"
#import "StockMovement.h"
#import "Product.h"
#import "TaxRate.h"
#import "Brand.h"
#import "ProductFamily.h"
#import "Provider.h"

@interface SalesModule (Private)

- (id)objectWithURI:(NSURL *)anURI;

- (void)addSale;
- (void)addProduct:(Product *)aProduct;
- (void)setCustomer:(Customer *)aCustomer;

- (void)printInvoice;
- (void)printReceipt;

@end

@implementation SalesModule

@synthesize editModeSplitView;
@synthesize editModeSaleView;
@synthesize editModeTabView;
@synthesize productsModule;
@synthesize customersModule;
@synthesize generalInformationsView;
@synthesize generalInformationsViewFirstResponder;
@synthesize generalInformationsViewLastResponder;
@synthesize productsView;
@synthesize productsViewFirstResponder;
@synthesize productsViewLastResponder;
@synthesize saleLinesController;
@synthesize paymentMethodsController;
@synthesize paySheet;
@synthesize currentPaymentMethod;
@synthesize exportsLines;

- (id)initWithContext:(NSManagedObjectContext *)aContext userInfo:(NSDictionary *)aDictionary {
	self = [super initWithContext:aContext userInfo:aDictionary];
	
	if (nil != self)
	{		
		NSSortDescriptor * sortDescriptor = nil;
		
		// paymentMethodsController
		
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
	
		[paymentMethodsController setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		
		// saleLinesController
		
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:YES selector:@selector(compare:)] autorelease];
		
		[saleLinesController setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
		
		// salesController
				
		sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"saleNumber.intValue" ascending:NO selector:@selector(compare:)] autorelease];
		
		self.objectsArrayControllerSortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
		
		// exportsLines
		
		self.exportsLines = YES;
		
		// External modules
		
		self.productsModule = (ProductsModule *)[[NSApp delegate] moduleNamed:@"Products"];
		self.customersModule = (CustomersModule *)[[NSApp delegate] moduleNamed:@"Customers"];
	}
	
	return self;
}

#pragma mark -
#pragma mark GETTERS

- (NSString *)name {
	return @"Sales";
}

- (NSString *)entityName {
	return @"Sale";
}

#pragma mark READONLY

- (NSString *)statusString {
	NSMutableString * result = [NSMutableString stringWithString:[super statusString]];
	
	NSDecimalNumber * totalTTC = [[objectsArrayController arrangedObjects] valueForKeyPath:@"@sum.discountedTotalTTC"];
	FKCurrencyFormatter * formatter = [[[FKCurrencyFormatter alloc] init] autorelease];
		
	[result appendFormat:@", %@", [formatter stringForObjectValue:totalTTC]];
	
	return result;
}

- (Sale *)currentSale {
	return (Sale *)[self currentObject];
}

- (NSArray *)searchFieldPredicateIdentifiers {
	return [NSArray arrayWithObjects:
		@"Number",
		@"Customer",
		@"ProductName",
		@"ProductBarcode",
		@"ProductReference",
		//@"PaymentMethod",
		nil];
}

- (NSString *)predicateFormatForSearchFieldPredicateIdentifier:(NSString *)predicateIdentifier {
	if ( [predicateIdentifier isEqualToString:@"Number"] )
	{
		return @"saleNumber CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"Customer"] )
	{
		return @"customer.name CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"ProductName"] )
	{
		return @"(ANY saleLines.product.name BEGINSWITH[cd] $value) OR (ANY saleLines.product.name ENDSWITH[cd] $value)";
	}
	else if ( [predicateIdentifier isEqualToString:@"ProductBarcode"] )
	{
		return @"(ANY saleLines.product.barcode BEGINSWITH[cd] $value) OR (ANY saleLines.product.barcode ENDSWITH[cd] $value)";
	}
	else if ( [predicateIdentifier isEqualToString:@"ProductReference"] )
	{
		return @"(ANY saleLines.product.reference BEGINSWITH[cd] $value) OR (ANY saleLines.product.reference ENDSWITH[cd] $value)";
	}
	else if ( [predicateIdentifier isEqualToString:@"PaymentMethod"] )
	{
		return @"(ANY saleLines.product.name BEGINSWITH[cd] $value) OR (ANY saleLines.provider.name ENDSWITH[cd] $value)";
	}
	
	return nil;
}

#pragma mark -
#pragma mark ACTIONS

- (void)addSaleAction:(id)sender {
	[self addSale];
}

- (void)addSale {
	[objectsArrayController addObject:[NSEntityDescription insertNewObjectForEntityForName:@"Sale" inManagedObjectContext:managedObjectContext]];
	
	NSUndoManager * undoManager = [managedObjectContext undoManager];
	
	// ...
	
    [managedObjectContext processPendingChanges];
	[objectsArrayController setSelectedObjects:[NSArray arrayWithObject:self.currentSale]];
	
	// ...
	
	if ( moduleMode == FKModuleMultipleObjectsMode )
	{
		[self switchToSingleObjectMode];
	}	
	
	// ...
	
	[undoManager registerUndoWithTarget:self selector:@selector(undoInsertSale:) object:self.currentSale];
	[undoManager setActionName:self.currentSale.displayName];
}

- (void)undoInsertSale:(Sale *)newSale {
	NSUndoManager * undoManager = [managedObjectContext undoManager];
	
	[managedObjectContext deleteObject:newSale];
	
	// ...
	
	if ( moduleMode == FKModuleSingleObjectMode )
	{
		[self switchToMultipleObjectsMode];
	}
	
	// ...
	
	[undoManager registerUndoWithTarget:self selector:@selector(insertSale:) object:newSale];
	[undoManager setActionName:[newSale displayName]];
}

- (void)editAction:(id)sender {
	[self switchToSingleObjectMode];
}

- (void)deleteAction:(id)sender {
	NSArray * selectedSales = [objectsArrayController selectedObjects];
	
	// ...
	
	NSAlert * deleteAlert = [[[NSAlert alloc] init] autorelease];
	
	NSString * messageText = nil;
	NSString * informativeText = nil;
	
	int count = [selectedSales count];
	
	[deleteAlert addButtonWithTitle:NSLocalizedString(@"Delete", @"")];
	[deleteAlert addButtonWithTitle:NSLocalizedString(@"Cancel", @"")];
	
	if ( count > 1 )
	{
		messageText = [NSString stringWithFormat:NSLocalizedString(@"DeleteMultipleSalesAlertMessageText", @""), count];
	}
	else
	{
		messageText = [NSString stringWithFormat:NSLocalizedString(@"DeleteSingleSaleAlertMessageText", @""), count];
	}

	informativeText = NSLocalizedString(@"DeleteSalesAlertInformativeText", @"");
	
	[deleteAlert setMessageText:messageText];
	[deleteAlert setInformativeText:informativeText];
	
	[deleteAlert beginSheetModalForWindow:[moduleView window]
							modalDelegate:self
						   didEndSelector:@selector(deleteAlertDidEnd:returnCode:contextInfo:)
							  contextInfo:selectedSales];
}

- (void)deleteAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo; {	
	if ( returnCode == NSAlertFirstButtonReturn )
	{
		NSArray * selectedSales = contextInfo;		
		Sale * aSale = nil;
		
		NSMutableSet * saleLines = nil;
		SaleLine * aSaleLine = nil;
		
		StockMovement * aStockMovement = nil;
		Product * aProduct = nil;
		
		int quantity = 0;
		int currentStock = 0;
		int newStock = 0;
		
		for (aSale in selectedSales)
		{			
			// SaleLines
		
			saleLines = [aSale mutableSetValueForKey:@"saleLines"];
			
			for ( aSaleLine in saleLines )
			{
				aProduct = [aSaleLine product];
				aStockMovement = [aSaleLine stockMovement];
				
				if ( nil != aStockMovement )
				{
					// On reaffecte le stock
				
					quantity = [[aStockMovement quantity] intValue];
					currentStock = [[aProduct currentStock] intValue];
				
					newStock = currentStock - quantity; // ex : 5 - (-4) = 9
				
					[aProduct setCurrentStock:[NSNumber numberWithInt:newStock]];
				
					// On supprime le mouvement de stock
				
					[managedObjectContext deleteObject:aStockMovement];
				}
				
				// On supprime la ligne
				
				[managedObjectContext deleteObject:aSaleLine];
			}
			
			// On supprime la vente
			
			[managedObjectContext deleteObject:aSale];
			
			// ...
			
			if ( moduleMode == FKModuleSingleObjectMode )
			{
				[self switchToMultipleObjectsMode];
			}
		}
	}
}

- (void)exitAction:(id)sender {
	NSError *error = nil;
	
	if (![managedObjectContext save:&error]) {
		NSLog(@"******ERREUR*********");
		NSLog(@"%@", error);
		
		[self presentError:error];
	}	
	
	[self switchToMultipleObjectsMode];	
}

- (void)listViewTableViewDoubleAction:(id)sender {
	[self editAction:sender];
}

- (void)payAction:(id)sender {
	[[moduleView window] makeFirstResponder:nil];
	
	if ( nil == currentPaymentMethod )
	{
		NSArray * arrangedObjects = [paymentMethodsController arrangedObjects];
		
		if ( [arrangedObjects count] > 0 )
		{
			[self setCurrentPaymentMethod:[arrangedObjects objectAtIndex:0]];
		}
	}
	
	[NSApp beginSheet:paySheet modalForWindow:[moduleView window] modalDelegate:self didEndSelector:@selector(paySheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)printInvoiceAction:(id)sender {
	[self printInvoice];
}

- (IBAction)printReceiptAction:(id)sender {
	[self printReceipt];
}

- (void)printInvoice {
	FKPrintManager * printManager = [FKPrintManager defaultManager];
	
	printManager.printingOrientation = NSPortraitOrientation;	
	
	Sale * selectedSale = [[objectsArrayController selectedObjects] objectAtIndex:0];
	
	[printManager printTemplate:@"SaleInvoice" withObject:selectedSale cssFileName:@"ShoppingBag" customPaperName:nil];
}

- (void)printReceipt {
	FKPrintManager * printManager = [FKPrintManager defaultManager];
	
	printManager.printingOrientation = NSPortraitOrientation;
	
	Sale * selectedSale = [[objectsArrayController selectedObjects] objectAtIndex:0];
	
	[printManager printTemplate:@"SaleReceipt" withObject:selectedSale cssFileName:@"ShoppingBag" customPaperName:@"A6"];
}

- (void)deleteKeyDown:(id)sender {	
	SaleLine * saleLine = saleLinesController.selectedObject;
	
	[saleLinesController removeObject:saleLine];
}

#pragma mark -
#pragma mark EXPORTATION

- (void)exportPanelDidEnd:(NSSavePanel *)sheet returnCode:(int)returnCode contextInfo:(void  *)contextInfo {
	if (returnCode == NSOKButton) {
		NSMutableArray * csvArray = nil;
		NSMutableString * csvString = [NSMutableString string];
		NSDateFormatter * dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		FKDecimalFormatter * decimalFormatter = [[[FKDecimalFormatter alloc] init] autorelease];
		FKPercentFormatter * percentFormatter = [[[FKPercentFormatter alloc] init] autorelease];

		[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
		[dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];	
		
		// En-tete
		
		csvArray = [NSMutableArray array];
		
		[csvArray addObject:NSLocalizedString(@"SaleNumber", @"")];
		[csvArray addObject:NSLocalizedString(@"Date", @"")];
		[csvArray addObject:NSLocalizedString(@"Customer", @"")];
		
		if (exportsLines) {
			[csvArray addObject:NSLocalizedString(@"Product", @"")];
			[csvArray addObject:NSLocalizedString(@"Reference", @"")];
			[csvArray addObject:NSLocalizedString(@"Brand", @"")];
			[csvArray addObject:NSLocalizedString(@"ProductFamily", @"")];
			[csvArray addObject:NSLocalizedString(@"PrimaryProvider", @"")];
			[csvArray addObject:NSLocalizedString(@"Quantity", @"")];
		}
		
		[csvArray addObject:NSLocalizedString(@"DiscountRate", @"")];
		[csvArray addObject:NSLocalizedString(@"TaxRate", @"")];
		[csvArray addObject:NSLocalizedString(@"TotalTTC", @"")];
		[csvArray addObject:NSLocalizedString(@"PaymentMethod", @"")];
		
		[csvString appendFormat:@"%@\n", [csvArray componentsJoinedByString:@";"]];
		
		// ...
		
		NSString * saleNumberStr = nil;
		NSString * dateStr = nil;
		NSString * customerStr = nil;
		NSString * discountStr = nil;
		NSString * totalStr = nil;
		NSString * paymentMethodStr = nil;
		
		for (Sale * aSale in [objectsArrayController arrangedObjects]) {			
			saleNumberStr = [self csvStringForValue:aSale.saleNumber];
			dateStr = [self csvStringForValue:aSale.date formatter:dateFormatter];
			customerStr = [self csvStringForValue:aSale.customer.name];
			discountStr = [self csvStringForValue:aSale.discountRate formatter:percentFormatter];
			totalStr = [self csvStringForValue:aSale.discountedTotalTTC formatter:decimalFormatter];
			paymentMethodStr = [self csvStringForValue:aSale.paymentMethod.name];
			
			if (exportsLines) {
				for (SaleLine * aSaleLine in aSale.saleLines) {
					csvArray = [NSMutableArray array];
										
					[csvArray addObject:saleNumberStr];
					[csvArray addObject:dateStr];
					[csvArray addObject:customerStr];
					[csvArray addObject:[self csvStringForValue:aSaleLine.product.name]];
					[csvArray addObject:[self csvStringForValue:aSaleLine.product.reference]];
					[csvArray addObject:[self csvStringForValue:aSaleLine.product.brand.name]];
					[csvArray addObject:[self csvStringForValue:aSaleLine.product.productFamily.name]];
					[csvArray addObject:[self csvStringForValue:aSaleLine.product.primaryProvider.name]];
					[csvArray addObject:[self csvStringForValue:aSaleLine.quantity]];
					[csvArray addObject:[self csvStringForValue:aSaleLine.discountRate formatter:percentFormatter]];
					[csvArray addObject:[self csvStringForValue:aSaleLine.productTaxRate formatter:percentFormatter]];
					[csvArray addObject:[self csvStringForValue:aSaleLine.lineTotalTTC formatter:decimalFormatter]];
					[csvArray addObject:paymentMethodStr];
					
					[csvString appendFormat:@"%@\n", [csvArray componentsJoinedByString:@";"]];
				}
			}
			else {
				csvArray = [NSMutableArray array];
				
				[csvArray addObject:saleNumberStr];
				[csvArray addObject:dateStr];
				[csvArray addObject:customerStr];
				[csvArray addObject:discountStr];
				[csvArray addObject:totalStr];
				[csvArray addObject:paymentMethodStr];
				
				[csvString appendFormat:@"%@\n", [csvArray componentsJoinedByString:@";"]];
			}
		}
		
		NSError * error = nil;
		
		if (![csvString writeToFile:[sheet filename] atomically:YES encoding:NSUnicodeStringEncoding error:&error]) {
			[self presentError:error];
		}
	}
}

/*-(NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
{
	NSLog (@"    ***** request = %@", request);
	
	if ( [SpecialProtocol canInitWithRequest:request] )
	{
		NSDictionary * specialVars = [NSDictionary dictionaryWithObject:managedObjectContext forKey:@"MOC"];
		NSMutableURLRequest * specialURLRequest = [[request mutableCopy] autorelease];
		
		[specialURLRequest setSpecialVars:specialVars];
		
		return specialURLRequest;
	}
	else
	{
		return request;
	}
}*/

- (IBAction)closePaySheet:(id)sender {
	[NSApp endSheet:paySheet returnCode:[sender tag]];
}

- (void)paySheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo; {	
	[paySheet orderOut:self];
	
	// ...
		
	if (returnCode == NSOKButton) {
		self.currentSale.paymentMethod = currentPaymentMethod;
		
		// On cree les mouvements de stock
		
		NSEnumerator * saleLinesEnumerator = [[self.currentSale mutableSetValueForKey:@"saleLines"] objectEnumerator];
		SaleLine * aSaleLine = nil;
		
		Product * aProduct = nil;
		StockMovement * aStockMovement = nil;
		
		int quantity = 0;
		int currentStock = 0;
		int newStock = 0;
		
		while (aSaleLine = [saleLinesEnumerator nextObject]) {
			aProduct = [aSaleLine product];
			aStockMovement = [NSEntityDescription insertNewObjectForEntityForName:@"StockMovement" inManagedObjectContext:[aSaleLine managedObjectContext]];
			
			quantity = [[aSaleLine quantity] intValue] * (-1);
			
			[aStockMovement setProduct:aProduct];
			[aStockMovement setQuantity:[NSNumber numberWithInt:quantity]];
			[aStockMovement setDate:[NSDate date]];
			[aStockMovement setReason:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"Sale #", @""), self.currentSale.saleNumber]];
			[aStockMovement setSaleLine:aSaleLine];
			
			// ...
			
			currentStock = [[aProduct currentStock] intValue];
			
			newStock = currentStock + quantity; // ex = 5 + (-3) = 2
			
			[aProduct setCurrentStock:[NSNumber numberWithInt:newStock]];
		}
		
		// ...
		
		NSError *error = nil;
		
		if (![managedObjectContext save:&error]) {
			NSLog(@"******ERREUR*********");
			NSLog(@"%@", error);
			
			[self presentError:error];
		}
	}
}

- (void)addProductsWithURIs:(NSArray *)productsURIs {
	for (NSURL * anURI in productsURIs)
	{	
		[self addProduct:(Product *)[self objectWithURI:anURI]];
	}
}

- (void)addProduct:(Product *)aProduct {
	//NSLog(@"addProduct - DEBUT : %@", aProduct);
	
	SaleLine * aSaleLine = nil;
	
	// NSDecimalNumber * quantity = nil;
	
	// On verifie si une des lignes concerne deja le produit en cours et si c'est
	// le cas, on se contente d'incrementer la quantite de produit de 1
		
	for (aSaleLine in self.currentSale.saleLines ) {
		if ([aSaleLine product] == aProduct) {
			break;
		}
	}
	
	//NSLog(@"addProduct - aSaleLine : %@", aSaleLine);	
	
	if (nil != aSaleLine) {
		aSaleLine.quantity = [aSaleLine.quantity decimalNumberByAdding:[NSDecimalNumber one]];
		
		[aSaleLine computeLineTotals];
	}
	else {
		aSaleLine = [NSEntityDescription insertNewObjectForEntityForName:@"SaleLine" inManagedObjectContext:managedObjectContext];
				
		aSaleLine.product = aProduct;
		aSaleLine.productBasePriceHT = aProduct.unitPriceHT;
		aSaleLine.productBasePriceTTC = aProduct.unitPriceTTC;
		aSaleLine.productDiscountPriceHT = aSaleLine.productBasePriceHT;
		aSaleLine.productDiscountPriceTTC = aSaleLine.productBasePriceTTC;
		aSaleLine.productTaxRate = aProduct.taxRate.rate;
		aSaleLine.quantity = [NSDecimalNumber one];
		aSaleLine.creationDate = [NSDate date];
		
		[aSaleLine computeLineTotals];
		
		[self.currentSale addSaleLine:aSaleLine];
		
		//NSLog(@"addProduct - aSaleLine : %@", aSaleLine);
	}
	
	[saleLinesController setSelectedObjects:[NSArray arrayWithObject:aSaleLine]];	
	
	//NSLog(@"addProduct - FIN");
}

- (void)setCustomerWithURI:(NSURL *)customerURI {
	[self setCustomer:(Customer *)[self objectWithURI:customerURI]];
}

- (void)setCustomer:(Customer *)aCustomer {	
	self.currentSale.customer = aCustomer;
}

- (id)objectWithURI:(NSURL *)objectURI {
	id anObject = nil;
	NSManagedObjectID * anObjectID = nil;
	
	anObjectID = [[managedObjectContext persistentStoreCoordinator] managedObjectIDForURIRepresentation:objectURI];
	anObject = [managedObjectContext objectWithID:anObjectID];
		
	return anObject;
}

- (IBAction)removeCustomer:(id)sender {	
	self.currentSale.customer = nil;
}

#pragma mark -
#pragma mark BROWSERS

- (IBAction)openPaymentMethodsBrowser:(id)sender {
	PaymentMethodsModule * paymentMethodsModule = [PaymentMethodsModule moduleWithContext:managedObjectContext];
	
	// ...
	
	NSArray * selectedPaymentMethods = nil;
	
	if ( nil != currentPaymentMethod )
	{
		selectedPaymentMethods = [NSArray arrayWithObject:currentPaymentMethod];
	}
	
	[paymentMethodsModule showBrowserSheetModalForWindow:[NSApp mainWindow] selectedObjects:&selectedPaymentMethods];
	
	if ( [selectedPaymentMethods count] > 0 )
	{
		[self setCurrentPaymentMethod:[selectedPaymentMethods objectAtIndex:0]];
	}
}

#pragma mark -
#pragma mark NOTIFICATIONS

- (void)customersTableViewDoubleAction:(NSNotification *)notification {
	NSArray * selectedCustomers = [[notification userInfo] objectForKey:@"objects"];
	Customer * selectedCustomer = nil;
		
	if ((nil == self.currentSale.paymentMethod) && ([selectedCustomers count] > 0)) {
		selectedCustomer = [selectedCustomers objectAtIndex:0];
		
		[self setCustomer:selectedCustomer];
	}
}

- (void)productsTableViewDoubleAction:(NSNotification *)notification {
	NSArray * selectedProducts = [[notification userInfo] objectForKey:@"objects"];
	Product * aProduct = nil;
		
	if (nil == self.currentSale.paymentMethod)
	{
		for (aProduct in selectedProducts)
		{
			[self addProduct:aProduct];
		}
	}
}

#pragma mark -
#pragma mark MISC

- (void)didSelect {	
	[super didSelect];

	[singleObjectRightTabView reloadData];
}

- (void)switchToSingleObjectMode {
	[super switchToSingleObjectMode];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(barcodeScannerDidEndScanning:) name:FKBarcodeScannerDidEndScanningNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsTableViewDoubleAction:) name:FKModuleMiniStyleMultipleObjectsLeftTableViewDoubleActionNotification object:productsModule];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(customersTableViewDoubleAction:) name:FKModuleMiniStyleMultipleObjectsLeftTableViewDoubleActionNotification object:customersModule];
	
	[saleLinesController setSelectionIndexes:[NSIndexSet indexSet]];
}

- (void)switchToMultipleObjectsMode {
	[super switchToMultipleObjectsMode];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKBarcodeScannerDidEndScanningNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKModuleMiniStyleMultipleObjectsLeftTableViewDoubleActionNotification object:productsModule];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKModuleMiniStyleMultipleObjectsLeftTableViewDoubleActionNotification object:customersModule];
}

- (void)didUnselect {
	[super didUnselect];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKBarcodeScannerDidEndScanningNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKModuleMiniStyleMultipleObjectsLeftTableViewDoubleActionNotification object:productsModule];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:FKModuleMiniStyleMultipleObjectsLeftTableViewDoubleActionNotification object:customersModule];	
}

- (void)barcodeScannerDidEndScanning:(NSNotification *)notification {	
	FKBarcodeScanner * barcodeScanner = [notification object];
	NSString * barcodeString = [barcodeScanner lastScannedString];
	
	//NSLog(@"barcodeScannerDidEndScanning - barcodeString = %@", barcodeString);	
	
	// On recherche les produits dont le code barre est barcodeString
		
	NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription * fetchEntity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:managedObjectContext];
	NSPredicate * fetchPredicate = [NSPredicate predicateWithFormat:@"barcode LIKE %@", barcodeString];
	
	[fetchRequest setEntity:fetchEntity];
	[fetchRequest setPredicate:fetchPredicate];
		
	NSArray * results = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
	if ([results count] > 0) {
		//NSLog(@"barcodeScannerDidEndScanning - [results count] = %d", [results count]);
		//NSLog(@"barcodeScannerDidEndScanning - product = %@", [results objectAtIndex:0]);
		
		[self addProduct:[results objectAtIndex:0]];
	}
	else {
		NSBeep();
	}
}

#pragma mark -
#pragma mark FKModuleToolbar DELEGATE

- (int)moduleToolbarNumberOfAreas:(FKModuleToolbar *)aToolbar {
	int moduleToolbarNumberOfAreas = [super moduleToolbarNumberOfAreas:aToolbar];
	
	if (aToolbar == multipleObjectsFilterBar) {
		moduleToolbarNumberOfAreas = 2;
	}
	else if (aToolbar == multipleObjectsToolbar) {
		moduleToolbarNumberOfAreas = 1;
	}
	else if (aToolbar == singleObjectToolbar) {
		moduleToolbarNumberOfAreas = 1;
	}
	
	return moduleToolbarNumberOfAreas;
}

- (NSArray *)moduleToolbarItemIdentifiers:(FKModuleToolbar *)aToolbar forAreaAtIndex:(int)areaIndex {	
	NSArray * moduleToolbarItemIdentifiers = [super moduleToolbarItemIdentifiers:aToolbar forAreaAtIndex:areaIndex];
	
	if (aToolbar == multipleObjectsFilterBar) {
		if (areaIndex == 0) {
			NSMutableArray *tmpArray = [NSMutableArray array];
			
			[tmpArray addObject:@"AllYears"];
			
			NSDate *today = [NSDate date];
			NSString *yearStr = nil;
			NSInteger i = 0;
			
			NSCalendar *calendar= [NSCalendar currentCalendar];
			NSCalendarUnit unitFlags = NSYearCalendarUnit;
			NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:today];
			
			NSInteger year = [dateComponents year];
						
			for (i = 0; i < 3; i++) {
				yearStr = [NSString stringWithFormat:@"%d", (year - i)];
				
				[tmpArray addObject:yearStr];
			}
			
			moduleToolbarItemIdentifiers = [NSArray arrayWithArray:tmpArray];
			
			//moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"AllYears", @"PayedSales", @"PendingSales", nil];
		}
		else if (areaIndex == 1) {
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"AllSales", @"PayedSales", @"PendingSales", nil];
		}
	}
	else if (aToolbar == multipleObjectsToolbar) {
		if (areaIndex == 0) {
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"AddSale", @"Edit", FKModuleToolbarSeparatorItemIdentifier, @"Delete", nil];
		}
	}
	else if (aToolbar == singleObjectToolbar) {
		if (areaIndex == 0) {
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"Exit", FKModuleToolbarSeparatorItemIdentifier, @"Delete", @"Pay", FKModuleToolbarSeparatorItemIdentifier, @"PrintReceipt", @"PrintInvoice", nil];
		}
	}
	
	return moduleToolbarItemIdentifiers;
}

- (BOOL)validateModuleToolbarItem:(FKModuleToolbarItem *)theItem {	
	BOOL isValid = YES;
	
	//NSLog(@"validateModuleToolbarItem : %@", self.currentSale);
	
	NSString * itemIdentifier = [theItem itemIdentifier]; 
	FKModuleToolbar * toolbar = [theItem toolbar];
	
	if (toolbar == multipleObjectsToolbar) {
		if ([itemIdentifier isEqualToString:@"Delete"]) {
			isValid = (nil != self.currentSale);
		}
		else if ([itemIdentifier isEqualToString:@"Edit"]) {
			if ((nil == self.currentSale) || (nil == self.currentSale.paymentMethod)) {
				[theItem setImage:[NSImage imageNamed:@"TB_Edit"]];
				[theItem setLabel:NSLocalizedString(@"Edit", @"")];
			}
			else {
				[theItem setImage:[NSImage imageNamed:@"TB_Show"]];
				[theItem setLabel:NSLocalizedString(@"Show", @"")];
			}
			
			isValid = (nil != self.currentSale);
		}
	}
	else if (toolbar == singleObjectToolbar)
	{				
		if ([itemIdentifier isEqualToString:@"Pay"])  {	
			isValid = (nil == self.currentSale.paymentMethod);
		}
		else if ([itemIdentifier isEqualToString:@"PrintReceipt"]) {
			isValid = (nil != self.currentSale.paymentMethod);
		}
	}
	
	return isValid;
}

#pragma mark -
#pragma mark FKModuleFilterBar DELEGATE

- (NSString *)filterBar:(FKModuleFilterBar *)aToolbar predicateFormatForItemIdentifier:(NSString *)anItemIdentifier inAreaAtIndex:(NSInteger)areaIndex {
	if (areaIndex == 0) {
		if ([anItemIdentifier isEqualToString:@"AllYears"]) {return @"TRUEPREDICATE";}
		else {return @"date >= %@ AND date < %@";}
	}
	else if (areaIndex == 1) {
		if ( [anItemIdentifier isEqualToString:@"AllSales"] ) {return @"TRUEPREDICATE";}
		if ( [anItemIdentifier isEqualToString:@"PayedSales"] ) {return @"paymentMethod != nil";}
		if ( [anItemIdentifier isEqualToString:@"PendingSales"] ) {return @"paymentMethod == nil";}
	}
	
	return nil;
}

- (NSArray *)filterBar:(FKModuleFilterBar *)aToolbar predicateArgumentsForItemIdentifier:(NSString *)anItemIdentifier inAreaAtIndex:(NSInteger)areaIndex {
	if (areaIndex == 0) {
		if (![anItemIdentifier isEqualToString:@"AllYears"]) {
			NSInteger year = [anItemIdentifier intValue];
			
			NSDate *startDate = [NSCalendarDate dateWithYear:year month:1 day:1 hour:0 minute:0 second:0 timeZone:[NSTimeZone defaultTimeZone]];
			NSDate *endDate = [NSCalendarDate dateWithYear:(year + 1) month:1 day:1 hour:0 minute:0 second:0 timeZone:[NSTimeZone defaultTimeZone]];
			
			// NSLog(@"startDate = %@ -> endDate = %@", startDate, endDate);
			
			return [NSArray arrayWithObjects:startDate, endDate, nil];
		}
	}
	
	return nil;
}

#pragma mark -
#pragma mark FKStackView DELEGATE

- (unsigned)stackViewNumberOfStackedViews:(FKStackView *)aStackView {
	return 2;
}

- (NSView *)stackView:(FKStackView *)aStackView stackedViewAtIndex:(int)viewIndex {
	switch (viewIndex)
	{
		case 0 : {return generalInformationsView;}
		case 1 : {return productsView;}
	}
	
	return nil;
}

- (void)stackView:(FKStackView *)stackView finalizeStackedView:(FKStackableView **)stackedView atIndex:(unsigned)viewIndex {	
	FKStackableView * theView = *stackedView;
	
	switch (viewIndex)
	{
		case 0 :
		{
			[theView setTitle:NSLocalizedString(@"GeneralInformations", @"")];
			[theView setImage:[NSImage imageNamed:@"NSInfo"]];
			//[theView setFirstResponder:editViewGeneralViewFirstResponder];
			//[theView setLastResponder:editViewGeneralViewLastResponder];
			
			break;
		}
		case 1 :
		{
			[theView setTitle:NSLocalizedString(@"Products", @"")];
			//[theView setFirstResponder:editViewProvidersViewFirstResponder];
			//[theView setLastResponder:editViewProvidersViewLastResponder];
			
			break;
		}
	}
}

#pragma mark -
#pragma mark FKTabView DELEGATE

- (NSUInteger)fkTabViewNumberOfItems:(FKTabView *)aTabView {
	NSUInteger result = 0;
	
	if (aTabView == singleObjectLeftTabView) {
		result = 1;
	}
	else if (aTabView == singleObjectRightTabView) {
		result = 2;
	}
	
	return result;
}

- (NSString *)fkTabView:(FKTabView *)aTabView identifierForItemAtIndex:(NSUInteger)itemIndex {
	NSString * result = nil;
	
	if (aTabView == singleObjectLeftTabView) {
		switch (itemIndex) {
			case 0: {
				result = @"GeneralInformations";
				
				break;
			}
			default:
				break;
		}
	}
	else if (aTabView == singleObjectRightTabView) {
		switch (itemIndex) {
			case 0: {
				result = @"Products";
				
				break;
			}
			case 1: {
				result = @"Customers";
				
				break;
			}
			default:
				break;
		}
	}
	
	return result;
}

- (NSView *)fkTabView:(FKTabView *)aTabView viewForItemAtIndex:(NSUInteger)itemIndex {
	id result = nil;
	
	if (aTabView == singleObjectLeftTabView) {
		switch (itemIndex) {
			case 0: {
				result = editModeSaleView;
				
				break;
			}
			default:
				break;
		}
	}
	else if (aTabView == singleObjectRightTabView) {
		switch (itemIndex) {
			case 0: {				
				result = [productsModule miniModuleView];
				
				break;
			}
			case 1: {				
				result = [customersModule miniModuleView];
				
				break;
			}
			default:
				break;
		}
	}
	
	return result;
}

- (NSString *)fkTabView:(FKTabView *)aTabView labelForItemAtIndex:(NSUInteger)itemIndex {
	NSString * result = nil;
	
	if (aTabView == singleObjectLeftTabView) {
		switch (itemIndex) {
			case 0: {
				result = NSLocalizedString(@"GeneralInformations", "");
				
				break;
			}
			default:
				break;
		}
	}
	else if (aTabView == singleObjectRightTabView) {
		switch (itemIndex) {
			case 0: {
				result = NSLocalizedString(@"Products", "");
				
				break;
			}
			case 1: {
				result = NSLocalizedString(@"Customers", "");
				
				break;
			}
			default:
				break;
		}
	}
	
	return result;
}

@end
