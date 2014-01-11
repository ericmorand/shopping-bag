//
//  FKModuleTheme.m
//  ShoppingBag
//
//  Created by Eric on 26/04/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleTheme.h"
#import "FKModuleThemeBlue.h"
#import "FKModuleThemeBrown.h"
#import "FKModuleThemeGreen.h"
#import "FKModuleThemeOrange.h"
#import "FKModuleThemePurple.h"
#import "FKModuleThemeRed.h"
#import "FKModuleThemeYellow.h"


@implementation FKModuleTheme

static FKModuleTheme * currentTheme = nil;

+ (FKModuleTheme *)currentTheme
{	
	if ( nil == currentTheme )
	{
		[FKModuleTheme setCurrentTheme:[FKModuleTheme blueTheme]];

		//[FKModuleTheme setCurrentTheme:[FKModuleTheme purpleTheme]];

		//[FKModuleTheme setCurrentTheme:[FKModuleTheme greenTheme]];

		//[FKModuleTheme setCurrentTheme:[FKModuleTheme redTheme]];
		
		//[FKModuleTheme setCurrentTheme:[FKModuleTheme orangeTheme]];

		//[FKModuleTheme setCurrentTheme:[FKModuleTheme brownTheme]];

		//[FKModuleTheme setCurrentTheme:[FKModuleTheme yellowTheme]];	
	}
	
	return currentTheme;
}

+ (void)setCurrentTheme:(FKModuleTheme *)aTheme
{
	if ( aTheme != currentTheme )
	{
		[currentTheme release];
		currentTheme = [aTheme retain];
	}
}

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		NSShadow * aShadow = [[[NSShadow alloc] init] autorelease];
		
		[aShadow setShadowOffset:NSMakeSize(2.0, -2.0)];
		[aShadow setShadowBlurRadius:0.0];
		[aShadow setShadowColor:[[NSColor whiteColor] colorWithAlphaComponent:0.25]];
		
		[self setStandardTextShadow:aShadow];
		
		aShadow = [aShadow copy];
		
		[aShadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.5]];
		
		[self setHighlightTextShadow:aShadow];
		
		[self setHighlightTextColor:[NSColor whiteColor]];
		[self setTextFont:[NSFont boldSystemFontOfSize:11.0]];
	}
	
	return self;
}

- (void)dealloc
{
	[self setTopGradientStartColor:nil];
	[self setTopGradientEndColor:nil];
	[self setBottomGradientStartColor:nil];
	[self setBottomGradientEndColor:nil];
	[self setBorderColor:nil];
	[self setStandardTextColor:nil];
	[self setHighlightTextColor:nil];
	[self setStandardTextShadow:nil];
	[self setHighlightTextShadow:nil];
	[self setTextFont:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

+ (FKModuleTheme *)blueTheme
{
	return [[[FKModuleThemeBlue alloc] init] autorelease];
}

+ (FKModuleTheme *)brownTheme
{
	return [[[FKModuleThemeBrown alloc] init] autorelease];
}

+ (FKModuleTheme *)greenTheme
{
	return [[[FKModuleThemeGreen alloc] init] autorelease];
}

+ (FKModuleTheme *)orangeTheme;
{
	return [[[FKModuleThemeOrange alloc] init] autorelease];
}


+ (FKModuleTheme *)purpleTheme
{
	return [[[FKModuleThemePurple alloc] init] autorelease];
}

+ (FKModuleTheme *)redTheme {return [[[FKModuleThemeRed alloc] init] autorelease];}
+ (FKModuleTheme *)yellowTheme {return [[[FKModuleThemeYellow alloc] init] autorelease];}

- (NSColor *)backgroundStandardTextColor {return [[self standardTextColor] colorWithAlphaComponent:0.75];}
- (NSColor *)backgroundHighlightTextColor {return [[self highlightTextColor] colorWithAlphaComponent:0.75];}

- (NSColor *)borderColor {return borderColor;}
- (NSColor *)standardTextColor {return standardTextColor;}
- (NSColor *)highlightTextColor {return highlightTextColor;}
- (NSColor *)backgroundTextColor {return backgroundTextColor;}
- (NSShadow *)standardTextShadow {return standardTextShadow;}
- (NSShadow *)highlightTextShadow {return highlightTextShadow;}
- (NSFont *)textFont {return textFont;}

#pragma mark -
#pragma mark SETTERS

- (void)setTopGradientStartColor:(NSColor *)aColor
{
	if ( aColor != topGradientStartColor )
	{
		[topGradientStartColor release];
		topGradientStartColor = [aColor retain];
	}
}

- (void)setTopGradientEndColor:(NSColor *)aColor
{
	if ( aColor != topGradientEndColor )
	{
		[topGradientEndColor release];
		topGradientEndColor = [aColor retain];
	}
}

- (void)setBottomGradientStartColor:(NSColor *)aColor
{
	if ( aColor != bottomGradientStartColor )
	{
		[bottomGradientStartColor release];
		bottomGradientStartColor = [aColor retain];
	}
}

- (void)setBottomGradientEndColor:(NSColor *)aColor
{
	if ( aColor != bottomGradientEndColor )
	{
		[bottomGradientEndColor release];
		bottomGradientEndColor = [aColor retain];
	}
}

- (void)setBorderColor:(NSColor *)aColor
{
	if ( aColor != borderColor )
	{
		[borderColor release];
		borderColor = [aColor retain];
	}
}

- (void)setStandardTextColor:(NSColor *)aColor
{
	if ( aColor != standardTextColor )
	{
		[standardTextColor release];
		standardTextColor = [aColor retain];
	}
}

- (void)setHighlightTextColor:(NSColor *)aColor
{
	if ( aColor != highlightTextColor )
	{
		[highlightTextColor release];
		highlightTextColor = [aColor retain];
	}
}

- (void)setBackgroundTextColor:(NSColor *)aColor
{
	if ( aColor != backgroundTextColor )
	{
		[backgroundTextColor release];
		backgroundTextColor = [aColor retain];
	}
}

- (void)setStandardTextShadow:(NSShadow *)aShadow
{
	if ( aShadow != standardTextShadow )
	{
		[standardTextShadow release];
		standardTextShadow = [aShadow retain];
	}
}

- (void)setHighlightTextShadow:(NSShadow *)aShadow
{
	if ( aShadow != highlightTextShadow )
	{
		[highlightTextShadow release];
		highlightTextShadow = [aShadow retain];
	}
}

- (void)setTextFont:(NSFont *)aFont
{
	if ( aFont != textFont )
	{
		[textFont release];
		textFont = [aFont retain];
	}
}

#pragma mark -

- (void)drawRectGradientInRect:(NSRect)aRect usingBorderMask:(unsigned int)borderMask
{
	[NSGraphicsContext saveGraphicsState];
	
	NSBezierPath * path = nil;
	
	NSRect topRect = NSZeroRect;
	NSRect bottomRect = NSZeroRect;
	
	NSRect topBorderRect = NSZeroRect;
	NSRect bottomBorderRect = NSZeroRect;
	NSRect leftBorderRect = NSZeroRect;
	NSRect rightBorderRect = NSZeroRect;
	
	if ( borderMask & FKTopBorder )
	{
		NSDivideRect(aRect, &topBorderRect, &aRect, 1.0, NSMinYEdge);
	}
	
	if ( borderMask & FKRightBorder )
	{
		NSDivideRect(aRect, &rightBorderRect, &aRect, 1.0, NSMaxXEdge);
	}
	
	if ( borderMask & FKBottomBorder )
	{
		NSDivideRect(aRect, &bottomBorderRect, &aRect, 1.0, NSMaxYEdge);
	}
	
	if ( borderMask & FKLeftBorder )
	{
		NSDivideRect(aRect, &leftBorderRect, &aRect, 1.0, NSMinXEdge);
	}
	
	// Fond
	
	NSDivideRect(aRect, &topRect, &bottomRect, floor(aRect.size.height / 2.0), NSMinYEdge);
	
	path = [NSBezierPath bezierPathWithRect:topRect];
	
	[path linearGradientFillWithStartColor:topGradientStartColor endColor:topGradientEndColor];
	
	path = [NSBezierPath bezierPathWithRect:bottomRect];
	
	[path linearGradientFillWithStartColor:bottomGradientStartColor endColor:bottomGradientEndColor];
	
	// Bordures
	
	[borderColor set];
	
	NSRectFill(topBorderRect);
	NSRectFill(rightBorderRect);
	NSRectFill(bottomBorderRect);
	NSRectFill(leftBorderRect);
	
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawGradientRoundedRect:(NSRect)aRect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask inView:(NSView *)aView
{
	[NSGraphicsContext saveGraphicsState];
	
	NSBezierPath * fillPath = nil;
	NSBezierPath * strokePath = nil;
	
	NSColor * startColor = nil;
	NSColor * endColor = nil;
	
	NSRect fillRect = aRect;
	NSRect strokeRect = NSZeroRect;
	NSRect topRect = NSZeroRect;
	NSRect bottomRect = NSZeroRect;
	
	BOOL isFlipped = [aView isFlipped];
	
	// ...
	
	strokeRect = NSInsetRect(aRect, 0.5, 0.5);
	fillRect = NSInsetRect(strokeRect, 0.5, 0.5);
		
	strokePath = [NSBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:radius cornerMask:cornerMask];
		
	[strokePath setLineWidth:1.0];
		
	if ( isFlipped )
	{
		startColor = [[NSColor blackColor] colorWithAlphaComponent:0.70];
		endColor = [[NSColor whiteColor] colorWithAlphaComponent:0.35];
	}
	
	NSDivideRect(fillRect, &topRect, &bottomRect, floor(NSHeight(fillRect) / 2.0), NSMinYEdge);
	
	// ...
	
	fillPath = [NSBezierPath bezierPathWithRoundedRect:topRect cornerRadius:radius cornerMask:cornerMask];
	
	[fillPath linearGradientFillWithStartColor:topGradientStartColor endColor:topGradientEndColor];
	
	// ...
	
	fillPath = [NSBezierPath bezierPathWithRoundedRect:bottomRect cornerRadius:(NSHeight(fillRect) / 2.0) cornerMask:cornerMask];
	
	[fillPath linearGradientFillWithStartColor:bottomGradientStartColor endColor:bottomGradientEndColor];
	
	// Stroke
	
	[strokePath linearGradientStrokeWithStartColor:startColor endColor:endColor];
	
	[NSGraphicsContext restoreGraphicsState];	
}

- (void)drawGradientPlateInRect:(NSRect)aRect inView:(NSView *)aView bezeled:(BOOL)isBezeled hollow:(BOOL)isHollow
{
	[NSGraphicsContext saveGraphicsState];
	
	NSBezierPath * fillPath = nil;
	NSBezierPath * strokePath = nil;
	
	NSColor * startColor = nil;
	NSColor * endColor = nil;
	
	NSRect fillRect = aRect;
	NSRect strokeRect = NSZeroRect;
	NSRect topRect = NSZeroRect;
	NSRect bottomRect = NSZeroRect;
		
	int cornerMask = 0;
	
	BOOL isFlipped = [aView isFlipped];
	
	// ...
	
	if ( isBezeled )
	{
		strokeRect = NSInsetRect(aRect, 0.5, 0.5);
		fillRect = NSInsetRect(strokeRect, 0.5, 0.5);
				
		strokePath = [NSBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:(NSHeight(strokeRect) / 2.0) cornerMask:FKEveryCorner];
		
		[strokePath setLineWidth:1.0];
		
		if ( isHollow )
		{
			startColor = [[NSColor blackColor] colorWithAlphaComponent:0.70];
			endColor = [[NSColor whiteColor] colorWithAlphaComponent:0.35];
		}
		else
		{
			startColor = [[NSColor whiteColor] colorWithAlphaComponent:0.35];
			endColor = [[NSColor blackColor] colorWithAlphaComponent:0.70];
		}
	}

	NSDivideRect(fillRect, &topRect, &bottomRect, floor(NSHeight(fillRect) / 2.0), NSMinYEdge);
	
	// ...
	
	cornerMask = ( isFlipped ? (FKBottomLeftCorner | FKBottomRightCorner) : (FKTopLeftCorner | FKTopRightCorner) );
	
	fillPath = [NSBezierPath bezierPathWithRoundedRect:topRect cornerRadius:(NSHeight(fillRect) / 2.0) cornerMask:cornerMask];
	
	[fillPath linearGradientFillWithStartColor:topGradientStartColor endColor:topGradientEndColor];
	
	// ...
	
	cornerMask = ( isFlipped ? (FKTopLeftCorner | FKTopRightCorner) : (FKBottomLeftCorner | FKBottomRightCorner) );	
	
	fillPath = [NSBezierPath bezierPathWithRoundedRect:bottomRect cornerRadius:(NSHeight(fillRect) / 2.0) cornerMask:cornerMask];
	
	[fillPath linearGradientFillWithStartColor:bottomGradientStartColor endColor:bottomGradientEndColor];
	
	// Stroke
	
	if ( isBezeled )
	{
		[strokePath linearGradientStrokeWithStartColor:startColor endColor:endColor];
	}
	
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawBezeledPlateInRect:(NSRect)aRect fillColor:(NSColor *)fillColor hollow:(BOOL)isHollow
{
	NSRect strokeRect = NSInsetRect(aRect, 0.5, 0.5);
	NSRect fillRect = NSInsetRect(strokeRect, 0.5, 0.5);
	
	NSBezierPath * fillPath = [NSBezierPath bezierPathWithPlateInRect:fillRect];
	NSBezierPath * strokePath = [NSBezierPath bezierPathWithPlateInRect:strokeRect];
	
	[strokePath setLineWidth:1.0];
	
	[NSGraphicsContext saveGraphicsState];
	
	NSColor * startColor = nil;
	NSColor * endColor = nil;
	
	if ( isHollow )
	{
		startColor = [[NSColor blackColor] colorWithAlphaComponent:0.70];
		endColor = [[NSColor whiteColor] colorWithAlphaComponent:0.35];
	}
	else
	{
		startColor = [[NSColor whiteColor] colorWithAlphaComponent:0.35];
		endColor = [[NSColor blackColor] colorWithAlphaComponent:0.70];
	}
	
	[fillColor set];
	[fillPath fill];
	
	[strokePath linearGradientStrokeWithStartColor:startColor endColor:endColor];
				
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawRoundedRect:(NSRect)aRect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask fillColor:(NSColor *)fillColor
{
	NSRect strokeRect = NSInsetRect(aRect, 0.5, 0.5);
	NSRect fillRect = NSInsetRect(strokeRect, 0.5, 0.5);
	
	NSBezierPath * fillPath = [NSBezierPath bezierPathWithRoundedRect:fillRect cornerRadius:radius cornerMask:cornerMask];
	NSBezierPath * strokePath = [NSBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:radius cornerMask:cornerMask];
	
	[strokePath setLineWidth:1.0];
	
	[NSGraphicsContext saveGraphicsState];
	
	[fillColor set];
	[fillPath fill];
	
	[[[self borderColor] colorWithAlphaComponent:0.50] set];
	[strokePath stroke];
				
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawBezeledRoundedRect:(NSRect)aRect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask fillColor:(NSColor *)fillColor hollow:(BOOL)isHollow
{
	NSRect strokeRect = NSInsetRect(aRect, 0.5, 0.5);
	NSRect fillRect = NSInsetRect(strokeRect, 0.5, 0.5);
	
	NSBezierPath * fillPath = [NSBezierPath bezierPathWithRoundedRect:fillRect cornerRadius:radius cornerMask:cornerMask];
	NSBezierPath * strokePath = [NSBezierPath bezierPathWithRoundedRect:strokeRect cornerRadius:radius cornerMask:cornerMask];
	
	[strokePath setLineWidth:1.0];
	
	[NSGraphicsContext saveGraphicsState];
	
	NSColor * startColor = nil;
	NSColor * endColor = nil;
	
	if ( isHollow )
	{
		startColor = [[NSColor blackColor] colorWithAlphaComponent:0.70];
		endColor = [[NSColor whiteColor] colorWithAlphaComponent:0.35];
	}
	else
	{
		startColor = [[NSColor whiteColor] colorWithAlphaComponent:0.35];
		endColor = [[NSColor blackColor] colorWithAlphaComponent:0.70];
	}
	
	[fillColor set];
	[fillPath fill];
	
	[strokePath linearGradientStrokeWithStartColor:startColor endColor:endColor];
				
	[NSGraphicsContext restoreGraphicsState];	
}

@end
