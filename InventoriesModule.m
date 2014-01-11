//
//  InventoriesModule.m
//  ShoppingBag
//
//  Created by Eric on 01/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "InventoriesModule.h"
#import "Product.h"
#import "ProviderProduct.h"
#import "StockSnapshotLine.h"

@implementation InventoriesModule

#pragma mark -
#pragma mark FKStackView GETTERS

- (NSString *)name {return @"Inventories";}
- (NSString *)entityName {return @"Inventory";}

- (NSArray *)searchFieldPredicateIdentifiers
{
	return [NSArray arrayWithObjects:@"Name", @"NameBeginsWith", nil];
}

- (NSString *)predicateFormatForSearchFieldPredicateIdentifier:(NSString *)predicateIdentifier
{
	if ( [predicateIdentifier isEqualToString:@"Name"] )
	{
		return @"name CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"NameBeginsWith"] )
	{
		return @"name BEGINSWITH[cd] $value";
	}
	
	return nil;
}

#pragma mark -
#pragma mark ACTIONS

- (void)addInventoryAction:(id)sender
{
	[self addObject];
}

- (void)deleteAction:(id)sender
{
	[self deleteSelectedObjects];
}

- (IBAction)printAction:(id)sender
{
	/*Inventory * selectedInventory = nil;	
	NSArray * selectedInventories = [objectsArrayController selectedObjects];
	
	if ( [selectedInventories count] > 0 )
	{
		selectedInventory = [selectedInventories objectAtIndex:0];
	
		if ( [[selectedInventory status] intValue] == InventoryStatusDone )
		{
			[self printEndStockSnapshot];			
		}
		else
		{
			[self printBeginStockSnapshot];
		}
	}*/
	
	[NSApp beginSheet:printDialogWindow
	   modalForWindow:[NSApp mainWindow]
		modalDelegate:self
	   didEndSelector:@selector(printDialogSheetDidEnd:returnCode:contextInfo:)
		  contextInfo:nil];
}

- (void)printDialogSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	[sheet orderOut:self];
	
	if ( returnCode == 1 )
	{
		// ...
	
		switch ( selectedTag )
		{
			case 0 :
			{
				[self printBeginStockSnapshot];
				break;
			}
			case 1 :
			{
				[self printEndStockSnapshot];
				break;
			}
			case 2 :
			{
				[self printBeginStockValue];
				break;
			}
			case 3 :
			{
				[self printEndStockValue];
				break;
			}
		}
	}
}

- (IBAction)runAction:(id)sender
{
	Inventory * selectedInventory = nil;
	NSArray * selectedInventories = [objectsArrayController selectedObjects];
	
	if ( [selectedInventories count] > 0 )
	{
		selectedInventory = [selectedInventories objectAtIndex:0];
		
		[selectedInventory run];
		
		[objectsArrayController rearrangeObjects];
		
		// ...
		
		NSAlert * printAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"Voulez-vous imprimer l'etat du stock ?", @"")
											   defaultButton:@"Oui"
											 alternateButton:@"Non"
												 otherButton:nil
								   informativeTextWithFormat:@""];
		
		[printAlert	beginSheetModalForWindow:[moduleView window]
							   modalDelegate:self
							  didEndSelector:@selector(printAlertDidEnd:returnCode:contextInfo:)
								 contextInfo:@"BeginStockSnapshot"];
	}
}

- (IBAction)stopAction:(id)sender
{
	Inventory * selectedInventory = nil;
	NSArray * selectedInventories = [objectsArrayController selectedObjects];
	
	if ( [selectedInventories count] > 0 )
	{
		selectedInventory = [selectedInventories objectAtIndex:0];
		
		[selectedInventory stop];
		
		[objectsArrayController rearrangeObjects];
		
		// ...
		
		NSAlert * printAlert = [NSAlert alertWithMessageText:NSLocalizedString(@"Voulez-vous imprimer l'etat du stock ?", @"")
											   defaultButton:@"Oui"
											 alternateButton:@"Non"
												 otherButton:nil
								   informativeTextWithFormat:@""];
		
		[printAlert	beginSheetModalForWindow:[moduleView window]
							   modalDelegate:self
							  didEndSelector:@selector(printAlertDidEnd:returnCode:contextInfo:)
								 contextInfo:@"EndStockSnapshot"];
	}
}

- (void)printAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	NSString * printTemplate = contextInfo;
	
	if ( returnCode == NSOKButton )
	{
		if ( [printTemplate isEqualToString:@"BeginStockSnapshot"] )
		{
			[self printBeginStockSnapshot];
		}
		else if ( [printTemplate isEqualToString:@"EndStockSnapshot"] )
		{
			[self printEndStockSnapshot];
		}
	}
}

- (void)printBeginStockSnapshot
{
	FKPrintManager * printManager = [FKPrintManager defaultManager];
	
	Inventory * selectedInventory = [[objectsArrayController selectedObjects] objectAtIndex:0];	
	
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	
	NSMutableDictionary * productDictionary = nil;
	NSMutableArray * productDictionariesArray = [NSMutableArray array];
		
	NSMutableSet * linesSet = nil;
	NSEnumerator * linesEnumerator = nil;
	StockSnapshotLine * aLine = nil;
	Product * aProduct = nil;
	Provider * aProvider = nil;
	
	// ...
	
	linesSet = [[selectedInventory beginStockSnapshot] mutableSetValueForKey:@"stockSnapshotLines"];
	
	for ( aLine in linesSet )
	{
		aProduct = [aLine product]; 
		
		productDictionary = [NSMutableDictionary dictionary];
		
		[productDictionary setObject:[aProduct name] forKey:@"productName"];
		[productDictionary setObject:[aProduct unitPriceTTC] forKey:@"productUnitPriceTTC"];
		
		//NSLog([aProduct name]);
		
		aProvider = [aProduct firstProvider];
		
		if (aProvider != nil)
		{
			[productDictionary setObject:[aProvider name] forKey:@"productFirstProvider"];
		}
		else
		{
			[productDictionary setObject:[NSString string] forKey:@"productFirstProvider"];
		}
		
		//NSLog([aProvider name]);
		
		[productDictionary setObject:[aProduct currentStock] forKey:@"productCurrentStock"];
		
		// ...
				
		[productDictionariesArray addObject:productDictionary];
	}
	
	[dictionary setObject:[selectedInventory name] forKey:@"inventoryName"];
	[dictionary setObject:[selectedInventory beginDate] forKey:@"date"];
	[dictionary setObject:productDictionariesArray forKey:@"products"];
	
	// ...
		
	[printManager printTemplate:@"InventoryBeginStockSnapshot" withObject:dictionary cssFileName:@"ShoppingBag" customPaperName:nil];
}

- (void)printEndStockSnapshot
{
	FKPrintManager * printManager = [FKPrintManager defaultManager];

	Inventory * selectedInventory = [[objectsArrayController selectedObjects] objectAtIndex:0];	
	
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	
	NSMutableDictionary * productDictionary = nil;
	NSMutableArray * productDictionariesArray = [NSMutableArray array];
	
	NSDecimalNumber * productCurrentStock = nil;
	NSDecimalNumber * productGreatestProviderPrice = nil;
	NSDecimalNumber * productStockValue = nil;
	NSDecimalNumber * totalStockValue = nil;
	
	NSMutableSet * linesSet = nil;
	NSEnumerator * linesEnumerator = nil;
	StockSnapshotLine * aLine = nil;
	Product * aProduct = nil;
	
	// ...
	
	linesSet = [[selectedInventory endStockSnapshot] mutableSetValueForKey:@"stockSnapshotLines"];
	
	for ( aLine in linesSet )
	{
		//NSLog (@"AQUI");
		
		aProduct = [aLine product]; 

		//NSLog (@" / AQUI");
		
		productDictionary = [NSMutableDictionary dictionary];
		
		productCurrentStock = [NSDecimalNumber decimalNumberWithDecimal:[[aLine quantity] decimalValue]];
		productGreatestProviderPrice = [aProduct greatestProviderPrice];
		
		if ( [productCurrentStock isGreaterThan:[NSDecimalNumber zero]] )
		{
			productStockValue = [productGreatestProviderPrice decimalNumberByMultiplyingBy:productCurrentStock];
		}
		else
		{
			productStockValue = [NSDecimalNumber zero];
		}
		
		[productDictionary setObject:[aProduct name] forKey:@"productName"];		
		[productDictionary setObject:productCurrentStock forKey:@"productCurrentStock"];
		[productDictionary setObject:productGreatestProviderPrice forKey:@"productGreatestProviderPrice"];	
		[productDictionary setObject:productStockValue forKey:@"productStockValue"];
		
		// ...
		
		[productDictionariesArray addObject:productDictionary];
		
		// ...
		
		totalStockValue = [totalStockValue decimalNumberByAdding:productStockValue];
	}
	
	[dictionary setObject:[selectedInventory name] forKey:@"inventoryName"];
	[dictionary setObject:[selectedInventory endDate] forKey:@"date"];
	[dictionary setObject:productDictionariesArray forKey:@"products"];
	[dictionary setObject:totalStockValue forKey:@"totalStockValue"];
	
	// ...
	
	[printManager printTemplate:@"InventoryEndStockSnapshot" withObject:dictionary cssFileName:@"ShoppingBag" customPaperName:nil];
}

- (void)printBeginStockValue
{
	Inventory * selectedInventory = [[objectsArrayController selectedObjects] objectAtIndex:0];	

	[self printStockValueForStockSnapshot:[selectedInventory beginStockSnapshot]];
}

- (void)printEndStockValue
{
	Inventory * selectedInventory = [[objectsArrayController selectedObjects] objectAtIndex:0];	
	
	[self printStockValueForStockSnapshot:[selectedInventory endStockSnapshot]];
}

- (void)printStockValueForStockSnapshot:(StockSnapshot *)stockSnapshot
{
	FKPrintManager * printManager = [FKPrintManager defaultManager];
		
	NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
	
	NSMutableDictionary * providerDictionary = nil;
	NSMutableArray * providerDictionariesArray = [NSMutableArray array];
	
	NSDecimalNumber * providerStockValue = nil;
	NSDecimalNumber * productStockValue = nil;
	NSDecimalNumber * totalStockValue = [NSDecimalNumber zero];
	NSDecimalNumber * lineQuantity = nil;
	
	NSManagedObjectContext * context = [self managedObjectContext];
	NSFetchRequest * fetchRequest = nil;
	NSEntityDescription * entity = nil;
	
	NSMutableArray * providersArray = nil;
	Provider * aProvider = nil;
	
	ProviderProduct * mostExpensiveProviderProduct;
	Product * aProduct = nil;	
	
	// ...
	
	fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	entity = [NSEntityDescription entityForName:@"Provider" inManagedObjectContext:context];
	
	[fetchRequest setEntity:entity];
	
	providersArray = [[[context executeFetchRequest:fetchRequest error:nil] mutableCopy] autorelease];
	
	// ...
	
	NSMutableSet * linesSet = nil;
	StockSnapshotLine * aLine = nil;
	
	// ...
	
	linesSet = [stockSnapshot mutableSetValueForKey:@"stockSnapshotLines"];
	
	// ...
	
	
	for ( aProvider in providersArray )
	{		
		providerStockValue = [NSDecimalNumber zero];
		providerDictionary = [NSMutableDictionary dictionary];
		
		// ...
		
		
		for ( aLine in linesSet )
		{								
			aProduct = [aLine product];

			lineQuantity = [NSDecimalNumber decimalNumberWithDecimal:[[aLine quantity] decimalValue]];
				
			mostExpensiveProviderProduct = [aProduct mostExpensiveProviderProduct];
				
			if ( aProvider == [mostExpensiveProviderProduct provider] )
			{
				productStockValue = [[mostExpensiveProviderProduct providerPriceHT] decimalNumberByMultiplyingBy:lineQuantity];
				providerStockValue = [providerStockValue decimalNumberByAdding:productStockValue];
			}
		}
		
		[providerDictionary setObject:[aProvider name] forKey:@"providerName"];
		[providerDictionary setObject:providerStockValue forKey:@"providerStockValue"];
		
		[providerDictionariesArray addObject:providerDictionary];
		
		// ...
		
		totalStockValue = [totalStockValue decimalNumberByAdding:providerStockValue];
	}
	
	[dictionary setObject:[NSDate date] forKey:@"date"];
	[dictionary setObject:providerDictionariesArray forKey:@"providers"];
	[dictionary setObject:totalStockValue forKey:@"totalStockValue"];
	
	// ...
	
	[printManager printTemplate:@"StockValue" withObject:dictionary cssFileName:@"ShoppingBag" customPaperName:nil];
}

/*- (NSURLRequest *)webView:(WebView *)sender resource:(id)identifier willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse fromDataSource:(WebDataSource *)dataSource
{
	//NSLog (@"    ***** request = %@", request);
	
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

#pragma mark -
#pragma mark FKStackView DELEGATE

- (unsigned)stackViewNumberOfStackedViews:(FKStackView *)aStackView
{
	return 4;
}

- (NSView *)stackView:(FKStackView *)aStackView stackedViewAtIndex:(int)viewIndex
{
	switch (viewIndex)
	{
		case 0 : {return generalInformationsView;}
		case 1 : {return beginStockView;}
		case 2 : {return endStockView;}
		case 3 : {return stockVariationsView;}
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
			//[theView setFirstResponder:singleProduct_GeneralViewFirstResponder];
			
			break;
		}
		case 1 :
		{
			[theView setTitle:NSLocalizedString(@"BeginStock", @"")];
			//[theView setFirstResponder:singleProduct_GeneralViewFirstResponder];
			
			break;
		}
		case 2 :
		{
			[theView setTitle:NSLocalizedString(@"EndStock", @"")];
			//[theView setFirstResponder:singleProduct_GeneralViewFirstResponder];
			
			break;
		}
		case 3 :
		{
			[theView setTitle:NSLocalizedString(@"StockMovements", @"")];
			//[theView setFirstResponder:singleProduct_GeneralViewFirstResponder];
			
			break;
		}
	}
}

#pragma mark -
#pragma mark FKModuleToolbar DELEGATE

- (int)moduleToolbarNumberOfAreas:(FKModuleToolbar *)aToolbar
{
	int moduleToolbarNumberOfAreas = [super moduleToolbarNumberOfAreas:aToolbar];
	
	if ( aToolbar == multipleObjectsFilterBar )
	{
		moduleToolbarNumberOfAreas = 1;
	}
	else if ( aToolbar == multipleObjectsToolbar )
	{
		moduleToolbarNumberOfAreas = 1;
	}
	
	return moduleToolbarNumberOfAreas;
}

- (NSArray *)moduleToolbarItemIdentifiers:(FKModuleToolbar *)aToolbar forAreaAtIndex:(int)areaIndex
{	
	NSArray * moduleToolbarItemIdentifiers = [super moduleToolbarItemIdentifiers:aToolbar forAreaAtIndex:areaIndex];
	
	if ( aToolbar == multipleObjectsFilterBar )
	{
		if ( areaIndex == 0 )
		{
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:
				@"AllInventories",
				@"Running",
				@"Done",
				nil];
		}
	}
	else if ( aToolbar == multipleObjectsToolbar )
	{
		if ( areaIndex == 0 )
		{
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:
				@"AddInventory",
				@"Delete",
				FKModuleToolbarSeparatorItemIdentifier, 
				@"Run",
				@"Print",
				nil];
		}
	}
	
	return moduleToolbarItemIdentifiers;
}

- (BOOL)validateModuleToolbarItem:(FKModuleToolbarItem *)theItem
{	
	//NSLog (@"validateModuleToolbarItem");
	
	BOOL isValid = YES;
	
	NSString * itemIdentifier = [theItem itemIdentifier];
	
	NSArray * selectedInventories = [objectsArrayController selectedObjects];
	
	Inventory * selectedInventory = nil;
	
	int count = [selectedInventories count];
	
	if ( count > 0 )
	{
		selectedInventory = [selectedInventories objectAtIndex:0];
	}
	
	// ...
	
	if ( ( [itemIdentifier isEqualToString:@"Delete"] ) ||  ( [itemIdentifier isEqualToString:@"Print"] ) )
	{		
		isValid = ( count == 1 );
		
		if ( [itemIdentifier isEqualToString:@"Print"] )
		{
			isValid = isValid && ( [[selectedInventory status] intValue] != InventoryStatusIdle );
		}
		else if ( [itemIdentifier isEqualToString:@"Delete"] )
		{
			isValid = isValid && ( [[selectedInventory status] intValue] != InventoryStatusRunning );
		}
	}
	else if ( [itemIdentifier isEqualToString:@"Run"] )
	{		
		if ( ( count != 1 ) || ( ![selectedInventory canStop] ) )
		{
			[theItem setAction:@selector(runAction:)];	
			[theItem setImage:[NSImage imageNamed:@"TB_Run"]];
			[theItem setLabel:NSLocalizedString(@"Run", @"")];
		}
		else
		{			
			[theItem setAction:@selector(stopAction:)];
			[theItem setImage:[NSImage imageNamed:@"TB_Stop"]];
			[theItem setLabel:NSLocalizedString(@"Stop", @"")];
		}
		
		isValid = ( ( count == 1 ) && ( ( [selectedInventory canRun] ) || ( [selectedInventory canStop] ) ) );
	}
		
	return isValid;
}

#pragma mark -
#pragma mark FKModuleFilterBar DELEGATE

- (NSString *)filterBar:(FKModuleFilterBar *)aToolbar predicateFormatForItemIdentifier:(NSString *)anItemIdentifier
{
	if ( [anItemIdentifier isEqualToString:@"AllInventories"] ) {return @"TRUEPREDICATE";}
	else if ( [anItemIdentifier isEqualToString:@"Running"] ) {return [NSString stringWithFormat:@"status == %d", InventoryStatusRunning];}
	else if ( [anItemIdentifier isEqualToString:@"Done"] ) {return [NSString stringWithFormat:@"status == %d", InventoryStatusDone];}
	return nil;
}

@synthesize generalInformationsView;
@synthesize beginStockView;
@synthesize endStockView;
@synthesize stockVariationsView;
@synthesize selectedTag;
@end
