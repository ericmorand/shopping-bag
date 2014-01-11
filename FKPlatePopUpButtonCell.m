//
//  FKPlatePopUpButtonCell.m
//  FKKit
//
//  Created by Eric on 05/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKPlatePopUpButtonCell.h"
#import "FKButtonCell.h"


@interface FKPlatePopUpButtonCell (Private)

- (NSRect)mainTitleRectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (NSRect)titleRectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (NSRect)arrowsRectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end

@implementation FKPlatePopUpButtonCell

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		arrowSize = NSMakeSize(5, 4);
		
		[self setDrawingCell:[[[FKPlateGradientButtonCell alloc] init] autorelease]];
	}
	
	return self;
}

- (void)dealloc
{
	[self setMainTitle:nil];
	[self setDrawingCell:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (FKPlateGradientButtonCell *)drawingCell {return drawingCell;}

- (NSDictionary *)titleStringAttributes
{
	NSMutableParagraphStyle * style = [[[NSMutableParagraphStyle alloc] init] autorelease];
	
	[style setLineBreakMode:NSLineBreakByTruncatingTail];
	
	return [NSDictionary dictionaryWithObjectsAndKeys:
		[self font], NSFontAttributeName,
		titleForegroundColor, NSForegroundColorAttributeName,
		style, NSParagraphStyleAttributeName,
		nil];
}

- (NSSize)cellSize
{
	NSSize cellSize = NSZeroSize;
	
	switch ( [self controlSize] )
	{
		case NSMiniControlSize : {cellSize.height = 18.0; break;}
		case NSSmallControlSize : {cellSize.height = 22.0; break;}
		default : {cellSize.height = 26.0;}
	}
	
	// ...
	
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self font], NSFontAttributeName, nil];	
	NSEnumerator * itemsEnumerator = [[[self menu] itemArray] objectEnumerator];
	NSAttributedString * titleAttrString = nil;
	NSMenuItem * anItem = nil;
	
	float maxWidth = 0.0;
	
	while ( anItem = [itemsEnumerator nextObject] )
	{
		titleAttrString = [[[NSAttributedString alloc] initWithString:[anItem title] attributes:attributes] autorelease];
		
		maxWidth = MAX(maxWidth, [titleAttrString size].width);
	}
	
	cellSize.width = maxWidth + 30.0 + arrowSize.width;
	
	return cellSize;
}

- (NSRect)drawingRectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSRect drawingRect = cellFrame;
	
	float deltaX = 0.0;
	float deltaY = 0.0;
	float deltaWidth = 0.0;
	float deltaHeight = 0.0;
	
	switch ( [self controlSize] )
	{
		case NSMiniControlSize : {break;}
		case NSSmallControlSize :
		{
			deltaX = 3.0;
			
			if ( [controlView isFlipped] )
			{
				deltaY = 1.0;
			}
			else
			{
				deltaY = 3.0;
			}
			
			deltaWidth = 6.0;
			deltaHeight = 4.0;

			break;
		}
		case NSRegularControlSize :
		{
			deltaX = 3.0;
			
			if ( [controlView isFlipped] )
			{
				deltaY = 1.0;
			}
			else
			{
				deltaY = 4.0;
			}
			
			deltaWidth = 6.0;
			deltaHeight = 5.0;
			break;
		}
	}
		
	drawingRect.origin.x += deltaX;
	drawingRect.origin.y += deltaY;
	drawingRect.size.width -= deltaWidth;
	drawingRect.size.height -= deltaHeight;
	
	return drawingRect;
}

- (NSRect)mainTitleRectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSRect mainTitleRect = NSZeroRect;
	NSRect drawingRect = [self drawingRectForCellFrame:cellFrame inView:controlView];
	NSRect arrowsRect = [self arrowsRectForCellFrame:cellFrame inView:controlView];
	
	float availableWidth = 0.0;
	
	mainTitleRect.origin = drawingRect.origin;	
	
	if ( nil != mainTitle )
	{
		mainTitleRect.size = [mainTitle sizeWithAttributes:[self titleStringAttributes]];
	
		mainTitleRect.origin.x += floor(NSHeight(cellFrame) / 2.0);
		mainTitleRect.origin.y += floor((NSHeight(drawingRect) - NSHeight(mainTitleRect)) / 2.0);
	
		availableWidth = NSMinX(arrowsRect) - NSMinX(mainTitleRect) - 5.0;
	
		mainTitleRect.size.width = MIN(ceil(NSWidth(mainTitleRect)), availableWidth);
	}
	
	return mainTitleRect;
}

- (NSRect)titleRectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSRect titleRect = NSZeroRect;
	NSRect drawingRect = [self drawingRectForCellFrame:cellFrame inView:controlView];
	NSRect mainTitleRect = [self mainTitleRectForCellFrame:cellFrame inView:controlView];
	NSRect arrowsRect = [self arrowsRectForCellFrame:cellFrame inView:controlView];
		
	titleRect.origin = drawingRect.origin;
	titleRect.size = [[self title] sizeWithAttributes:[self titleStringAttributes]];
	
	if ( nil != mainTitle )
	{
		titleRect.origin.x = NSMaxX(mainTitleRect) + 5.0;
	}
	else
	{
		titleRect.origin.x += floor(NSHeight(cellFrame) / 2.0);
	}
	
	titleRect.origin.y += floor((NSHeight(drawingRect) - NSHeight(titleRect)) / 2.0);
	titleRect.size.width = (NSMinX(arrowsRect) - 5.0) - NSMinX(titleRect);
		
	return titleRect;
}

- (NSRect)arrowsRectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSRect drawingRect = [self drawingRectForCellFrame:cellFrame inView:controlView];
	
	NSRect arrowsRect = drawingRect;
	
	if ( [self pullsDown] )
	{
		arrowsRect.size.width = 7.0;
		arrowsRect.size.height = 6.0;
	}
	else
	{
		arrowsRect.size.width = arrowSize.width;
		arrowsRect.size.height = (2 * arrowSize.height) + 2.0;
	}
	
	arrowsRect.origin.x = NSMaxX(drawingRect) - (NSWidth(arrowsRect) + 6.0);
	arrowsRect.origin.y += ceil((NSHeight(drawingRect) - NSHeight(arrowsRect)) / 2.0);
	
	return arrowsRect;
}

- (NSBezierPath *)strokePathWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	return [drawingCell strokePathWithFrame:cellFrame inView:controlView];
}

#pragma mark -
#pragma mark SETTERS

- (void)setMainTitle:(NSString *)aString
{
	if ( aString != mainTitle )
	{
		[mainTitle release];
		mainTitle = [aString retain];
	}
}

- (void)setTitleForegroundColor:(NSColor *)aColor
{
	if ( aColor != titleForegroundColor )
	{
		[titleForegroundColor release];
		titleForegroundColor = [aColor retain];
	}
}

- (void)setRightAnglesMask:(unsigned)anInt {[drawingCell setRightAnglesMask:anInt];}
- (void)setStrokedBordersMask:(unsigned)anInt {[drawingCell setStrokedBordersMask:anInt];}
- (void)setHighlighted:(BOOL)flag {[drawingCell setHighlighted:flag];}

- (void)setDrawingCell:(NSButtonCell *)aCell
{
	if ( aCell != drawingCell )
	{
		[drawingCell release];
		drawingCell = [aCell retain];
	}
}

#pragma mark -
#pragma mark DRAWING

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSRect drawingRect = [self drawingRectForCellFrame:cellFrame inView:controlView];
	
	[drawingCell setEnabled:[self isEnabled]];
	[drawingCell drawWithFrame:drawingRect inView:controlView];
	
	//NSFrameRect(drawingRect);
	
	if ( [self showsFirstResponder] )
	{
		NSBezierPath * focusRingPath = nil;
		
		focusRingPath = [self strokePathWithFrame:drawingRect inView:controlView];
		
		[NSGraphicsContext saveGraphicsState];
		
		NSSetFocusRingStyle(NSFocusRingOnly);
		
		[focusRingPath fill];
		
		[NSGraphicsContext restoreGraphicsState];
	}
	
	[self drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	[NSGraphicsContext saveGraphicsState];	

	NSRect titleRect = NSZeroRect;
	NSRect mainTitleRect = NSZeroRect;
	
	NSAttributedString * titleAttrString = nil;	
	NSDictionary * titleStringAttributes = [self titleStringAttributes]; 
	
	// ***************
	// Titre principal
	// ***************
	
	titleAttrString = [[[NSAttributedString alloc] initWithString:mainTitle attributes:titleStringAttributes] autorelease];
	
	mainTitleRect = [self mainTitleRectForCellFrame:cellFrame inView:controlView];
	
	[titleAttrString drawInRect:mainTitleRect];	
		
	// *****
	// Titre
	// *****
		
	titleAttrString = [[[NSAttributedString alloc] initWithString:[self title] attributes:titleStringAttributes] autorelease];
	
	titleRect = [self titleRectForCellFrame:cellFrame inView:controlView];
	
	[titleAttrString drawInRect:titleRect];
	
	//NSFrameRect(titleRect);
	
	// *******
	// Fleches
	// *******
		
	[[NSColor colorWithCalibratedRed:76.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0] set];	
	
	NSBezierPath * arrowPath = nil;	
	
	NSRect arrowsRect = [self arrowsRectForCellFrame:cellFrame inView:controlView];
		
	if ( [self pullsDown] )
	{
		arrowsRect.size.height = 6.0;
		arrowsRect.size.width = 7.0;
		
		arrowPath = [NSBezierPath bezierPathWithTriangleInRect:arrowsRect orientation:AMTriangleUp];		
	}
	else
	{
		NSRect topArrowRect = NSZeroRect;
		NSRect bottomArrowRect = NSZeroRect;
	
		NSDivideRect(arrowsRect, &topArrowRect, &arrowsRect, arrowSize.height, NSMinYEdge);
		NSDivideRect(arrowsRect, &bottomArrowRect, &arrowsRect, arrowSize.height, NSMaxYEdge);
	
		arrowPath = [NSBezierPath bezierPathWithTriangleInRect:topArrowRect orientation:AMTriangleDown];
	
		[arrowPath appendBezierPath:[NSBezierPath bezierPathWithTriangleInRect:bottomArrowRect orientation:AMTriangleUp]];
	}
	
	[arrowPath fill];
	
	[NSGraphicsContext restoreGraphicsState];
}

@end
