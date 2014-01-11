//
//  FKView.m
//  ShoppingBag
//
//  Created by Eric on 10/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKView.h"
#import "FKFocusView.h"


@interface FKView (Private)

- (void)commonSetup;
- (void)setupRespondersChain;

@end

@implementation FKView

@synthesize borderColor;
@synthesize focusView;
@synthesize isHighlighted;
@synthesize firstResponder;
@synthesize lastResponder;

- (id)initWithCoder:(NSCoder *)decoder
{    
	self = [super initWithCoder:decoder];
    
	if ( self )
	{
		[self commonSetup];	
	}
	
    return self;
}

- (id)initWithFrame:(NSRect)frame
{    
	self = [super initWithFrame:frame];
    
	if ( self )
	{
		[self commonSetup];	
	}
	
    return self;
}

- (void)commonSetup
{
	self.borderColor = [NSColor lightBorderColor];
	
	focusView = [[FKFocusView alloc] initWithFrame:NSZeroRect];	
	
	[focusView setAutoresizingMask:(NSViewWidthSizable | NSViewHeightSizable)];
}

- (void)dealloc
{
	[self setBackgroundColor:nil];
	self.borderColor = nil;
	[self setContentView:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (NSView *)contentView {return contentView;}

- (NSRect)contentFrame
{	
	NSRect contentFrame = [self bounds];
	
	if ( borderMask & FKBottomBorder )
	{
		contentFrame.origin.y++;
		contentFrame.size.height--;
	}
	
	if ( borderMask & FKTopBorder )
	{
		contentFrame.size.height--;
	}
	
	if ( borderMask & FKLeftBorder )
	{
		contentFrame.origin.x++;
		contentFrame.size.width--;
	}	
	
	if ( borderMask & FKRightBorder )
	{
		contentFrame.size.width--;
	}
	
	return contentFrame;
}

- (NSSize)minSize {return minSize;}

#pragma mark -
#pragma mark SETTERS

- (void)setFrameSize:(NSSize)newSize
{
	//NSLog (@"FKView - setFrameSize : %@", NSStringFromSize(newSize));
	
	newSize.width = MAX(newSize.width, minSize.width);
	newSize.height = MAX(newSize.height, minSize.height);
	
	NSView * superview = [self superview];
	
	if ( [superview isKindOfClass:[NSClipView class]] )
	{
		NSSize superSize = [superview frame].size;
		
		newSize.height = MAX(newSize.height, superSize.height);	
	}
	
	[super setFrameSize:newSize];	
}

- (void)setHighlighted:(BOOL)flag
{
	isHighlighted = flag;
	
	if ( isHighlighted )
	{
		[focusView setFrame:[self bounds]];
		
		[self addSubview:focusView positioned:NSWindowAbove relativeTo:nil];
	}
	else
	{
		[focusView removeFromSuperview];
	}
}

- (void)resizeWithOldSuperviewSize:(NSSize)oldBoundsSize
{		
	if ( !NSEqualSizes(minSize, NSZeroSize) )
	{		
		NSSize newSize = [[self superview] frame].size;
		
		newSize.width = MAX(newSize.width, minSize.width);
		newSize.height = MAX(newSize.height, minSize.height);
		
		[self setFrameSize:newSize];
	}
	else
	{
		[super resizeWithOldSuperviewSize:oldBoundsSize];
	}
}

- (void)setBackgroundColor:(NSColor *)aColor
{
	if ( aColor != backgroundColor )
	{
		[backgroundColor release];
		backgroundColor = [aColor retain];
	}
}

- (void)setMinSize:(NSSize)aSize
{
	if ( !NSEqualSizes(aSize, minSize) )
	{
		minSize = aSize;
	}
}

- (void)setBorderMask:(unsigned)anInt
{
	if ( anInt != borderMask )
	{
		borderMask = anInt;
		
		[self setNeedsDisplay:YES];
	}
}

- (void)setContentView:(NSView *)aView {
	NSArray * arr = [NSArray arrayWithArray:[self subviews]];
	
	for (NSView * subview in arr) {
		[subview removeFromSuperview];
	}
	
	// ...
	
	[aView setFrame:[self contentFrame]];
	
	contentView = aView;
	
	[self addSubview:aView];
}

#pragma mark -
#pragma mark LAYOUT & DRAWING

- (void)sizeToFit
{
	
}

- (void)drawRect:(NSRect)aRect
{	
	NSRect backgroundRect = [self bounds];
	NSRect borderRect = NSZeroRect;
	
	[NSGraphicsContext saveGraphicsState];	
	
	// Bordures
	
	[borderColor set];
	
	if ( borderMask & FKTopBorder )
	{		
		NSDivideRect(backgroundRect, &borderRect, &backgroundRect, 1.0, NSMaxYEdge);
		
		if ( NSIntersectsRect(aRect, borderRect) )
		{			
			[NSBezierPath fillRect:borderRect];
		}
	}
	
	if ( borderMask & FKBottomBorder )
	{
		NSDivideRect(backgroundRect, &borderRect, &backgroundRect, 1.0, NSMinYEdge);
		
		if ( NSIntersectsRect(aRect, borderRect) )
		{
			[NSBezierPath fillRect:borderRect];
		}
	}
	
	// Fond
	
	if ( nil != backgroundColor )
	{
		[backgroundColor set];
		
		if ( NSIntersectsRect(aRect, backgroundRect) )
		{
			[NSBezierPath fillRect:backgroundRect];
		}
	}
	
	[[NSColor greenColor] set];
	
	//NSFrameRect([self bounds]);

	[NSGraphicsContext restoreGraphicsState];
}

@end
