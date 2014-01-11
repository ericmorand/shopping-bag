//
//  FKTableHeaderView.m
//  FK
//
//  Created by Eric Morand on Thu Apr 08 2004.
//  Copyright (c) 2004 Eric Morand. All rights reserved.
//

#import "FKTableHeaderView.h"


@implementation FKTableHeaderView

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if ( self )
	{
		defaultMenu = nil;
	}
	
	return self;
}

- (void)dealloc
{
	[self setDefaultMenu:nil];
	
	[super dealloc];
}

- (void)awakeFromNib
{
	[self createDefaultMenu];
}
	
#pragma mark -
#pragma mark GETTERS

- (id)tableView {return [super tableView];}
- (NSMenu *)menuForEvent:(NSEvent *)theEvent {return [self defaultMenu];}
- (NSMenu *)defaultMenu {return defaultMenu;}

#pragma mark -
#pragma mark SETTERS

- (void)setDefaultMenu:(NSMenu *)aMenu
{
	[defaultMenu release];
	defaultMenu = [aMenu retain];
}

- (void)createDefaultMenu
{
	NSMenu * aMenu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	NSMenuItem * anItem = nil;
	
	// Ajout des éléments de menu permettant de modifier
	// la liste des colonnes affichées par la table.
	
	NSEnumerator * columnEnumerator = [[[self tableView] savedTableColumnsSorted] objectEnumerator];
	NSTableColumn * aColumn = nil;
	
	while ( aColumn = [columnEnumerator nextObject] )
	{
		anItem = [[[NSMenuItem alloc] initWithTitle:[aColumn title] action:@selector(toggleColumn:) keyEquivalent:@""] autorelease];
		
		[anItem setTarget:self];
		[anItem setRepresentedObject:aColumn];
		
		[aMenu addItem:anItem];
	}
	
	[aMenu setDelegate:self];
	
	[self setDefaultMenu:aMenu];
}

#pragma mark -
#pragma mark MENU ACTIONS

- (void)toggleColumn:(NSMenuItem *)anItem
{	
	NSTableColumn * aColumn = [anItem representedObject];
	
	if ( [[[self tableView] tableColumns] containsObject:aColumn] )
	{
		[[self tableView] removeTableColumn:aColumn];
	}
	else
	{
		[[self tableView] addTableColumn:aColumn];  
	}
	
	[self setMenuItemState:anItem]; 
}

- (void)setMenuItemState:(NSMenuItem *)anItem
{
	if ( [[[self tableView] tableColumns] containsObject:[anItem representedObject]] )
	{
		[anItem setState:NSOnState];
	}
	else
	{
		[anItem setState:NSOffState];
	}
}

#pragma mark -
#pragma mark NSMenu DELEGATE

- (void)menuNeedsUpdate:(NSMenu *)menu
{
	NSEnumerator * itemEnumerator = [[menu itemArray] objectEnumerator];
	NSMenuItem * anItem = nil;
	
	while ( anItem = [itemEnumerator nextObject] )
	{
		[self setMenuItemState:anItem];
	}
}

#pragma mark -
#pragma mark NSMenuValidation PROTOCOL

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem
{
	NSTableColumn * aColumn = [menuItem representedObject];

    return [[self tableView] isOptionalColumn:aColumn];	
}

@end
