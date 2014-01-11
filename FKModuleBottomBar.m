//
//  FKModuleBottomBar.m
//  FKKit
//
//  Created by alt on 29/09/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

// Hauteur ideale = 20.0

#import "FKModuleBottomBar.h"

@interface FKModuleBottomBar (Private)

- (void)setFillImage:(NSImage *)anImage;

@end

@implementation FKModuleBottomBar

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];

    if ( self )
	{
		[self setFillImage:[NSImage imageNamed:@"FKModuleBottomBarFiller" forClass:[self class]]];
	}
	
    return self;
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isFlipped {return YES;}

#pragma mark -
#pragma mark SETTERS

- (void)setFillImage:(NSImage *)anImage
{
	if ( anImage != fillImage )
	{
		[fillImage release];
		fillImage = [anImage copy];
	}
}

#pragma mark -
#pragma mark DRAWING

- (void)drawRect:(NSRect)rect
{
	NSRect bounds = [self bounds];
	
	NSRect topBorderRect= NSZeroRect;
	NSRect backgroundRect = NSZeroRect;
	NSRect topGradientRect = NSZeroRect;
	NSRect bottomGradientRect = NSZeroRect;
		
	NSBezierPath * path = nil;
	
	NSDivideRect(bounds, &topBorderRect, &backgroundRect, 1.0, NSMinYEdge);
	NSDivideRect(backgroundRect, &topGradientRect, &bottomGradientRect, floor(NSHeight(backgroundRect) / 2.0), NSMinYEdge);
	
	// Trait superieur
	
	[[NSColor lightBorderColor] set];
	//[[NSColor colorWithDeviceRed:197.0/255.0 green:197.0/255.0 blue:197.0/255.0 alpha:1.0] set];	
	
	[NSBezierPath fillRect:topBorderRect];
	
	// Fond
	
	path = [NSBezierPath bezierPathWithRect:topGradientRect];
	
	[[NSColor colorWithDeviceRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] set];
	
	[NSBezierPath fillRect:bottomGradientRect];

	// ...
	
	[[NSColor colorWithDeviceRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0] set];

	[NSBezierPath fillRect:topGradientRect];
	
	[[NSColor colorWithDeviceRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0] set];

	[NSBezierPath fillRect:backgroundRect];
}

@end
