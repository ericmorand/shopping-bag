//
//  NSView_FKAdditions.m
//  ShoppingBag
//
//  Created by Eric on 15/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "NSView_FKAdditions.h"


@implementation NSView (FKAdditions)

#pragma mark -
#pragma mark SETTERS

- (void)setFrameX:(float)aFloat
{
	NSPoint frameOrigin = [self frame].origin;
	
	frameOrigin.x = aFloat;
	
	[self setFrameOrigin:frameOrigin];
}

- (void)setFrameY:(float)aFloat
{
	NSPoint frameOrigin = [self frame].origin;
	
	frameOrigin.y = aFloat;
	
	[self setFrameOrigin:frameOrigin];
}

- (void)setFrameWidth:(float)aFloat
{
	NSSize frameSize = [self frame].size;
	
	frameSize.width = aFloat;
	
	[self setFrameSize:frameSize];
}

- (void)setFrameHeight:(float)aFloat
{
	NSSize frameSize = [self frame].size;
	
	frameSize.height = aFloat;
	
	[self setFrameSize:frameSize];
}

#pragma mark -
#pragma mark SCROLLING

- (void)scrollPoint:(NSPoint)aPoint animate:(BOOL)performAnimation
{
	if ( !performAnimation )
	{
		[self scrollPoint:aPoint];
	}
	else
	{
		[[self enclosingScrollView] display];
		
		const double ANIMATION_DURATION = 0.25;
		
		NSPoint oldOrigin = [self visibleRect].origin;
		NSPoint newOrigin = aPoint;
		float actualDelta = newOrigin.y - oldOrigin.y;
		
		if (performAnimation)
		{
			NSDate *startTime = [NSDate date];
			double secondsPassed = 0;
			while (secondsPassed < ANIMATION_DURATION)
			{
				if (secondsPassed > 0)
				{
					[self scrollPoint:
						NSMakePoint(
									newOrigin.x, secondsPassed / ANIMATION_DURATION * actualDelta + 
									oldOrigin.y)];
				}
								
				if ( actualDelta != 0.0 )
				{
					[[[self enclosingScrollView] verticalScroller] display];
				}
				
				secondsPassed = -[startTime timeIntervalSinceNow];
			}
		}
		
		[self scrollPoint:aPoint];
	}
}

- (void)centerInScrollView:(NSScrollView *)scrollView
{	
	//NSLog (@"NSView_FKAdditions - centerInScrollView");
	
	NSView * selfView = [self actualLayoutView];
	
	//NSLog (@"selfView = %@", selfView);
	
	NSClipView * clipView = [scrollView contentView];
	NSView * documentView = [scrollView documentView];
	
	NSRect selfFrame = [selfView frame];
	NSRect visibleRect = [selfView visibleRect];
	NSRect clipFrame = [clipView frame];
	NSRect documentFrame = [documentView frame];
	
	selfFrame = [documentView convertRect:selfFrame fromView:[selfView superview]];
		
	if ( NSHeight(visibleRect) < NSHeight(selfFrame) )
	{	
		NSPoint pointToScroll = selfFrame.origin;
		
		pointToScroll.x = 0.0;
		pointToScroll.y -= floor((NSHeight(clipFrame) - NSHeight(selfFrame)) / 2.0);
		
		if ( pointToScroll.y < 0.0 )
		{
			pointToScroll.y = 0.0;
		}
		else if ( (pointToScroll.y + NSHeight(clipFrame)) > NSHeight(documentFrame) )
		{
			pointToScroll.y = NSHeight([documentView frame]) - NSHeight(clipFrame);		
		}
		else if ( pointToScroll.y > NSMinY(selfFrame) )
		{
			pointToScroll.y = NSMinY(selfFrame);
		}
		
		[clipView scrollToPoint:pointToScroll];
		
		[scrollView reflectScrolledClipView:clipView];
	}
	
	//NSLog (@" NSView_FKAdditions - FIN centerInScrollView");
}

- (NSView *)actualLayoutView
{
	NSView * superview = [self superview];
	
	if ( [superview isKindOfClass:[NSClipView class]] )
	{
		return [self enclosingScrollView];
	}
	
	return self;
}

@end
