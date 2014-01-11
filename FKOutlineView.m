//
//  FKOutlineView.m
//  FK
//
//  Created by Eric Morand on Mon Apr 05 2004.
//  Copyright (c) 2004 Eric Morand. All rights reserved.
//

#import "FKOutlineView.h"
#import "NSImage_FKAdditions.h"

@interface NSObject (NSTableViewPrivateMethods)

- (id)_highlightColorForCell:(NSCell *)cell;

@end

@implementation FKOutlineView

#include "FKTableView_Implementation.h"

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [self commonInitWithCoder:decoder];
	
	return self;	
}
	
- (id)initWithFrame:(NSRect)frameRect
{
	self = [self commonInitWithFrame:frameRect];
	
	return self;
}

- (void)dealloc
{	
	[self commonDealloc];
	
	[super dealloc];
}

#pragma mark -
#pragma mark SELECT & SCROLL

- (id)selectedObject
{
	FKTreeNode * anItem = nil;
	int selectedRow = [self selectedRow];
	
	if ( selectedRow > -1 )
	{
		anItem = [self itemAtRow:selectedRow];
	}
	
	return [anItem nodeData];;
}

// Retourne un tableau contenant les donnees de chaque noeud
// selectionne et non pas les noeuds eux-memes

- (NSArray *)selectedObjects
{
	NSMutableArray * selectedObjects = [NSMutableArray array];
	
	NSIndexSet * selectedRowIndexes = [self selectedRowIndexes];
	int currentIndex = [selectedRowIndexes firstIndex];
	
	FKTreeNode * currentNode = nil;
	FKTreeNode * childNode = nil;
	
	NSArray * currentNodeChildren = nil;
	NSEnumerator * childEnumerator = nil;
	
	while ( currentIndex != NSNotFound )
	{
		currentNode = [self itemAtRow:currentIndex];
		
		currentNodeChildren = [currentNode children];
		
		if ( [currentNodeChildren count] )
		{
			
			for ( childNode in currentNodeChildren )
			{
				[selectedObjects addObject:[childNode nodeData]];
			}
		}
		
		[selectedObjects addObject:[currentNode nodeData]];
		
		currentIndex = [selectedRowIndexes indexGreaterThanIndex:currentIndex];
	}
	
	return [NSArray arrayWithArray:selectedObjects];
}

- (void)selectObject:(id)anObject
{
	FKTreeNode * anItem = [self itemForObject:anObject];
	
	FKTreeNode * parentItem = nil;
	NSMutableArray * parentsArray = nil;
	NSEnumerator * parentEnumerator = nil;
	
	int objectIndex = -1;
	
	parentsArray = [NSMutableArray array];
	
	// Recherche de tous les parents de l'objet a selectionner
	
	parentItem = [anItem nodeParent];

	while ( [parentItem nodeParent] )
	{
		[parentsArray insertObject:parentItem atIndex:0];
		
		parentItem = [parentItem nodeParent];
	}
	
	// ...
	
	
	for ( parentItem in parentsArray )
	{
		[self expandItem:parentItem];
	}
	
	// Selection de l'objet
	
	objectIndex = [self rowForItem:anItem];
	
	if ( objectIndex != NSNotFound )
	{
		[self selectRowIndexes:[NSIndexSet indexSetWithIndex:objectIndex] byExtendingSelection:NO];
	}
	else
	{
		[self deselectAll:self];		
	}
}

- (void)scrollObjectToVisible:(id)anObject
{
	unsigned objectIndex = [self rowForItem:anObject];
	
	if ( objectIndex != NSNotFound )
	{
		[self scrollRowToVisible:objectIndex];
	}
}

#pragma mark -
#pragma mark MISC

- (BOOL)isSeparatorRowAtIndex:(int)rowIndex
{
	if ( [self isValidDelegateForSelector:@selector(outlineView:isSeparatorRowByItem:)] )
	{	
		return [[self delegate] outlineView:self isSeparatorRowByItem:[self itemAtRow:rowIndex]];
	}
	
	return NO;
}

- (BOOL)isOptionalColumn:(NSTableColumn *)aTableColumn
{
	if ( [self isValidDelegateForSelector:@selector(outlineView:isOptionalColumn:)] )
	{
		return [[self delegate] outlineView:self isOptionalColumn:aTableColumn];
	}
	
	return YES;
}

- (id)objectAtRow:(int)rowIndex
{
	if ( [self isValidDelegateForSelector:@selector(outlineView:objectAtRow:)] )
	{
		return [[self delegate] outlineView:self objectAtRow:rowIndex];
	}
	
	return nil;	
}

- (unsigned)rowForObject:(id)anObject
{
	FKTreeNode * anItem = [self itemForObject:anObject];
	
	return [self rowForItem:anItem];		
}

- (FKTreeNode *)itemForObject:(id)anObject
{
	if ( [self isValidDelegateForSelector:@selector(outlineView:itemForObject:)] )
	{
		return [[self delegate] outlineView:self itemForObject:anObject];
	}
	
	return nil;
}

- (NSColor *)colorForRowAtIndex:(int)rowIndex
{
	if ( [self isValidDelegateForSelector:@selector(outlineView:colorForRowByItem:)] )
	{
		return [[self delegate] outlineView:self colorForRowByItem:[self itemAtRow:rowIndex]];
	}
	
	return nil;
}

@synthesize _savedTableColumns;
@synthesize rowSeparatorMargin;
@synthesize draggedRows;
@end
