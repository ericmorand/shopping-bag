//
//  FKToolbarItemView.m
//  FKKit
//
//  Created by Eric on 15/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKToolbarItemView.h"

@interface FKToolbarItemView (Private)

@end

@implementation FKToolbarItemView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
	if ( self )
	{
	}
	
    return self;
}

#pragma mark -
#pragma mark SETTERS

#pragma mark -
#pragma mark DRAWING

- (void)drawRect:(NSRect)rect
{
	NSView * aView = nil;
	NSRect aViewFrame = NSZeroRect;
	NSRect separatorRect = NSZeroRect;	
	
	NSArray * viewsArray = [self subviews];
	
	unsigned i = 0;
	
	separatorRect.size.width = 1.0;	
	separatorRect.size.height = NSHeight(rect);	
	
	[NSGraphicsContext saveGraphicsState];
	
	[[NSColor lightBorderColor] set];	
	
	for ( ; i < ([viewsArray count] - 1); i++)
	{
		aView = [viewsArray objectAtIndex:i];
		aViewFrame = [aView frame]; 
		
		separatorRect.origin.x = NSMaxX(aViewFrame);
				
		[NSBezierPath fillRect:separatorRect];
	}
	
	[NSGraphicsContext restoreGraphicsState];
}

@end
