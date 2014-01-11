//
//  InventoriesModule.m
//  Shopping Bag
//
//  Created by Eric on 01/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "InventoriesModule.h"
#import "Product.h"
#import "StockSnapshotLine.h"

@implementation InventoriesModule

#pragma mark -
#pragma mark FKStackView GETTERS

- (NSString *)name {return @"Inventories";}
- (NSString *)entityName {return @"Inventory";}

- (NSArray *)multipleObjectsSearchFieldDisplayNames
{
	return [NSArray arrayWithObjects:
		@"Nom",
		@"Nom (commence par)",
		nil];
}

- (NSArray *)multipleObjectsSearchFieldPredicateFormats
{
	return [NSArray arrayWithObjects:
		@"name CONTAINS[cd] $value",
		@"name BEGINSWITH[cd] $value",
		nil];
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
		
		NSAlert * printAlert = [NSAlert alertWithMessageText:@"Test"
											   defaultButton:@"Oui"
											 alternateButton:@"Non"
												 otherButton:nil
								   informativeTextWithFormat:@"Test2"];
		
		[printAlert	beginSheetModalForWindow:[moduleView window]
							   modalDelegate:self
							  didEndSelector:@selector(printAlertDidEnd:returnCode:contextInfo:)
								 contextInfo:nil];
		
		// ...
		

	}
}

- (void)printBeginStockShapshot
{
	Inventory * selectedInventory = [[objectsArrayController selectedObjects] objectAtIndex:0];
	
	NSMutableSet * beginStockSnapshotLinesSet = [[selectedInventory beginStockSnapshot] mutableSetValueForKey:@"stockSnapshotLines"];
	NSArray * beginStockSnapshotLines = [beginStockSnapshotLinesSet allObjects];
	NSEnumerator * stockSnapshotLinesEnumerator = [beginStockSnapshotLines objectEnumerator];
	StockSnapshotLine * aLine = nil;
	
	// ...
	
	NSString * simpleListPath = [[NSBundle mainBundle] pathForResource:@"InventoryStockSnapshot" ofType:@"html" inDirectory:@"Templates"];
	
	NSString * htmlString = [NSString stringWithContentsOfFile:simpleListPath encoding:nil error:nil];
	
	NSRange beginRepeatRange = [htmlString rangeOfString:@"<!-- BeginRepeat -->"];
	NSRange endRepeatRange = [htmlString rangeOfString:@"<!-- EndRepeat -->"];
	
	NSString * headerString = [htmlString substringToIndex:beginRepeatRange.location];
	NSString * repeatString = [htmlString substringWithRange:NSUnionRange(beginRepeatRange, endRepeatRange)];
	NSString * footerString = [htmlString substringFromIndex:NSMaxRange(beginRepeatRange)];
	
	NSMutableString * testString = nil;
	Product * aProduct = nil;
	
	htmlString = headerString;
	
	int i = 0;
	
	while ( i < 50 ) //aLine = [stockSnapshotLinesEnumerator nextObject] )
	{
		aLine = [beginStockSnapshotLines objectAtIndex:i];
		
		NSLog (@"[aProduct name] = %@", [aProduct name]);
		
		aProduct = [aLine product];
		
		testString = [NSMutableString stringWithString:repeatString];
		
		[testString replaceOccurrencesOfString:@"[name]" withString:[aProduct name]
									   options:0
										 range:NSMakeRange(0, [testString length])];
		
		htmlString = [htmlString stringByAppendingString:testString];
		
		i++;
	}
	
	htmlString = [htmlString stringByAppendingString:footerString];
	
	NSLog (@"htmlString = %@", htmlString);
	
	// ...
	
	WebView * testWebView = [[[WebView alloc] initWithFrame:NSMakeRect(0,0,100,100) frameName:@"Truc" groupName:@"Truc"] autorelease];
	
	[[testWebView mainFrame] loadHTMLString:htmlString baseURL:nil];
	
	// ...
	
	NSPrintInfo* prInfo = [ NSPrintInfo sharedPrintInfo ];
	
	[prInfo setVerticallyCentered:NO];
	[prInfo setTopMargin:0.0];
	[prInfo setLeftMargin:0.0];
	[prInfo setRightMargin:0.0];
	[prInfo setBottomMargin:0.0];
	[prInfo setOrientation:NSLandscapeOrientation];
	[prInfo setHorizontalPagination:NSFitPagination ]; // scales to fit page width

	NSLog (@"[ [ [ testWebView mainFrame ] = %@", [ testWebView mainFrame ]);

	NSLog (@"[ [ testWebView mainFrame ] frameView ] = %@", [ [ testWebView mainFrame ] frameView ]);

	NSLog (@"[ [ [ testWebView mainFrame ] frameView ] documentView ] = %@", [ [ [ testWebView mainFrame ] frameView ] documentView ]);
	
	[ [ [ testWebView mainFrame ] frameView ] print: self ];
}

- (void)printAlertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	if ( returnCode == NSOKButton )
	{
		[self printBeginStockShapshot];
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
	}
}

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
			[theView setTitle:@"Informations generales"];
			[theView setImage:[NSImage imageNamed:@"info"]];
			//[theView setFirstResponder:singleProduct_GeneralViewFirstResponder];
			
			break;
		}
		case 1 :
		{
			[theView setTitle:@"Stock de depart"];
			//[theView setFirstResponder:singleProduct_GeneralViewFirstResponder];
			
			break;
		}
		case 2 :
		{
			[theView setTitle:@"Stock de fin"];
			//[theView setFirstResponder:singleProduct_GeneralViewFirstResponder];
			
			break;
		}
		case 3 :
		{
			[theView setTitle:@"Variations de stock"];
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

- (FKModuleToolbarItem *)moduleToolbar:(FKModuleToolbar *)aToolbar itemForItemIdentifier:(NSString *)anItemIdentifier forAreaAtIndex:(int)areaIndex
{
	FKModuleToolbarItem * anItem = [super moduleToolbar:aToolbar itemForItemIdentifier:anItemIdentifier forAreaAtIndex:areaIndex];
	
	if ( aToolbar == multipleObjectsFilterBar )
	{
		[anItem setAction:@selector(multipleObjectsFilterBarAction:)];
	}
	else if ( aToolbar == multipleObjectsToolbar )
	{
		NSString * firstCharacter = [[anItemIdentifier substringToIndex:1] lowercaseString];
		NSString * remString = [anItemIdentifier substringFromIndex:1];
		NSString * selectorString = [NSString stringWithFormat:@"%@%@Action:", firstCharacter, remString];
		
		[anItem setImage:[NSImage imageNamed:anItemIdentifier]];
		[anItem setAction:NSSelectorFromString(selectorString)];
	}
	
	return anItem;
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
		isValid = ( count > 0 );
	}
	else if ( [itemIdentifier isEqualToString:@"Run"] )
	{		
		if ( count != 1 )
		{
			[theItem setImage:[NSImage imageNamed:@"Run"]];
			[theItem setLabel:@"Run"];
			
			isValid = NO;
		}
		else if ( [selectedInventory canStop] )
		{			
			[theItem setAction:@selector(stopAction:)];
			[theItem setImage:[NSImage imageNamed:@"Stop"]];
			[theItem setLabel:@"Stop"];
			
			isValid = YES;
		}
		else
		{
			[theItem setAction:@selector(runAction:)];	
			[theItem setImage:[NSImage imageNamed:@"Run"]];
			[theItem setLabel:@"Run"];
			
			isValid = ( [selectedInventory canRun] );
		}
	}
	
	//NSLog (@" FIN validateModuleToolbarItem");
	
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

@end
