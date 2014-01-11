//
//  FKFlatRoundedButtonCell.m
//  FK
//
//  Created by Eric on 05/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKFlatRoundedButtonCell.h"


@implementation FKFlatRoundedButtonCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[self drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	//NSLog (@"drawInteriorWithFrame : %@", NSStringFromRect(cellFrame));
	
	// ...
	
	NSBezierPath * path = nil;
	
	cellFrame = NSInsetRect(cellFrame, 0.5, 0.5);
	
	path = [NSBezierPath bezierPathWithPlateInRect:cellFrame];

	NSColor * startColor = nil;
	NSColor * endColor = nil;
	
	if ( [controlView isFlipped] )
	{
		if ( [self isHighlighted] )
		{
			startColor = [NSColor colorWithCalibratedRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0];
			endColor = [NSColor colorWithCalibratedRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
		}
		else
		{
			startColor = [NSColor colorWithCalibratedRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0];
			endColor = [NSColor colorWithCalibratedRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0];
		}
	}
	else
	{
		if ( [self isHighlighted] )
		{
			startColor = [NSColor colorWithCalibratedRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0];
			endColor = [NSColor colorWithCalibratedRed:182.0/255.0 green:182.0/255.0 blue:182.0/255.0 alpha:1.0];
		}
		else
		{
			startColor = [NSColor colorWithCalibratedRed:219.0/255.0 green:219.0/255.0 blue:219.0/255.0 alpha:1.0];
			endColor = [NSColor colorWithCalibratedRed:254.0/255.0 green:254.0/255.0 blue:254.0/255.0 alpha:1.0];
		}
	}
	
	[path linearGradientFillWithStartColor:startColor endColor:endColor];
	
	[[NSColor colorWithCalibratedRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3] set];
	
	[path stroke];
	
	if ( [self showsFirstResponder] )
	{
		[NSGraphicsContext saveGraphicsState];
		
		[path setFlatness:5.0];
		NSSetFocusRingStyle(NSFocusRingOnly);
		[path fill];
		
		[NSGraphicsContext restoreGraphicsState];
	}
	
	// *****
	// Image
	// *****
	
	NSRect srcRect = NSZeroRect;
	NSRect destRect = NSZeroRect;
	
	srcRect.size = [[self image] size];
	
	destRect = srcRect;
	
	float fraction = 1.0;
	
	if ( ![self isEnabled] )
	{
		fraction = 0.3;
	}
	
	[[self image] drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
}

@synthesize focusRingDrawn;
@end
