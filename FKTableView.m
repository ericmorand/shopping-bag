//
//  FKTableView.m
//  FK
//
//  Created by Eric Morand on Mon Apr 05 2004.
//  Copyright (c) 2004 FKy Creations. All rights reserved.
//

#import "FKTableView.h"
#import "FKTableHeaderView.h"

@interface NSObject (NSTableViewPrivateMethods)

- (id)_highlightColorForCell:(NSCell *)cell;

@end

@implementation FKTableView

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
	id anObject = nil;
	int selectedRow = [self selectedRow];
	
	if ( selectedRow > -1 )
	{
		anObject = [self objectAtRow:selectedRow];
	}
	
	return anObject;
}

- (NSArray *)selectedObjects
{
	NSMutableArray * selectedObjects = [NSMutableArray array];
	
	NSIndexSet * selectedRowIndexes = [self selectedRowIndexes];
	int currentIndex = [selectedRowIndexes firstIndex];
	
	while ( currentIndex != NSNotFound )
	{		
		[selectedObjects addObject:[self objectAtRow:currentIndex]];
		
		currentIndex = [selectedRowIndexes indexGreaterThanIndex:currentIndex];
	}
	
	return [NSArray arrayWithArray:selectedObjects];	
}

- (void)selectObject:(id)anObject
{
	unsigned objectIndex = [self rowForObject:anObject];
	
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
	unsigned objectIndex = [self rowForObject:anObject];
	
	if ( objectIndex != NSNotFound )
	{
		[self scrollRowToVisible:objectIndex];
	}
}

- (BOOL)isRowVisible:(NSUInteger)rowIndex {
	NSRect visRect = [self visibleRect];
	NSRange rowsInRect = [self rowsInRect:visRect];
	
	return (rowIndex >= rowsInRect.location && rowIndex <= NSMaxRange(rowsInRect));
}

#pragma mark -
#pragma mark MISC

- (BOOL)isSeparatorRowAtIndex:(int)rowIndex
{
	if ( [self isValidDelegateForSelector:@selector(tableView:isSeparatorRowAtIndex:)] )
	{	
		return [[self delegate] tableView:self isSeparatorRowAtIndex:rowIndex];
	}
	
	return NO;
}

- (BOOL)isOptionalColumn:(NSTableColumn *)aTableColumn
{
	if ( [self isValidDelegateForSelector:@selector(tableView:isOptionalColumn:)] )
	{
		return [[self delegate] tableView:self isOptionalColumn:aTableColumn];
	}
	
	return YES;
}

- (id)objectAtRow:(int)rowIndex
{
	if ( [self isValidDelegateForSelector:@selector(tableView:objectAtRow:)] )
	{
		return [[self delegate] tableView:self objectAtRow:rowIndex];
	}
	
	return nil;	
}

- (unsigned)rowForObject:(id)anObject
{
	if ( [self isValidDelegateForSelector:@selector(tableView:rowForObject:)] )
	{
		return [[self delegate] tableView:self rowForObject:anObject];
	}
	
	return NSNotFound;
}

- (NSColor *)colorForRowAtIndex:(int)rowIndex
{
	if ( [self isValidDelegateForSelector:@selector(tableView:colorForRowAtIndex:)] )
	{
		return [[self delegate] tableView:self colorForRowAtIndex:rowIndex];
	}
	
	return nil;
}

@synthesize _savedTableColumns;
@synthesize _rowSeparatorColor;
@synthesize _rowSeparatorWidth;
@end
