//
//  FKTextFieldCell.m
//  FKKit
//
//  Created by Eric on 15/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKTextFieldCell.h"

@interface FKTextFieldCell (Private)

- (void)commonInit;

@end

@implementation FKTextFieldCell

+ (Class)formatterClass {return nil;}

- (id)initTextCell:(NSString *)aString
{
	self = [super initTextCell:aString];
	
	if ( self )
	{
		[self commonInit];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if ( self )
	{
		[self commonInit];
	}
	
	return self;
}

- (void)commonInit
{
	Class formatterCell = [[self class] formatterClass];
	
	if ( nil != formatterCell )
	{
		NSNumberFormatter * cellFormatter = [[[formatterCell alloc] init] autorelease];
	
		[self setFormatter:cellFormatter];
	}
}

- (NSRect)drawingRectForBounds:(NSRect)theRect
{	
	NSRect newRect = [super drawingRectForBounds:theRect];
	
	if ( isVerticallyCentered )
	{
		// When the text field is being 
		// edited or selected, we have to turn off the magic because it screws up 
		// the configuration of the field editor.  We sneak around this by 
		// intercepting selectWithFrame and editWithFrame and sneaking a 
		// reduced, centered rect in at the last minute.
	
		if ( isEditingOrSelecting == NO )
		{
			// Get our ideal size for current text
		
			NSSize textSize = [self cellSizeForBounds:theRect];
		
			// Center that in the proposed rect
		
			float heightDelta = newRect.size.height - textSize.height;
		
			if ( heightDelta > 0 )
			{
				newRect.size.height -= heightDelta;
				newRect.origin.y += floor(heightDelta / 2);
			}
		}
	}
	
	return newRect;
}

- (void)selectWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject start:(int)selStart length:(int)selLength
{
	if ( isVerticallyCentered )
	{
		aRect = [self drawingRectForBounds:aRect];
	}
	
	isEditingOrSelecting = YES;	
	
	[super selectWithFrame:aRect inView:controlView editor:textObj delegate:anObject start:selStart length:selLength];
	
	isEditingOrSelecting = NO;
}

- (void)editWithFrame:(NSRect)aRect inView:(NSView *)controlView editor:(NSText *)textObj delegate:(id)anObject event:(NSEvent *)theEvent
{	
	if ( isVerticallyCentered )
	{
		aRect = [self drawingRectForBounds:aRect];
	}
	
	isEditingOrSelecting = YES;
	
	[super editWithFrame:aRect inView:controlView editor:textObj delegate:anObject event:theEvent];
	
	isEditingOrSelecting = NO;
}

@synthesize isVerticallyCentered;
@synthesize isEditingOrSelecting;
@end
