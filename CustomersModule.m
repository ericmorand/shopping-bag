//
//  CustomersModule.m
//  ShoppingBag
//
//  Created by Eric on 19/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "CustomersModule.h"


@implementation CustomersModule

@synthesize salesControllerSortDescriptors;

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

#pragma mark -
#pragma mark GETTERS

- (NSString *)name {
	return @"Customers";
}

- (NSString *)entityName {
	return @"Customer";
}

- (NSArray *)searchFieldPredicateIdentifiers {
	return [NSArray arrayWithObjects:
		@"Name",
		@"NameBeginsWith",
		@"City",
		nil];
}

- (NSString *)predicateFormatForSearchFieldPredicateIdentifier:(NSString *)predicateIdentifier {
	if ( [predicateIdentifier isEqualToString:@"Name"] )
	{
		return @"name CONTAINS[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"NameBeginsWith"] )
	{
		return @"name BEGINSWITH[cd] $value";
	}
	else if ( [predicateIdentifier isEqualToString:@"City"] )
	{
		return @"address.city CONTAINS[cd] $value";
	}
	
	return nil;
}

- (NSArray *)salesControllerSortDescriptors {
	NSSortDescriptor * sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"saleNumber" ascending:NO] autorelease];
	
	return [NSArray arrayWithObject:sortDescriptor];
}

#pragma mark -
#pragma mark ACTIONS

- (void)addCustomerAction:(id)sender
{
	[self addObject];
}

- (void)deleteAction:(id)sender
{
	[objectsArrayController remove:self];
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
		
		[csvArray addObject:NSLocalizedString(@"Nom", @"")];
		[csvArray addObject:NSLocalizedString(@"Adresse", @"")];
		
		[csvString appendFormat:@"%@\n", [csvArray componentsJoinedByString:@";"]];
		
		// ...
		
		for (Customer * aCustomer in [objectsArrayController arrangedObjects]) {				
			csvArray = [NSMutableArray array];
			
			[csvArray addObject:[self csvStringForValue:aCustomer.name]];
			[csvArray addObject:[self csvStringForValue:[[aCustomer address] shortDescription]]];
			
			[csvString appendFormat:@"%@\n", [csvArray componentsJoinedByString:@";"]];
		}
		
		if (![csvString writeToFile:[sheet filename] atomically:YES encoding:NSUnicodeStringEncoding error:&error]) {
			[self presentError:error];
		}
	}
}

#pragma mark -
#pragma mark LAYOUT

- (void)finalizeSetupModuleViewUsingFullStyle {
}

- (void)finalizeSetupModuleViewUsingMiniStyle
{
	[super finalizeSetupModuleViewUsingMiniStyle];
	
	// ...
	
	[multipleObjectsLeftTableView setAllowsMultipleSelection:NO];
	
	//NSTableColumn * iconTableColumn = [[multipleObjectsLeftTableView tableColumns] objectAtIndex:0];
	
	//[iconTableColumn setWidth:16.0];
	//[iconTableColumn setMinWidth:16.0];
	//[iconTableColumn setMaxWidth:16.0];
}

#pragma mark -
#pragma mark FKStackView DELEGATE

- (unsigned)stackViewNumberOfStackedViews:(FKStackView *)aStackView
{
	return 2;
}

- (NSView *)stackView:(FKStackView *)aStackView stackedViewAtIndex:(int)viewIndex
{
	switch (viewIndex)
	{
		case 0 : {return generalView;}
		case 1 : {return salesView;}
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
			[theView setTitle:NSLocalizedString(@"Sales", @"")];
			[theView setFirstResponder:salesViewFirstResponder];
			[theView setLastResponder:salesViewLastResponder];
			
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
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"AllCustomers", nil];
		}
	}
	else if ( aToolbar == multipleObjectsToolbar )
	{
		if ( areaIndex == 0 )
		{
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"AddCustomer", @"Delete", nil];
		}
	}
	
	return moduleToolbarItemIdentifiers;
}

- (BOOL)validateModuleToolbarItem:(NSToolbarItem *)theItem
{	
	NSString * itemIdentifier = [theItem itemIdentifier];
	
	if ( [itemIdentifier isEqualToString:@"Delete"] )
	{		
		return NO; // ( [[objectsArrayController selectedObjects] count] > 0 );
	}
	
	return YES;
}

#pragma mark -
#pragma mark FKModuleFilterBar DELEGATE

- (NSString *)filterBar:(FKModuleFilterBar *)aToolbar predicateFormatForItemIdentifier:(NSString *)anItemIdentifier
{
	if ( [anItemIdentifier isEqualToString:@"AllCustomers"] ) {return @"TRUEPREDICATE";}
	
	return nil;
}

#pragma mark -
#pragma mark NSTableView DATASOURCE

- (BOOL)tableView:(NSTableView *)aTableView writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard
{
	NSMutableArray * draggedCustomersURIs = [NSMutableArray array];
	
	NSArray * draggedCustomersArray = [(NSArray *)[objectsArrayController arrangedObjects] objectsAtIndexes:rowIndexes];
	Customer * aDraggedCustomer = nil;
	
	NSURL * aDraggedCustomerURI = nil;
	
	for ( aDraggedCustomer in draggedCustomersArray )
	{
		aDraggedCustomerURI = [[aDraggedCustomer objectID] URIRepresentation];
		
		[draggedCustomersURIs addObject:aDraggedCustomerURI];
	}
	
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:draggedCustomersURIs];
	
	[pboard declareTypes:[NSArray arrayWithObject:CustomerPBoardDataType] owner:self];
    [pboard setData:data forType:CustomerPBoardDataType];
	
	return YES;
}

@synthesize generalView;
@synthesize generalViewFirstResponder;
@synthesize generalViewLastResponder;
@synthesize salesView;
@synthesize salesViewFirstResponder;
@synthesize salesViewLastResponder;

@end
