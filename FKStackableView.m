//
//  FKStackableView.m
//  ShoppingBag
//
//  Created by Eric on 09/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKStackableView.h"

NSString * FKStackableViewWillCollapseNotification = @"FKStackableViewWillCollapseNotification";
NSString * FKStackableViewDidCollapseNotification = @"FKStackableViewDidCollapseNotification";
NSString * FKStackableViewDidExpandNotification = @"FKStackableViewDidExpandNotification";

#define kIconImageSize 16.0

@interface FKStackableView (Private)

- (void)setupPathsAndRects;

- (void)setBackgroundPath:(NSBezierPath *)aPath;

@end

@implementation FKStackableView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];

    if ( self )
	{
		[self setTitle:@"Title"];
		
		insetDeltas = NSMakeSize(1.0, 1.0);
		
		expandedHeight = 50.0;
		expandedHeaderHeight = floor(expandedHeight / 2.0);
		expandedFooterHeight = ceil(expandedHeight / 2.0);
		
		collapsedHeight = floor((expandedHeight / 2.0) + (2 * insetDeltas.height));
		
		// ...
		
		[self setScrollView:[[[NSScrollView alloc] initWithFrame:[self contentFrame]] autorelease]];
		
		[scrollView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
		[scrollView setHasVerticalScroller:YES];
		[scrollView setHasHorizontalScroller:YES];
		[scrollView setAutohidesScrollers:YES];
		
		[self addSubview:scrollView];
		
		// ...
		
		[self setupPathsAndRects];
    }
	
    return self;
}

- (void)dealloc
{	
	[self setTitle:nil];
	[self setImage:nil];
	[self setScrollView:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isCollapsed {return isCollapsed;}

- (NSRect)contentFrame
{
	NSRect contentFrame = [super contentFrame];
	
	contentFrame.origin.x += insetDeltas.width + 1.0;
	contentFrame.origin.y += (expandedFooterHeight + insetDeltas.height + 1.0);
	contentFrame.size.width -= NSMinX(contentFrame) * 2.0;
	contentFrame.size.height -= (expandedHeaderHeight + expandedFooterHeight + (2.0 * insetDeltas.height) + 2.0);
		
	return contentFrame;
}

- (NSString *)title {return title;}
- (float)collapsedHeight {return collapsedHeight;}

#pragma mark -
#pragma mark SETTERS

- (void)firstResponderDidChange:(NSNotification *)aNotification
{
	NSView * theView = [[aNotification userInfo] objectForKey:@"FKViewAttributeName"];
	
	if ( isCollapsed )
	{
		[stackView expandStackedView:self updateFirstResponder:NO animate:YES];
	}
	
	[theView centerInScrollView:scrollView];
}

- (void)setContentView:(NSView *)aView
{	
	if ( nil != contentView )
	{
		[[NSNotificationCenter defaultCenter] removeObserver:self name:@"FKViewFirstResponderDidChange" object:contentView];
	}
	
	// ...
	
	contentView = aView;
	
	// ...
	
	[contentView setFrameWidth:[scrollView contentSize].width];
	[contentView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
	
	// ...
	
	FKFlippedView * flippedView = [[[FKFlippedView alloc] initWithFrame:NSZeroRect] autorelease];
	
	NSSize contentMinSize = [contentView frame].size;
	
	contentMinSize.width = 0.0;
	
	[flippedView setFrameSize:[contentView frame].size];
	[flippedView setAutoresizingMask:NSViewWidthSizable];
	[flippedView addSubview:contentView];
	[flippedView setMinSize:contentMinSize];
	
	[scrollView setDocumentView:flippedView];
	
	// ...
		
	if ( nil != contentView )
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstResponderDidChange:) name:@"FKViewFirstResponderDidChange" object:contentView];
	}
}

- (void)setFrameSize:(NSSize)aSize
{
	[super setFrameSize:aSize];
	
	[self setupPathsAndRects];
	
	[scrollView setFrame:[self contentFrame]];
}

- (void)setTitle:(NSString *)aString
{
	if ( aString != title )
	{
		[title release];
		title = [aString retain];
	}
}

- (void)setImage:(NSImage *)anImage
{
	if ( anImage != image )
	{
		[image release];
		image = [anImage copy];
		
		[image setScalesWhenResized:YES];
		[image setSize:NSMakeSize(kIconImageSize, kIconImageSize)];
	}
}

- (void)setCollapsed:(BOOL)aBool {isCollapsed = aBool;}

- (void)setScrollView:(NSScrollView *)aView
{
	if ( aView != scrollView )
	{
		[scrollView release];
		scrollView = [aView retain];
	}
}

- (void)setStackView:(FKStackView *)aView {stackView = aView;}

#pragma mark -
#pragma mark ...

#pragma mark -
#pragma mark EVENTS

- (void)mouseDown:(NSEvent *)anEvent
{
	NSPoint mouseLocation = [anEvent locationInWindow];
	
	mouseLocation = [self convertPoint:mouseLocation fromView:nil];
	
	if ( NSMouseInRect(mouseLocation, headerRect, [self isFlipped]) )
	{
		if ( isCollapsed )
		{
			[stackView expandStackedView:self updateFirstResponder:YES animate:YES];
		}
	}
}

- (void)resetCursorRects
{
	if ( isCollapsed )
	{
		[self addCursorRect:headerRect cursor:[NSCursor pointingHandCursor]];
	}
}

#pragma mark -
#pragma mark LAYOUT & DRAWING

- (void)setupPathsAndRects
{
	NSRect bounds = [self bounds];
		
	NSRect insetBounds = NSInsetRect(bounds, insetDeltas.width, insetDeltas.height);
	
	// Fond
	
	backgroundRect = NSInsetRect(insetBounds, 0.5, 0.5);
		
	// Header
		
	NSDivideRect(insetBounds, &headerRect, &insetBounds, expandedHeaderHeight, NSMaxYEdge);	
	
	// Top separator
			
	NSDivideRect(insetBounds, &topSeparatorRect, &insetBounds, 1.0, NSMaxYEdge);
	
	// Footer

	NSDivideRect(insetBounds, &footerRect, &insetBounds, expandedFooterHeight, NSMinYEdge);
	
	// Bottom separator
		
	NSDivideRect(insetBounds, &bottomSeparatorRect, &insetBounds, 1.0, NSMinYEdge);
}

- (void)drawRect:(NSRect)rect
{
	//NSLog (@"FKStackableView - drawRect (BEGIN)");
		
	//NSFrameRect([self bounds]);
		
	NSRect bounds = [self bounds];
	NSRect insetBounds = NSInsetRect(bounds, insetDeltas.width, insetDeltas.height);
	
	NSColor * strokeColor = [NSColor lightBorderColor];
	NSBezierPath * backgroundPath = [NSBezierPath bezierPathWithRoundedRect:backgroundRect cornerRadius:10.0 cornerMask:FKEveryCorner];	
	
	// ******
	// Header
	// ******
		
	if ( NSHeight(bounds) <= expandedHeight )
	{
		NSRect topHeaderRect = NSZeroRect;
		NSRect bottomHeaderRect = NSZeroRect;
		
		NSBezierPath * topHeaderPath = nil;
		NSBezierPath * bottomHeaderPath = nil;
		
		NSDivideRect(insetBounds, &topHeaderRect, &bottomHeaderRect, floor(NSHeight(insetBounds) / 2.0), NSMaxYEdge);
				
		// ...
		
		[[NSColor colorWithDeviceRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] set];

		topHeaderPath = [NSBezierPath bezierPathWithRoundedRect:topHeaderRect cornerRadius:10.0 cornerMask:(FKTopLeftCorner | FKTopRightCorner)];
		
		[topHeaderPath fill];
		
		// ...
		
		[[NSColor colorWithDeviceRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0] set];
		
		bottomHeaderPath = [NSBezierPath bezierPathWithRoundedRect:bottomHeaderRect cornerRadius:10.0 cornerMask:(FKBottomLeftCorner | FKBottomRightCorner)];
		
		[bottomHeaderPath fill];
	}
	else
	{
		// Fond
		
		[[NSColor whiteColor] set];
		
		[backgroundPath fill];
		
		// ...
		
		NSBezierPath * topTitlePath = [NSBezierPath bezierPathWithRoundedRect:headerRect cornerRadius:10.0 cornerMask:(FKTopLeftCorner | FKTopRightCorner)];
		
		[[NSColor colorWithDeviceRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0] set];
		
		[topTitlePath fill];
	}
	
	if ( NSHeight(bounds) > expandedHeight )
	{
		[strokeColor set];
		
		// ********************
		// Separateur superieur
		// ********************
			
		[NSBezierPath fillRect:topSeparatorRect];
	
		// ********************
		// Separateur inferieur
		// ********************
	
		[NSBezierPath fillRect:bottomSeparatorRect];
	
		// ******
		// Footer
		// ******
	
		NSBezierPath * footerPath = [NSBezierPath bezierPathWithRoundedRect:footerRect cornerRadius:10.0 cornerMask:(FKBottomLeftCorner | FKBottomRightCorner)];

		[[NSColor colorWithDeviceRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0] set];
	
		[footerPath fill];
	}
	
	// ******
	// Stroke
	// ******
	
	[strokeColor set];
	
	[backgroundPath setLineWidth:1.0];
	[backgroundPath stroke];
	
	// Image & Title
	
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[[FKModuleTheme currentTheme] textFont], NSFontAttributeName, [[FKModuleTheme currentTheme] standardTextColor], NSForegroundColorAttributeName, nil];
	NSAttributedString * titleAttrString = [[[NSAttributedString alloc] initWithString:[self title] attributes:attributes] autorelease];	
	
	// ...
	
	NSRect imageAndTitleRect = headerRect;
	NSRect titleRect = NSZeroRect;
	NSRect imageRect = NSZeroRect;
	
	NSSize imageSize = [image size];
	NSSize titleSize = [titleAttrString size];	
	
	imageAndTitleRect.size.width = 0.0;
		
	if ( nil != image )
	{
		imageAndTitleRect.size.width += imageSize.width + 4.0;
	}

	imageAndTitleRect.size.width += titleSize.width;
	imageAndTitleRect.origin.x += ceil((NSWidth(headerRect) - NSWidth(imageAndTitleRect)) / 2.0);		
	
	// Image	
	
	if ( nil != image )
	{	
		NSDivideRect(imageAndTitleRect, &imageRect, &titleRect, imageSize.width + 4.0, NSMinXEdge);		
		
		NSRect srcRect = NSZeroRect;

		srcRect.size = imageSize;
	
		imageRect.size = srcRect.size;
		imageRect.origin.y += ceil((NSHeight(headerRect) - NSHeight(imageRect)) / 2.0);	
	
		[image drawInRect:imageRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];
	}
	else
	{
		titleRect = imageAndTitleRect;
	}
		
	// Titre
		
	titleRect.size.height = titleSize.height;
	titleRect.origin.y += ceil((NSHeight(headerRect) - NSHeight(titleRect)) / 2.0);
	
	[titleAttrString drawInRect:titleRect];
	
	//NSLog (@" FKStackableView - drawRect (END)");
}

@synthesize trackingRectTag;
@synthesize stackView;
@synthesize collapsedHeight;
@synthesize expandedHeight;
@synthesize expandedHeaderHeight;
@synthesize expandedFooterHeight;
@end
