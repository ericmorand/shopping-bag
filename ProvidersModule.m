//
//  ProvidersModule.m
//  ShoppingBag
//
//  Created by Eric on 06/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "ProvidersModule.h"


@implementation ProvidersModule

#pragma mark -
#pragma mark FKStackView GETTERS

- (NSString *)name {return @"Providers";}
- (NSString *)entityName {return @"Provider";}

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
#pragma mark FKStackView DELEGATE

- (unsigned)stackViewNumberOfStackedViews:(FKStackView *)aStackView
{
	return 1;
}

- (NSView *)stackView:(FKStackView *)aStackView stackedViewAtIndex:(int)viewIndex
{
	switch (viewIndex)
	{
		case 0 : {return generalView;}
		case 1 : {return addressesView;}
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
			[theView setTitle:NSLocalizedString(@"Addresses", @"")];			
			break;
		}
	}
}

#pragma mark -
#pragma mark ACTIONS

- (void)addProviderAction:(id)sender
{
	[self addObject];
}

- (void)deleteAction:(id)sender
{
	[self deleteSelectedObjects];
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
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"AllProviders", nil];
		}
	}
	else if ( aToolbar == multipleObjectsToolbar )
	{
		if ( areaIndex == 0 )
		{
			moduleToolbarItemIdentifiers = [NSArray arrayWithObjects:@"AddProvider", @"Delete", nil];
		}
	}
	
	return moduleToolbarItemIdentifiers;
}

- (BOOL)validateModuleToolbarItem:(FKModuleToolbarItem *)theItem
{	
	NSString * itemIdentifier = [theItem itemIdentifier];
	
	if ( [itemIdentifier isEqualToString:@"Delete"] )
	{		
		return ( [[objectsArrayController selectedObjects] count] > 0 );
	}
	
	return YES;
}

#pragma mark -
#pragma mark FKModuleFilterBar DELEGATE

- (NSString *)filterBar:(FKModuleFilterBar *)aToolbar predicateFormatForItemIdentifier:(NSString *)anItemIdentifier
{
	if ( [anItemIdentifier isEqualToString:@"AllProviders"] ) {return @"TRUEPREDICATE";}
	
	return nil;
}

@synthesize generalView;
@synthesize addressesView;
@end
