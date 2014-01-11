//
//  FKTableCornerView.m
//  FKKit
//
//  Created by Eric on 19/03/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKTableCornerView.h"


@implementation FKTableCornerView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
	if ( self )
	{
    }
	
    return self;
}

- (void)drawRect:(NSRect)rect
{
	NSBezierPath * path = [NSBezierPath bezierPath];
	
	NSRect viewBounds = [self bounds];
	NSRect backgroundRect = NSZeroRect;
	NSRect bottomLineRect = NSZeroRect;
	
	NSDivideRect(viewBounds, &bottomLineRect, &backgroundRect, 1.0, NSMinYEdge);
	
	path = [NSBezierPath bezierPathWithRect:backgroundRect];
	
	[NSGraphicsContext saveGraphicsState];
	
	// Fond
	
	[[NSColor whiteColor] set];

	[path fill];
	
	// Ligne inferieure
	
	path = [NSBezierPath bezierPathWithRect:bottomLineRect];
	
	[[NSColor colorWithDeviceRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0] set];
	
	[path fill];	
	
	// Trait separateur cote gauche
	
	NSRect separatorRect = NSZeroRect;
	
	NSDivideRect(backgroundRect, &separatorRect, &backgroundRect, 1.0, NSMinXEdge);
	
	path = [NSBezierPath bezierPathWithRect:separatorRect];
		
	[path fill];
	
	[NSGraphicsContext restoreGraphicsState];
}


@end
