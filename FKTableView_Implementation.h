//
//  FKTableView_Implementation.h
//  FK
//
//  Created by Eric Morand on Thu Apr 08 2004.
//  Copyright (c) 2004 Eric Morand. All rights reserved.
//

- (id)commonInitWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	_savedTableColumns = [[self tableColumns] copy];
	_rowSeparatorColor = [[NSColor lightGrayColor] retain];
		
	_rowSeparatorWidth = 1.0;
	rowSeparatorMargin = 0.0;
	
	return self;	
}

- (id)commonInitWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	_savedTableColumns = [[self tableColumns] copy];
	_rowSeparatorColor = [[NSColor lightGrayColor] retain];
	
	_rowSeparatorWidth = 1.0;
	rowSeparatorMargin = 0.0;
	
	return self;
}

- (void)commonDealloc
{
	[_savedTableColumns release];
	[_rowSeparatorColor release];
	
	_savedTableColumns = nil;
	_rowSeparatorColor = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{	
	// Remplacement de l'en-tte de la table si la table en possde un
	
	if ( [self headerView] )
	{
		NSRect headerFrame = [[self headerView] frame];
		
		if ( [[self scrollView] borderType] == NSNoBorder )
		{
			//headerFrame.size.height = NSHeight(headerFrame) + 10.0;
		}
		
		[self setHeaderView:[[[FKTableHeaderView alloc] initWithFrame:headerFrame] autorelease]];
	
		[[self headerView] awakeFromNib];
	}
	
	// Remplacement des cells des entetes de colonnes
	
	NSEnumerator * columnEnumerator = [[self tableColumns] objectEnumerator];
	FKTableHeaderCell * newCell = nil;
	NSTableHeaderCell * oldCell = nil;
	NSTableColumn * aColumn = nil;
	
	while ( aColumn = [columnEnumerator nextObject] )
	{
		oldCell = [aColumn headerCell];
		
		newCell = [[[FKTableHeaderCell alloc] init] autorelease];
		
		[newCell setTitle:[oldCell title]];
		[newCell setAlignment:[oldCell alignment]];
		
		//[aColumn setHeaderCell:newCell];
	}
	
	// Corner view
	
	//[self setCornerView:[[FKTableCornerView alloc] initWithFrame:NSZeroRect]];
}

#pragma mark -
#pragma mark SETTERS

- (void)setRowSeparatorColor:(NSColor *)aColor
{
	[_rowSeparatorColor release];
	_rowSeparatorColor = [aColor retain];
}

- (void)setRowSeparatorWidth:(float)newFloat {_rowSeparatorWidth = newFloat;}
- (void)setRowSeparatorMargin:(float)newFloat {rowSeparatorMargin = newFloat;}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isOpaque {return ( [[self backgroundColor] alphaComponent] == 1.0 );}

- (NSColor *)rowSeparatorColor {return _rowSeparatorColor;}
- (float)rowSeparatorWidth {return _rowSeparatorWidth;}

- (NSArray *)savedTableColumnsSorted
{
	NSSortDescriptor * aSortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES] autorelease];
	
	return [_savedTableColumns sortedArrayUsingDescriptors:[NSArray arrayWithObjects:aSortDescriptor, nil]];
}

- (NSScrollView *)scrollView
{
	NSScrollView * scrollView = (NSScrollView *)[[self superview] superview];
	
	return scrollView;
}

#pragma mark -
#pragma mark MISC

- (void)addTableColumn:(NSTableColumn *)aTableColumn
{
	[super addTableColumn:(NSTableColumn *)aTableColumn];
	
	[self sizeToFit];
}

- (void)removeTableColumn:(NSTableColumn *)aTableColumn
{
	[super removeTableColumn:(NSTableColumn *)aTableColumn];
	
	[self sizeToFit];
}

#pragma mark -
#pragma mark DRAW

- (void)drawRow:(int)rowIndex clipRect:(NSRect)clipRect
{	
	NSBezierPath * aPath = nil;
	
	NSRect rowRect = [self rectOfRow:rowIndex];

	NSColor * rowColor = [self colorForRowAtIndex:rowIndex];
	
	if ( rowColor )
	{
		aPath = [NSBezierPath bezierPathWithRect:rowRect];	
		
		[rowColor set];
		
		[aPath fill];
	}
	
	NSPoint startPoint = rowRect.origin;
	NSPoint endPoint = rowRect.origin;
	
	if ( [self isSeparatorRowAtIndex:rowIndex] )
	{
		aPath = [NSBezierPath bezierPath];
		
		[_rowSeparatorColor set];
		
		// On centre le separateur dans le rectangle de la ligne
		
		startPoint.x += rowSeparatorMargin;
		startPoint.y += ceil((rowRect.size.height - _rowSeparatorWidth) / 2);
		
		endPoint.x += ceil(rowRect.size.width - rowSeparatorMargin);
		endPoint.y = startPoint.y;
		
		[aPath setLineWidth:_rowSeparatorWidth];
		[aPath moveToPoint:startPoint];
		[aPath lineToPoint:endPoint];
		[aPath stroke];
	}
	
	[super drawRow:rowIndex clipRect:clipRect];
}

#pragma mark -
#pragma mark MISC

- (BOOL)isValidDelegateForSelector:(SEL)command
{
    return ( ( [self delegate] != nil ) && [[self delegate] respondsToSelector:command] );
}

- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
	NSIndexSet * selectedRowIndexes;
	NSPoint mouseLocation;
	int clickedRowIndex = -1;
	
	// Si une ou plusieurs lignes de la table sont dŽjˆ sŽlectionnŽes, et que le clic droit de la souris est
	// intervenu sur une de ces lignes, ne rien faire. Dans le cas contraire, sŽlectionner la
	// ligne sur laquelle est intervenu le clic de la souris
	
	selectedRowIndexes = [self selectedRowIndexes];
	mouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	clickedRowIndex = [self rowAtPoint:mouseLocation];	
	
	if ( clickedRowIndex > -1 )
	{
		if ( ![selectedRowIndexes containsIndex:clickedRowIndex] )
		{
			[self selectRowIndexes:[NSIndexSet indexSetWithIndex:clickedRowIndex] byExtendingSelection:NO];
		}
	}
	else // Au cas o mais ne devrait jamais arriver
	{
		[self deselectAll:nil];
	}
	
	return [super menuForEvent:theEvent];	
}

- (void)selectAndScrollToLastObjectRelative:(BOOL)flag
{
	NSArray * sortDescriptors = nil;
	NSSortDescriptor * aSortDescriptor = nil;

	unsigned toSelectIndex = 0;	
	
	int numberOfRows = [self numberOfRows];
	
	if ( numberOfRows > 0 )
	{
		if ( flag )
		{
			sortDescriptors = [self sortDescriptors];
		
			if ( [sortDescriptors count] )
			{
				aSortDescriptor = [sortDescriptors objectAtIndex:0];
			
				if ( [aSortDescriptor ascending] )
				{
					toSelectIndex = numberOfRows - 1;
				}
			}
		}
		else
		{
			toSelectIndex = numberOfRows - 1;
		}

		[self scrollRowToVisible:toSelectIndex];
		[self selectRowIndexes:[NSIndexSet indexSetWithIndex:toSelectIndex] byExtendingSelection:NO];
	}
}

- (void)selectAndScrollToFirstObjectRelative:(BOOL)flag
{
	NSArray * sortDescriptors = nil;
	NSSortDescriptor * aSortDescriptor = nil;
	
	unsigned toSelectIndex = 0;	
	
	int numberOfRows = [self numberOfRows];
	
	if ( numberOfRows > 0 )
	{
		if ( flag )
		{
			sortDescriptors = [self sortDescriptors];
			
			if ( [sortDescriptors count] )
			{
				aSortDescriptor = [sortDescriptors objectAtIndex:0];
				
				if ( [aSortDescriptor ascending] )
				{
					toSelectIndex = numberOfRows - 1;
				}
			}
		}
		else
		{
			toSelectIndex = 0;
		}
		
		[self scrollRowToVisible:toSelectIndex];
		[self selectRowIndexes:[NSIndexSet indexSetWithIndex:toSelectIndex] byExtendingSelection:NO];
	}
}

#pragma mark -
#pragma mark GRADIENT HIGHLIGHT

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
	NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter removeObserver:self name:NSWindowDidResignKeyNotification object:nil];
	[defaultCenter addObserver:self selector:@selector(windowDidChangeKeyNotification:) name:NSWindowDidResignKeyNotification object:newWindow];
	
	[defaultCenter removeObserver:self name:NSWindowDidBecomeKeyNotification object:nil];
	[defaultCenter addObserver:self selector:@selector(windowDidChangeKeyNotification:) name:NSWindowDidBecomeKeyNotification object:newWindow];
}

- (void)windowDidChangeKeyNotification:(NSNotification *)notification
{
	[self setNeedsDisplay:YES];
}

- (void)highlightSelectionInClipRect:(NSRect)clipRect
{
	if ( !usesGradientSelection )
	{
		[super highlightSelectionInClipRect:clipRect];
		
		return;
	}
	
	NSColor * topLineColor, * bottomLineColor, * gradientStartColor, * gradientEndColor;
	
	NSResponder * firstResponder = [[self window] firstResponder];
		
	if ( ( ![firstResponder isKindOfClass:[NSView class]] ) || ( ![(NSView *)firstResponder isDescendantOf:self] ) || ( ![[self window] isKeyWindow] ) || ( [self usesDisabledGradientSelectionOnly] ) )
	{		
		topLineColor = [NSColor colorWithDeviceRed:(136.0/255.0) green:(135.0/255.0) blue:(135.0/255.0) alpha:1.0];
		bottomLineColor = [NSColor colorWithDeviceRed:(111.0/255.0) green:(111.0/255.0) blue:(111.0/255.0) alpha:1.0];
		gradientStartColor = [NSColor colorWithDeviceRed:(159.0/255.0) green:(159.0/255.0) blue:(159.0/255.0) alpha:1.0];
		gradientEndColor = [NSColor colorWithDeviceRed:(111.0/255.0) green:(111.0/255.0) blue:(111.0/255.0) alpha:1.0];
	}
	else
	{		
		topLineColor = [NSColor colorWithDeviceRed:(0.0/255.0) green:(123.0/255.0) blue:(226.0/255.0) alpha:1.0];
		bottomLineColor = [NSColor colorWithDeviceRed:(0.0/255.0) green:(75.0/255.0) blue:(226.0/255.0) alpha:1.0];
		gradientStartColor = [NSColor colorWithDeviceRed:(0.0/255.0) green:(154.0/255.0) blue:(236.0/255.0) alpha:1.0];
		gradientEndColor = [NSColor colorWithDeviceRed:(0.0/255.0) green:(91.0/255.0) blue:(215.0/255.0) alpha:1.0];
	}
	
	NSIndexSet * selRows = [self selectedRowIndexes];
	
	int rowIndex = [selRows firstIndex];
	int endOfCurrentRunRowIndex, newRowIndex;
	
	NSRect highlightRect;
	
	while ( rowIndex != NSNotFound )
	{
		if ( [self selectionGradientIsContiguous] )
		{
			newRowIndex = rowIndex;
			
			do
			{
				endOfCurrentRunRowIndex = newRowIndex;
				newRowIndex = [selRows indexGreaterThanIndex:endOfCurrentRunRowIndex];
			}
			while (newRowIndex == endOfCurrentRunRowIndex + 1);
			
			highlightRect = NSUnionRect([self rectOfRow:rowIndex], [self rectOfRow:endOfCurrentRunRowIndex]);
		}
		else
		{
			newRowIndex = [selRows indexGreaterThanIndex:rowIndex];
			highlightRect = [self rectOfRow:rowIndex];
		}
				
		if ( [self hasBreakBetweenGradientSelectedRows] )
		{
			highlightRect.size.height -= 1.0;
		}
		
		// ...
		
		NSRect topLineRect = NSZeroRect;
		NSRect bottomLineRect = NSZeroRect;
		
		NSDivideRect(highlightRect, &topLineRect, &highlightRect, 1.0, NSMinYEdge);
		NSDivideRect(highlightRect, &bottomLineRect, &highlightRect, 1.0, NSMaxYEdge);
		
		NSBezierPath * path = nil;
		
		// ...
		
		path = [NSBezierPath bezierPathWithRect:topLineRect];
		
		[topLineColor set];
		
		[path fill];
		
		// ...
		
		path = [NSBezierPath bezierPathWithRect:highlightRect];
						
		[path linearGradientFillWithStartColor:gradientStartColor endColor:gradientEndColor];
		
		// ...
		
		path = [NSBezierPath bezierPathWithRect:bottomLineRect];
		
		[bottomLineColor set];
		
		[path fill];
		
		// ...
		
		rowIndex = newRowIndex;
	}
}

- (id)_highlightColorForCell:(NSCell *)cell
{
	if ( !usesGradientSelection )
	{
		return [super _highlightColorForCell:cell];
	}
	
	return nil;
}

- (void)selectRow:(int)row byExtendingSelection:(BOOL)extend
{
	[super selectRow:row byExtendingSelection:extend];
	
	// If we are using a contiguous gradient, we need to force a redraw of more than
	// just the current row - all selected rows will need redrawing
	
	if ( [self usesGradientSelection] && [self selectionGradientIsContiguous] )
	{
		[self setNeedsDisplay:YES];
	}
}

- (void)selectRowIndexes:(NSIndexSet *)rowIndexes byExtendingSelection:(BOOL)extend
{
	[super selectRowIndexes:rowIndexes byExtendingSelection:extend];
	
	// If we are using a contiguous gradient, we need to force a redraw of more than
	// just the current row - all selected rows will need redrawing
	
	if ( [self usesGradientSelection] && [self selectionGradientIsContiguous] )
	{
		[self setNeedsDisplay:YES];
	}
} 

- (void)deselectRow:(int)row;
{
	[super deselectRow:row];
	
	// If we are using a contiguous gradient, we need to force a redraw of more than
	// just the current row in case multiple are selected, as selected rows will need redrawing
	
	if ( [self usesGradientSelection] && [self selectionGradientIsContiguous] )
	{
		[self setNeedsDisplay:YES];
	}
}

- (NSImage *)dragImageForRowsWithIndexes:(NSIndexSet *)dragRows tableColumns:(NSArray *)tableColumns event:(NSEvent*)dragEvent offset:(NSPointPointer)dragImageOffset
{
	// We need to save the dragged row indexes so that the delegate can choose how to colour the
	// text depending on whether it is being used for a drag image or not (eg. selected row may
	// have white text, but we still want to colour it black when drawing the drag image)
	
	draggedRows = dragRows;
	
	NSImage * image = [super dragImageForRowsWithIndexes:dragRows tableColumns:tableColumns event:dragEvent offset:dragImageOffset];
	
	draggedRows = nil;
	
	return image;
}

- (NSIndexSet *)draggedRows
{
	return draggedRows;
}

- (void)setUsesGradientSelection:(BOOL)flag
{
	usesGradientSelection = flag;
	
	[self setNeedsDisplay:YES];
}

- (BOOL)usesGradientSelection
{
	return usesGradientSelection;
}

- (void)setSelectionGradientIsContiguous:(BOOL)flag
{
	selectionGradientIsContiguous = flag;
	
	[self setNeedsDisplay:YES];
}

- (BOOL)selectionGradientIsContiguous
{
	return selectionGradientIsContiguous;
}

- (void)setUsesDisabledGradientSelectionOnly:(BOOL)flag
{
	usesDisabledGradientSelectionOnly = flag;
	
	[self setNeedsDisplay:YES];
}

- (BOOL)usesDisabledGradientSelectionOnly
{
	return usesDisabledGradientSelectionOnly;
}

- (void)setHasBreakBetweenGradientSelectedRows:(BOOL)flag
{
	hasBreakBetweenGradientSelectedRows = flag;
	
	[self setNeedsDisplay:YES];
}

- (BOOL)hasBreakBetweenGradientSelectedRows
{
	return hasBreakBetweenGradientSelectedRows;
}