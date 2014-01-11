//
//  SBCustomerView.m
//  ShoppingBag
//
//  Created by Eric on 20/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "CustomerView.h"


@implementation CustomerView

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if ( self )
	{
	}
	
	return self;
}

- (void)dealloc
{	
	[super dealloc];
}

- (void)awakeFromNib
{
	[editButton setHidden:YES];
	[deleteButton setHidden:YES];
	
	if ( nil != salesArrayController )
	{
		[self bind:@"customer" toObject:salesArrayController withKeyPath:@"selection.customer" options:nil];
	}
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)mouseOver {return mouseOver;}

#pragma mark -
#pragma mark SETTERS

- (void)setCustomer:(Customer *)aCustomer
{
	customer = aCustomer;

	[self resetTrackingRect];
}

- (void)setMouseOver:(BOOL)flag {mouseOver = flag;}

#pragma mark -
#pragma mark TRACKING

- (void)resetTrackingRect
{		
	[self removeTrackingRect];
	
	if ( nil != customer )
	{
		NSRect trackingRect = [self bounds];
	
		// Voir ici : http://www.cocoabuilder.com/archive/message/cocoa/2005/9/10/146062
	
		NSPoint mouseLocation = [[self window] mouseLocationOutsideOfEventStream];
		NSRect boundsInWindow = [self convertRect:trackingRect toView:nil];
	
		BOOL mouseInView = NSPointInRect(mouseLocation, boundsInWindow);
	
		trackingRectTag = [self addTrackingRect:trackingRect owner:self userData:nil assumeInside:mouseInView];
	
		if ( mouseInView )
		{
			[self mouseEntered:[NSApp currentEvent]];
		}
		else
		{
			[self mouseExited:[NSApp currentEvent]];
		}
	}
}

- (void)removeTrackingRect
{
	if ( trackingRectTag )
	{
		[self removeTrackingRect:trackingRectTag];
		
		[self mouseExited:[NSApp currentEvent]];
	}
}

- (void)superviewFrameDidChange:(NSNotification *)aNotification
{
	[self resetTrackingRect];
}

- (void)removeFromSuperview
{
	[self removeTrackingRect];
	[super removeFromSuperview];
}

- (void)removeFromSuperviewWithoutNeedingDisplay
{
	[self removeTrackingRect];
	[super removeFromSuperviewWithoutNeedingDisplay];
}

- (void)viewDidMoveToWindow
{
	if ( [self window] )
	{
		[self resetTrackingRect];
	}
	else
	{
		[self removeTrackingRect:trackingRectTag];
	}
}

- (void)viewWillMoveToSuperview:(NSView *)newSuperview
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewFrameDidChangeNotification object:[self superview]];
}

- (void)viewDidMoveToSuperview
{
	NSView * superview = [self superview];
	
	if ( superview )
	{
		[self resetTrackingRect];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(superviewFrameDidChange:) name:NSViewFrameDidChangeNotification object:superview];
	}
	else
	{
		[self removeTrackingRect:trackingRectTag];
	}
}

#pragma mark -
#pragma mark EVENTS

- (void)mouseEntered:(NSEvent *)event
{	
	if ( ![self mouseOver] )
	{
		[self setMouseOver:YES];
		[self setNeedsDisplay:YES];
	}
	
	[editButton setHidden:NO];
	[deleteButton setHidden:NO];
}

- (void)mouseExited:(NSEvent *)event
{	
	if ( [self mouseOver] )
	{
		[self setMouseOver:NO];
		[self setNeedsDisplay:YES];
	}
	
	[editButton setHidden:YES];
	[deleteButton setHidden:YES];
}

#pragma mark -
#pragma mark DRAWING

- (void)drawRect:(NSRect)rect
{
	NSRect bounds = [self bounds];
	
    if ( [self mouseOver] )
	{
		NSBezierPath * bezierPath = [NSBezierPath bezierPathWithRoundedRect:bounds cornerRadius:10.0 cornerMask:FKEveryCorner];
		
		[[NSColor colorWithDeviceRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0] set];
		
		[bezierPath fill];

		// ...
		
		NSRect strokeRect = NSInsetRect(bounds, 0.5, 0.5);
		
		bezierPath = [NSBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:10.0 cornerMask:FKEveryCorner];
		
		[[NSColor lightBorderColor] set];

		[bezierPath stroke];		
	}
}

@synthesize customer;
@synthesize trackingRectTag;
@synthesize salesArrayController;
@synthesize editButton;
@synthesize deleteButton;
@end
