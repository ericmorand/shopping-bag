//
//  FKPlusMinusView.m
//  ShoppingBag
//
//  Created by Eric on 03/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKPlusMinusView.h"

@interface FKPlusMinusView (Private)

- (void)commonSetup;
- (void)setPlusButton:(FKPlusMinusViewButton *)aButton;
- (void)setMinusButton:(FKPlusMinusViewButton *)aButton;

@end

@implementation FKPlusMinusView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
	
    if ( self )
	{
		[self commonSetup];
	}
	
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
	
    if ( self )
	{
		[self commonSetup];
	}
	
    return self;
}

- (void)commonSetup
{
	NSRect selfBounds = [self bounds];
	NSRect plusButtonFrame = NSZeroRect;
	NSRect minusButtonFrame = NSZeroRect;
	
	NSDivideRect(selfBounds, &plusButtonFrame, &selfBounds, floor((NSWidth(selfBounds) - 1.0) / 2.0), NSMinXEdge);
	NSDivideRect(selfBounds, &selfBounds, &minusButtonFrame, 1.0, NSMinXEdge);
	
	[self setPlusButton:[[[FKPlusMinusViewButton alloc] initWithFrame:plusButtonFrame] autorelease]];	
		
	[plusButton setImage:[NSImage imageNamed:@"Plus" forClass:[FKPlusMinusView class]]];
	
	[self setMinusButton:[[[FKPlusMinusViewButton alloc] initWithFrame:minusButtonFrame] autorelease]];

	[minusButton setImage:[NSImage imageNamed:@"Minus" forClass:[FKPlusMinusView class]]];
	[[minusButton cell] setIsRightCornered:YES];
}

- (void)dealloc
{
	[self setPlusButton:nil];
	[self setMinusButton:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark MISC

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
	NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter removeObserver:self name:NSWindowDidResignKeyNotification object:nil];
	[defaultCenter addObserver:self selector:@selector(windowDidChangeKeyNotification:) name:NSWindowDidResignKeyNotification object:newWindow];
	
	[defaultCenter removeObserver:self name:NSWindowDidBecomeKeyNotification object:nil];
	[defaultCenter addObserver:self selector:@selector(windowDidChangeKeyNotification:) name:NSWindowDidBecomeKeyNotification object:newWindow];
}

- (void)windowDidChangeKeyNotification:(NSNotification *)notification
{
	[self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark GETTERS

- (FKPlusMinusViewButton *)plusButton {return plusButton;}
- (FKPlusMinusViewButton *)minusButton {return minusButton;}

- (NSRect)separatorRect
{
	NSRect selfBounds = [self bounds];
	NSRect separatorRect = selfBounds;
	
	separatorRect.size.width = 1.0;
	separatorRect.origin.x += floor((NSWidth(selfBounds) - NSWidth(separatorRect)) / 2.0);
	
	return separatorRect;
}

#pragma mark -
#pragma mark SETTERS

- (void)setPlusButton:(FKPlusMinusViewButton *)aButton
{
	if ( aButton != plusButton )
	{
		[plusButton removeFromSuperviewWithoutNeedingDisplay];
		
		[plusButton release];
		plusButton = [aButton retain];
		
		[self addSubview:plusButton];
	}
}

- (void)setMinusButton:(FKPlusMinusViewButton *)aButton
{
	if ( aButton != minusButton )
	{
		[minusButton removeFromSuperviewWithoutNeedingDisplay];
		
		[minusButton release];
		minusButton = [aButton retain];
		
		[self addSubview:minusButton];
	}
}

- (void)setTarget:(id)anObject
{
	[plusButton setTarget:anObject];
	[minusButton setTarget:anObject];
}

- (void)setPlusAction:(SEL)aSelector
{
	[plusButton setAction:aSelector];
}

- (void)setMinusAction:(SEL)aSelector
{
	[minusButton setAction:aSelector];
}

#pragma mark -
#pragma mark LAYOUT & DRAWING

- (void)drawRect:(NSRect)rect
{
	[[NSColor colorWithDeviceRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] set];
	
    NSFrameRect([self separatorRect]);
}

@end

#pragma mark -
#pragma mark FKPlusMinusViewButton

@implementation FKPlusMinusViewButton

+ (Class)cellClass {return [FKPlusMinusViewButtonCell class];}

@end

#pragma mark -
#pragma mark FKPlusMinusViewButtonCell

@interface FKPlusMinusViewButtonCell (Private)

- (NSBezierPath *)backgroundPath;
- (NSBezierPath *)borderPath;

@end

@implementation FKPlusMinusViewButtonCell

- (void)dealloc
{
	[self setBackgroundPath:nil];
	[self setBorderPath:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isOpaque {return NO;}

- (NSBezierPath *)backgroundPath
{
	if ( nil == backgroundPath )
	{
		NSRect cellFrame = [[self controlView] bounds];
		
		NSBezierPath * aPath = [NSBezierPath bezierPath];
	
		[aPath appendBezierPath:[self borderPath]];
		
		NSRect insetFrame = NSInsetRect(cellFrame, 0.5, 0.5);
		NSPoint endPoint = NSZeroPoint;
	
		if ( isRightCornered )
		{
			endPoint.x = NSMinX(insetFrame) - 0.5;
			endPoint.y = NSMinY(insetFrame);
		}
		else
		{
			endPoint.x = NSMaxX(insetFrame) + 0.5;
			endPoint.y = NSMinY(insetFrame);
		}
	
		[aPath lineToPoint:endPoint];
		[aPath closePath];	
		
		[self setBackgroundPath:aPath];
	}
	
	return backgroundPath;
}

- (NSBezierPath *)borderPath
{
	if ( nil == borderPath )
	{
		NSRect cellFrame = [[self controlView] bounds];
		
		NSBezierPath * aPath = [NSBezierPath bezierPath];
	
		NSRect insetFrame = NSInsetRect(cellFrame, 0.5, 0.5);
	
		float radius = 3.0;
	
		NSPoint startPoint = NSZeroPoint;
		NSPoint point2 = NSZeroPoint;
		NSPoint point3 = NSZeroPoint;
		NSPoint endPoint = NSZeroPoint;
	
		if ( isRightCornered )
		{
			startPoint.x = NSMaxX(insetFrame);
			startPoint.y = NSMinY(insetFrame);
		
			point2.x = startPoint.x - radius;
			point2.y = NSMaxY(insetFrame) - radius;
		
			point3.x = NSMinX(insetFrame) - 0.5;
			point3.y = NSMaxY(insetFrame);
		
			endPoint.x = point3.x;
			endPoint.y = startPoint.y;	
		
			[aPath moveToPoint:startPoint];
			[aPath appendBezierPathWithArcWithCenter:point2 radius:radius startAngle:0.0 endAngle:90.0 clockwise:NO];
			[aPath lineToPoint:point3];
		}
		else
		{
			startPoint.x = NSMinX(insetFrame);
			startPoint.y = NSMinY(insetFrame);
		
			point2.x = startPoint.x + radius;
			point2.y = NSMaxY(insetFrame) - radius;
		
			point3.x = NSMaxX(insetFrame) + 0.5;
			point3.y = NSMaxY(insetFrame);
		
			endPoint.x = point3.x;
			endPoint.y = startPoint.y;	
		
			[aPath moveToPoint:startPoint];
			[aPath appendBezierPathWithArcWithCenter:point2 radius:radius startAngle:180.0 endAngle:90.0 clockwise:YES];
			[aPath lineToPoint:point3];
		}
		
		[self setBorderPath:aPath];
	}
		
	return borderPath;
}

#pragma mark -
#pragma mark SETTERS

- (void)setBackgroundPath:(NSBezierPath *)aPath
{
	if ( aPath != backgroundPath )
	{
		[backgroundPath release];
		backgroundPath = [aPath retain];
	}
}

- (void)setBorderPath:(NSBezierPath *)aPath
{
	if ( aPath != borderPath )
	{
		[borderPath release];
		borderPath = [aPath retain];
	}
}

- (void)setIsRightCornered:(BOOL)flag
{
	isRightCornered = flag;
	
	[self setBackgroundPath:nil];
	[self setBorderPath:nil];
}

#pragma mark -
#pragma mark DRAWING

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	//NSLog (@"FKPlusMinusViewButtonCell - drawWithFrame");
	
	//NSFrameRect(cellFrame);
	
	 // Fond
	
	NSColor * startColor = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
	NSColor * endColor = [NSColor colorWithDeviceRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
	
	[[self backgroundPath] linearGradientFillWithStartColor:startColor endColor:endColor];
	
	// Bordure
	
	[[NSColor colorWithDeviceRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] set];
	
	[[self borderPath] stroke];
		
	// ...
	
	if ( [self isHighlighted] )
	{
		[[[NSColor blackColor] colorWithAlphaComponent:0.25] set];
		
		[[self backgroundPath] fill];
	}
	
	// ...
	
	[self drawInteriorWithFrame:cellFrame inView:controlView];
	
	//NSLog (@" /FKPlusMinusViewButtonCell - drawWithFrame");
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	//NSFrameRect(cellFrame);
	
	[NSGraphicsContext saveGraphicsState];
	
	NSImage * imageToDraw = [self imageToDraw];
	
	[imageToDraw setSize:NSMakeSize(10.0, 10.0)];
	
	NSRect srcRect = NSZeroRect;
	NSRect destRect = NSZeroRect;
	
	// *****
	// Image
	// *****
	
	srcRect = NSZeroRect;
	destRect = NSZeroRect;
	
	if ( imageToDraw )
	{
		srcRect.size = [imageToDraw size];
		destRect.size = srcRect.size;
		
		destRect.origin.x = floor((NSWidth(cellFrame) - NSWidth(destRect)) / 2.0); // + 1.0;
		destRect.origin.y = floor((NSHeight(cellFrame) - NSHeight(destRect)) / 2.0);
		
		float fraction = ( ( [self isEnabled] ) && ( [[controlView window] isKeyWindow] ) ? 1.0 : 0.5 );
		
		[imageToDraw drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
	}
	
	// *****
	// Titre
	// *****
	
	NSRect titleRect = NSZeroRect;
	NSColor * titleColor = [NSColor colorWithDeviceRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self font], NSFontAttributeName, titleColor, NSForegroundColorAttributeName, nil];
	
	NSAttributedString * attributedTitle = [[[NSAttributedString alloc] initWithString:[self title] attributes:attributes] autorelease];
	
	titleRect.size = [attributedTitle size];
	
	titleRect.origin.x = floor((NSWidth(cellFrame) - NSWidth(titleRect)) / 2.0);
	titleRect.origin.y = floor((NSHeight(cellFrame) - NSHeight(titleRect)) / 2.0);
	
	//[attributedTitle drawInRect:titleRect];
	
	[NSGraphicsContext restoreGraphicsState];
}

// ...

#pragma mark -

- (NSImage *)imageToDraw
{
	NSImage * imageToDraw = nil;
	
	NSImage * image = [self image];
	NSImage * alternateImage = [self alternateImage];
	
	if ( [self isHighlighted] && ( nil != alternateImage ) )
	{		
		imageToDraw = alternateImage;
	}
	else
	{		
		imageToDraw = image;
	}
	
	return imageToDraw;
}

@synthesize isRightCornered;
@end