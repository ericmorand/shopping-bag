//
//  FKOutlineView.h
//  FK
//
//  Created by Eric Morand on Mon Apr 05 2004.
//  Copyright (c) 2004 Eric Morand. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "FKTableHeaderView.h"


@class FKTreeNode;

@interface FKOutlineView : NSOutlineView
{
	#include "FKTableView_Vars.h"
}

#include "FKTableView_Methods.h"

- (FKTreeNode *)itemForObject:(id)anObject;

@property (retain) NSArray *			_savedTableColumns;
@property (retain,getter=rowSeparatorColor,setter=setRowSeparatorColor:) NSColor	*			_rowSeparatorColor;
@property (getter=rowSeparatorWidth,setter=setRowSeparatorWidth:) float				_rowSeparatorWidth;
@property (setter=setRowSeparatorMargin:) float				rowSeparatorMargin;
@property (retain,getter=draggedRows) NSIndexSet *		draggedRows;
@property (getter=usesGradientSelection,setter=setUsesGradientSelection:) BOOL				usesGradientSelection;
@property (getter=selectionGradientIsContiguous,setter=setSelectionGradientIsContiguous:) BOOL				selectionGradientIsContiguous;
@property (getter=usesDisabledGradientSelectionOnly,setter=setUsesDisabledGradientSelectionOnly:) BOOL				usesDisabledGradientSelectionOnly;
@property (getter=hasBreakBetweenGradientSelectedRows,setter=setHasBreakBetweenGradientSelectedRows:) BOOL				hasBreakBetweenGradientSelectedRows;
@end

@interface NSObject (FKOutlineViewDelegate)

- (BOOL)outlineView:(FKOutlineView *)outlineView isSeparatorRowByItem:(id)item;
- (BOOL)outlineView:(FKOutlineView *)outlineView isOptionalColumn:(NSTableColumn *)aTableColumn;
- (id)outlineView:(FKOutlineView *)outlineView objectAtRow:(int)rowIndex;
- (id)outlineView:(FKOutlineView *)outlineView itemForObject:(id)anObject;
- (NSColor *)outlineView:(FKOutlineView *)outlineView colorForRowByItem:(id)item;

@end
