//
//  FKTableHeaderCell.m
//  FKFramework
//
//  Created by Eric on 18/03/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKTableHeaderCell.h"

@interface FKTableHeaderCell (Private)

- (NSSize)arrowSize;

@end

@implementation FKTableHeaderCell

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		horizontalMargin = 3.0;
	}
	
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (NSSize)arrowSize {return NSMakeSize(13, 8);}

- (NSRect)sortIndicatorRectForBounds:(NSRect)theRect
{
	NSRect arrowRect = theRect;
	
	arrowRect.size = [self arrowSize];
	arrowRect.origin.x += floor(NSWidth(theRect) - NSWidth(arrowRect));
	arrowRect.origin.y += floor((NSHeight(theRect) - NSHeight(arrowRect)) / 2);
	
	return arrowRect;
}

#pragma mark -
#pragma mark SETTERS

#pragma mark -
#pragma mark DRAWING

/*- (void)_setSortable:(BOOL)sortable showSortIndicator:(BOOL)showSortIndicator ascending:(BOOL)ascending priority:(int)priority highlightForSort:(BOOL)highlight
{
	sortPriority = priority;	
	
	isSortable = sortable;
	isAscending = ascending;
	showsSortIndicator = showSortIndicator;
}*/

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	if ( [[(FKTableView *)[(FKTableHeaderView *)controlView tableView] scrollView] borderType] != NSNoBorder )
	{
		cellFrame.origin.y -= 1.0;
		cellFrame.size.height += 2.0;
	}
	
	[super drawWithFrame:cellFrame inView:controlView];
	
	/*NSRect backgroundRect = NSZeroRect;
	NSRect bottomLineRect = NSZeroRect;
	
	NSDivideRect(cellFrame, &bottomLineRect, &backgroundRect, 1.0, NSMaxYEdge);
	
	NSBezierPath * path = nil;
	
	[NSGraphicsContext saveGraphicsState];
	
	// Fond de la cellule
	
	path = [NSBezierPath bezierPathWithRect:backgroundRect];
	
	//[path linearGradientFillWithStartColor:[NSColor colorWithDeviceRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]
	//							  endColor:[NSColor colorWithDeviceRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1.0]];
	
	[[NSColor colorWithDeviceRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0] set];
	
	[path fill];
	
	// Ligne inferieure
	
	path = [NSBezierPath bezierPathWithRect:bottomLineRect];
	
	[[NSColor colorWithDeviceRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] set];
	
	[path fill];
	
	// Trait separateur cote droit uniquement s'il ne s'agit
	// pas de l'en-tete de la derniere colonne de la table
	
	if ( (cellFrame.origin.x + cellFrame.size.width) < ([controlView frame].origin.x + [controlView frame].size.width) )
	{
		NSRect separatorRect = NSZeroRect;
		
		NSDivideRect(backgroundRect, &separatorRect, &backgroundRect, 1.0, NSMaxXEdge);
		
		NSBezierPath * path = [NSBezierPath bezierPathWithRect:separatorRect];
		
		//[[NSColor colorWithDeviceRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0] set];
		
		[path fill];
	}
	
	[NSGraphicsContext restoreGraphicsState];
	
	// Titre de l'en-tete
	
	[self drawInteriorWithFrame:cellFrame inView:controlView];
	
	if ( showsSortIndicator )
	{
		[self drawSortIndicatorWithFrame:cellFrame inView:controlView ascending:isAscending priority:sortPriority];
	}*/
}

/*- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSRect textRect = cellFrame;
	
	if ( isSortable )
	{
		if ( showsSortIndicator && !sortPriority )
		{
			NSDivideRect(cellFrame, &cellFrame, &textRect, ([self arrowSize].width + horizontalMargin), NSMaxXEdge);
		}
	}
	
	// Titre
	
	NSFont * font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
	NSShadow * shadow = nil; //[[[NSShadow alloc] init] autorelease];
	NSMutableParagraphStyle * style = [[[NSMutableParagraphStyle alloc] init] autorelease];
	
	[style setAlignment:[self alignment]];
	[style setLineBreakMode:NSLineBreakByTruncatingMiddle];

	[shadow setShadowColor:[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:0.75]];
	[shadow setShadowOffset:NSMakeSize(0.0, -1.0)];
	[shadow setShadowBlurRadius:1.0];
	
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, shadow, NSShadowAttributeName, style, NSParagraphStyleAttributeName, nil];	
	
	NSAttributedString * titleAttributedString = [[[NSAttributedString alloc] initWithString:[self title] attributes:attributes] autorelease];
	
	// On centre le texte verticalement
	
	textRect.size.width -= (2 * horizontalMargin);
	textRect.size.height = [titleAttributedString size].height;	
	textRect.origin.x += horizontalMargin;
	textRect.origin.y = floor((cellFrame.size.height - textRect.size.height) / 2);
	
	[titleAttributedString drawInRect:textRect];	
}

- (void)drawSortIndicatorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView ascending:(BOOL)ascending priority:(int)priority
{	
	if ( !priority )
	{
		AMTriangleOrientation orientation = AMTriangleUp;
		
		if ( ascending )
		{
			orientation = AMTriangleDown; // [controlView isFlipped] = YES !
		}
	
		NSRect arrowRect = [self sortIndicatorRectForBounds:cellFrame];
	
		NSBezierPath * path = [NSBezierPath bezierPathWithTriangleInRect:arrowRect orientation:orientation];
	
		NSShadow * shadow = nil; //[[[NSShadow alloc] init] autorelease];
	
		[shadow setShadowColor:[NSColor colorWithCalibratedRed:1.0 green:1.0 blue:1.0 alpha:0.75]];
		[shadow setShadowOffset:NSMakeSize(0.0, -1.0)];
		[shadow setShadowBlurRadius:1.0];
		[shadow set];
	
		[[NSColor colorWithDeviceRed:59.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1.0] set];
	
		[path fill];
	}
}*/

#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    id newCopy = [super copyWithZone:zone];
	
    return newCopy;
}

@synthesize horizontalMargin;
@synthesize sortPriority;
@synthesize isSortable;
@synthesize isAscending;
@synthesize showsSortIndicator;
@end
