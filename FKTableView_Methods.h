//
//  FKTableView_Methods.h
//  FK
//
//  Created by Eric Morand on Thu Apr 08 2004.
//  Copyright (c) 2004 Eric Morand. All rights reserved.
//

- (NSArray *)savedTableColumnsSorted;
- (NSColor *)rowSeparatorColor;
- (float)rowSeparatorWidth;
- (NSScrollView *)scrollView;

- (void)setRowSeparatorColor:(NSColor *)aColor;
- (void)setRowSeparatorWidth:(float)newFloat;
- (void)setRowSeparatorMargin:(float)newFloat;

- (BOOL)isValidDelegateForSelector:(SEL)command;
- (BOOL)isSeparatorRowAtIndex:(int)rowIndex;
- (BOOL)shouldDrawSeparatorForRowAtIndex:(int)rowIndex;
- (BOOL)isOptionalColumn:(NSTableColumn *)aTableColumn;
- (id)objectAtRow:(int)rowIndex;
- (unsigned)rowForObject:(id)anObject;
- (NSColor *)colorForRowAtIndex:(int)rowIndex;

- (id)selectedObject;
- (NSArray *)selectedObjects;
- (void)selectObject:(id)anObject;
- (void)scrollObjectToVisible:(id)anObject;
- (void)selectAndScrollToFirstObjectRelative:(BOOL)flag;
- (void)selectAndScrollToLastObjectRelative:(BOOL)flag;

- (NSIndexSet *)draggedRows;

- (BOOL)isRowVisible:(NSUInteger)rowIndex;

- (void)setUsesGradientSelection:(BOOL)flag;
- (BOOL)usesGradientSelection;

- (void)setSelectionGradientIsContiguous:(BOOL)flag;
- (BOOL)selectionGradientIsContiguous;

- (void)setUsesDisabledGradientSelectionOnly:(BOOL)flag;
- (BOOL)usesDisabledGradientSelectionOnly;

- (void)setHasBreakBetweenGradientSelectedRows:(BOOL)flag;
- (BOOL)hasBreakBetweenGradientSelectedRows;