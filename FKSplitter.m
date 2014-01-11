//
//  FKSplitter.m
//  FK
//
//  Created by Eric on 11/09/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import "FKSplitter.h"


@interface FKSplitter (Private)

- (void)drawHandle;
- (void)drawArrow;

@end

@implementation FKSplitter

+ (FKSplitter *)splitter
{
	return [[[FKSplitter alloc] initWithFrame:NSZeroRect] autorelease];
}

+ (float)splitterHeight {return 18.0;}

+ (NSImage *)standardSpacerImage
{
	return [NSImage imageNamed:@"SplitterSpacer" forClass:[FKSplitter class]];
}

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if ( self )
	{
		[self setSpacerImage:[NSImage imageNamed:@"SplitterSpacer" forClass:[self class]]];
		[self setHandleImage:[NSImage imageNamed:@"SplitterHandle" forClass:[self class]]];
		[self setSplitView:nil];
		[self setTileSpacerImage:NO];
	}
	
	return self;
}

- (void)dealloc
{
	[self setSpacerImage:nil];
	[self setHandleImage:nil];
	[self setSplitView:nil];	
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (float)height {return [spacerImage size].height;}

- (NSRect)handleRect
{
	NSRect handleRect = NSZeroRect;
	
	if ( handlePosition != FKSplitterHandlePositionNone )
	{
		handleRect = [self bounds];
		
		if ( handlePosition == FKSplitterHandlePositionRight )
		{
			handleRect.origin.x = handleRect.size.width - [handleImage size].width;
		}
		
		handleRect.size.width = [handleImage size].width;
	}
	
	return handleRect;
}

- (NSSize)arrowSize {return NSMakeSize(9, 8);}
- (NSSplitView *)splitView {return splitView;}
- (FKSplitterHandlePosition)handlePosition {return handlePosition;}

#pragma mark -
#pragma mark SETTERS

- (void)setSpacerImage:(NSImage *)anImage
{
	if ( anImage != spacerImage )
	{
		[spacerImage release];
		spacerImage = [anImage retain];
	}
}

- (void)setHandleImage:(NSImage *)anImage
{
	if ( anImage != handleImage )
	{
		[handleImage release];
		handleImage = [anImage retain];
	}
}

- (void)setTitle:(NSString *)aString
{
	if ( aString != title )
	{
		[title release];
		title = [aString retain];
	}
}

- (void)setSplitView:(NSSplitView *)aView
{
	if ( aView != splitView )
	{
		splitView = aView;
	}
}

- (void)setSplitViewDivider:(int)anInt {splitViewDivider = anInt;}
- (void)setTarget:(id)anObject {target = anObject;}
- (void)setAction:(SEL)aSelector {action = aSelector;}
- (void)setDoubleAction:(SEL)aSelector {doubleAction = aSelector;}
- (void)setHandleAction:(SEL)aSelector {handleAction = aSelector;}
- (void)setDoubleHandleAction:(SEL)aSelector {doubleHandleAction = aSelector;}
- (void)setSplitsVertically:(BOOL)flag {splitsVertically = flag;}
- (void)setHandlePosition:(FKSplitterHandlePosition)aPosition {handlePosition = aPosition;}
- (void)setTileSpacerImage:(BOOL)aBool {tileSpacerImage = aBool;}

#pragma mark -
#pragma mark ACTIONS

- (void)performActionOnTarget
{
	if ( [target respondsToSelector:action] )
	{
		state = ( state == NSOnState ? NSOffState : NSOnState );
	
		[target performSelector:action withObject:self];
	
		[self setNeedsDisplay:YES];
	}
}

- (void)performDoubleActionOnTarget
{
	if ( [target respondsToSelector:doubleAction] )
	{
		state = ( state == NSOnState ? NSOffState : NSOnState );
	
		[target performSelector:doubleAction withObject:self];
	
		[self setNeedsDisplay:YES];
	}
}

- (void)performHandleActionOnTarget
{
	if ( [target respondsToSelector:handleAction] )
	{
		state = ( state == NSOnState ? NSOffState : NSOnState );
		
		[target performSelector:handleAction withObject:self];
		
		[self setNeedsDisplay:YES];
	}
}

#pragma mark -
#pragma mark MISC

- (void)resetCursorRects
{
	NSRect cursorRect = [self handleRect];
	
	if ( splitView )
	{
		[self addCursorRect:cursorRect cursor:[NSCursor resizeLeftRightCursor]];
	}
}

- (void)mouseUp:(NSEvent *)theEvent
{
	if ( doubleAction )
	{
		if ( [theEvent clickCount] > 1 )
		{
			NSLog (@"doubleclick");
		
			[self performDoubleActionOnTarget];		
		}
	}
	else if ( action )
	{
		NSLog (@"singleclick");
		
		[self performActionOnTarget];			
	}
}

- (void)mouseDown:(NSEvent *)theEvent
{
	NSPoint mousePoint = NSZeroPoint;
	NSRect handleRect = [self handleRect];	
	
	// Le clic a t'il eu lieu sur la poignee ?
	
	mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];	
	
	if ( NSMouseInRect(mousePoint, handleRect, [self isFlipped]) )
	{
		if ( !splitsVertically )
		{			
			NSPoint mousePoint = NSZeroPoint;
			NSRect handleRect = [self handleRect];
				
			// ...
				
			mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
				
			if ( NSMouseInRect(mousePoint, handleRect, [self isFlipped]) )
			{
				arrowIsHighlighted = YES;
					
				[self setNeedsDisplay:YES];
					
				// ...
					
				BOOL mouseIsUp = NO;
				BOOL mouseDragged = NO;
				
				NSEvent * nextEvent = nil;
					
				while ( !mouseIsUp )
				{
					nextEvent = [NSApp nextEventMatchingMask:(NSLeftMouseUpMask|NSLeftMouseDraggedMask) untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES];
						
					if ( nextEvent )
					{
						mouseIsUp = ( [nextEvent type] == NSLeftMouseUp );
						mouseDragged = ( [nextEvent type] == NSLeftMouseDragged );	
							
						mousePoint = [self convertPoint:[nextEvent locationInWindow] fromView:nil];
							
						if ( mouseDragged )
						{
							arrowIsHighlighted = NSMouseInRect(mousePoint, [self handleRect], [self isFlipped]);
								
							[self setNeedsDisplay:YES];
						}
					}
				}
					
				// mouseIsUp
				
				if ( NSMouseInRect(mousePoint, handleRect, [self isFlipped]) )
				{
					[self performHandleActionOnTarget];
				}
					
				arrowIsHighlighted = NO;
					
				[self setNeedsDisplay:YES];
			}
		}
		else
		{
			[splitView mouseDown:theEvent onDivider:splitViewDivider];
		}
	}
}

#pragma mark -
#pragma mark DRAWING

- (void)drawRect:(NSRect)aRect
{
	NSRect bounds = [self bounds];	
	NSRect backgroundRect = NSZeroRect;
	NSRect bottomLineRect = NSZeroRect;
	
	NSDivideRect(bounds, &bottomLineRect, &backgroundRect, 1.0, NSMinYEdge);
	
	NSBezierPath * path = nil;
	
	// Fond de la cellule
	
	path = [NSBezierPath bezierPathWithRect:backgroundRect];
	
	// ****
	// Fond
	// ****
	
	if ( !tileSpacerImage )
	{
		[path linearGradientFillWithStartColor:[NSColor colorWithDeviceRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1.0]
									  endColor:[NSColor colorWithDeviceRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0]];
	//	[path linearGradientFillWithStartColor:[NSColor colorWithDeviceRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0]
	//								  endColor:[NSColor colorWithDeviceRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0]];
	}
	else
	{
		// Mosaique !!!
			
		NSSize imageSize = [spacerImage size];
		
		NSRect srcRect = NSZeroRect;
		NSRect destRect = NSZeroRect;
		
		while ( destRect.origin.x < bounds.size.width )
		{
			srcRect.size.width = MIN(imageSize.width, (bounds.size.width - destRect.origin.x));
			
			destRect.size.width = srcRect.size.width;
			
			[spacerImage drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];
			
			destRect.origin.x += destRect.size.width;
		}
	}

	// ***************
	// Trait inferieur
	// ***************
	
	path = [NSBezierPath bezierPathWithRect:bottomLineRect];
	
	[[NSColor colorWithCalibratedRed:64.0/255.0 green:64.0/255.0 blue:64.0/255.0 alpha:1.0] set];
	
	[path fill];
	
	// *****
	// Titre
	// *****
	
	NSRect textRect = bounds;
	
	NSFont * font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
	
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];	
	
	NSAttributedString * titleAttributedString = [[[NSAttributedString alloc] initWithString:title attributes:attributes] autorelease];
	
	// On centre le texte verticalement et horizontalement
	
	textRect.size = [titleAttributedString size];	
	textRect.origin.x = ([self bounds].size.width - textRect.size.width) / 2;
	textRect.origin.y = ([self bounds].size.height - textRect.size.height) / 2;
	
	[titleAttributedString drawInRect:textRect];
	
	// ...
	
	if ( handlePosition != FKSplitterHandlePositionNone )
	{
		if ( splitsVertically )
		{
			[self drawHandle];
		}
		else
		{
			[self drawArrow];
		}
	}
}

- (void)drawHandle
{
	NSRect srcRect = [self bounds];	
	NSSize imageSize = NSZeroSize;	
	
	// Handle
	
	imageSize = [handleImage size];
	
	srcRect.size = imageSize;
	
	[handleImage drawInRect:[self handleRect] fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];
}

- (void)drawArrow
{
	AMTriangleOrientation orientation = AMTriangleDown;
	
	if ( state == NSOnState )
	{
		orientation = AMTriangleUp;
	}
	
	NSRect handleRect = [self handleRect];
	NSRect arrowRect = handleRect;
	NSSize arrowSize = [self arrowSize];
	
	arrowRect.origin.x += floor((handleRect.size.width - arrowSize.width) / 2);
	arrowRect.origin.y += (handleRect.size.height - arrowSize.height) / 2;
	arrowRect.size = arrowSize;
	
	NSBezierPath * path = [NSBezierPath bezierPathWithTriangleInRect:arrowRect orientation:orientation];
	
	NSShadow * shadow = [[[NSShadow alloc] init] autorelease];
	
	[shadow setShadowColor:[NSColor whiteColor]];
	[shadow setShadowOffset:NSMakeSize(0.0, -1.0)];
	[shadow setShadowBlurRadius:1.0];
	[shadow set];
	
	if ( !arrowIsHighlighted )
	{
		[[NSColor colorWithDeviceRed:59.0/255.0 green:59.0/255.0 blue:59.0/255.0 alpha:1.0] set];
	}
	else
	{
		[[NSColor blackColor] set];
	}
	
	[path fill];
}

@synthesize splitViewDivider;
@synthesize trackingStartPosition;
@synthesize minConstrainedPosition;
@synthesize maxConstrainedPosition;
@synthesize arrowIsHighlighted;
@synthesize state;
@synthesize splitsVertically;
@synthesize target;
@synthesize action;
@synthesize doubleAction;
@synthesize handleAction;
@synthesize doubleHandleAction;
@synthesize tileSpacerImage;
@end
