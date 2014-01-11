//
//  FKButtonCell.m
//  FKKit
//
//  Created by Eric on 01/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKButtonCell.h"

@interface FKButtonCell (Private)

- (NSImage *)imageToDraw;
- (NSImage *)finalizeImage:(NSImage *)anImage;

- (void)drawFKBorderOnlyBezelStyleWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (void)drawFKBorderOnlyBezelStyleInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

- (void)drawFKSquareBezelStyleWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (void)drawFKSquareBezelStyleInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end

@implementation FKButtonCell

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setTitle:nil];
		[self setFont:[NSFont boldSystemFontOfSize:[NSFont smallSystemFontSize]]];
		[self setFkBezelStyle:FKBorderOnlyBezelStyle];
		
		leftMargin = 0.0;
		rightMargin = 0.0;
	}
	
	return self;
}

- (void)dealloc
{	
	[self setTitleStringAttributes:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (NSSize)cellSize
{	
	NSSize cellSize = NSZeroSize;
	
	NSImage * image = [self image];
	NSSize imageSize = [image size];
	
	if ( nil != image )
	{
		cellSize.width += leftMargin + imageSize.width;
	}
	
	NSString  * title = [self title];
	NSAttributedString * attributedTitle = nil;
	
	if ( ( nil != title ) && ( ![title isEqualToString:@""] ) )
	{		
		NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self font], NSFontAttributeName, nil];
		
		attributedTitle = [[[NSAttributedString alloc] initWithString:title attributes:attributes] autorelease];
				
		cellSize.width += imageToTitleSpacing + ceil([attributedTitle size].width);
	}
	
	cellSize.height = MAX(imageSize.height, [attributedTitle size].height);
	cellSize.width += leftMargin;
		
	return cellSize;
}

#pragma mark -
#pragma mark SETTERS

- (void)setFkBezelStyle:(FKBezelStyle)aStyle
{
	if ( aStyle != fkBezelStyle )
	{
		fkBezelStyle = aStyle;
		
		[[self controlView] setNeedsDisplay:YES];
	}
}
- (void)setBorderMask:(unsigned)anInt
{
	if ( anInt != borderMask )
	{
		borderMask = anInt;
		
		[[self controlView] setNeedsDisplay:YES];
	}
}

- (void)setLeftMargin:(float)aFloat {leftMargin = aFloat;}
- (void)setRightMargin:(float)aFloat {rightMargin = aFloat;}

- (void)setTitleStringAttributes:(NSMutableDictionary *)aDictionary
{
	if ( aDictionary != titleStringAttributes )
	{
		[titleStringAttributes release];
		titleStringAttributes = [aDictionary retain];
	}
}

#pragma mark -
#pragma mark DRAWING

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	switch (fkBezelStyle)
	{
		case FKBorderOnlyBezelStyle :
		{
			[self drawFKBorderOnlyBezelStyleWithFrame:cellFrame inView:controlView];
			
			break;
		}
		
		case FKSquareBezelStyle :
		{
			[self drawFKSquareBezelStyleWithFrame:cellFrame inView:controlView];
			
			break;
		}
	}
}

#pragma mark DRAWING : FKBorderOnlyBezelStyle

- (void)drawFKBorderOnlyBezelStyleWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	// Bords
	
	if ( borderMask & FKNoBorder )
	{
	}
	else
	{		
		NSRect borderRect = NSZeroRect;
		
		[[NSColor lightBorderColor] set];
		
		if ( borderMask & FKLeftBorder )
		{
			NSDivideRect(cellFrame, &borderRect, &cellFrame, 1.0, NSMinXEdge);
			
			[NSBezierPath fillRect:borderRect];
		}	
		
		if ( borderMask & FKTopBorder )
		{
			NSDivideRect(cellFrame, &borderRect, &cellFrame, 1.0, NSMinYEdge);
			
			[NSBezierPath fillRect:borderRect];
		}
		
		if ( borderMask & FKRightBorder )
		{
			NSDivideRect(cellFrame, &borderRect, &cellFrame, 1.0, NSMaxXEdge);
			
			[NSBezierPath fillRect:borderRect];
		}
		
		if ( borderMask & FKBottomBorder )
		{
			NSDivideRect(cellFrame, &borderRect, &cellFrame, 1.0, NSMaxYEdge);
			
			[NSBezierPath fillRect:borderRect];
		}
	}
	
	// Fond
	
	if ( [self isHighlighted] )
	{
		[[[NSColor blackColor] colorWithAlphaComponent:0.25] set];
		
		[NSBezierPath fillRect:cellFrame];
	}	
	
	// ...
	
	[self drawFKBorderOnlyBezelStyleInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawFKBorderOnlyBezelStyleInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	//NSFrameRect(cellFrame);
	
	NSImage * normalImageToDraw = [self imageToDraw];
		
	NSRect srcRect = NSZeroRect;
	NSRect destRect = NSZeroRect;
	
	[NSGraphicsContext saveGraphicsState];
	
	// *****
	// Image
	// *****
	
	srcRect = NSZeroRect;
	destRect = cellFrame;
	
	if ( normalImageToDraw )
	{
		srcRect.size = [normalImageToDraw size];
		destRect.size = srcRect.size;
	
		destRect.origin.x += floor((NSWidth(cellFrame) - NSWidth(destRect)) / 2.0);
		destRect.origin.y += floor((NSHeight(cellFrame) - NSHeight(destRect)) / 2.0);
	
		float fraction = ( ( [self isEnabled] ) && ( [[controlView window] isKeyWindow] ) ? 1.0 : 0.4 );
		
		[normalImageToDraw drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
	}
	
	// *****
	// Titre
	// *****
		
	NSRect titleRect = NSZeroRect;
	NSColor * titleColor = [NSColor colorWithDeviceRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
	NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self font], NSFontAttributeName, titleColor, NSForegroundColorAttributeName, nil];
	NSShadow * shadow = [[[NSShadow alloc] init] autorelease];
	
	[shadow setShadowColor:[NSColor whiteColor]];
	[shadow setShadowOffset:NSMakeSize(0.0, -1.0)];
	[shadow set];
	
	NSAttributedString * attributedTitle = [[[NSAttributedString alloc] initWithString:[self title] attributes:attributes] autorelease];
		
	titleRect.size = [attributedTitle size];
	
	titleRect.origin.x = destRect.origin.x + imageToTitleSpacing;
	titleRect.origin.y = floor((NSHeight(cellFrame) - NSHeight(titleRect)) / 2.0);
	
	[attributedTitle drawInRect:titleRect];

	[NSGraphicsContext restoreGraphicsState];
}

#pragma mark DRAWING : FKSquareBezelStyle

- (void)drawFKSquareBezelStyleWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	// Bords

	[[NSColor lightBorderColor] set];
	
	[NSBezierPath fillRect:cellFrame];	
	
	// Fond
	
	NSRect backgroundRect = NSInsetRect(cellFrame, 1.0, 1.0);

	NSRect topGradientRect = NSZeroRect;
	NSRect bottomGradientRect = NSZeroRect;
	
	NSBezierPath * path = nil;
	
	NSDivideRect(backgroundRect, &topGradientRect, &bottomGradientRect, floor(NSHeight(backgroundRect) / 2.0), NSMinYEdge);
	
	// ...
	
	path = [NSBezierPath bezierPathWithRect:topGradientRect];
	
	[path linearGradientFillWithStartColor:[NSColor colorWithDeviceRed:253.0/255.0 green:253.0/255.0 blue:253.0/255.0 alpha:1.0]
								  endColor:[NSColor colorWithDeviceRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0]];
	
	[[NSColor colorWithDeviceRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0] set];
	
	[NSBezierPath fillRect:bottomGradientRect];
		
	// ...
	
	if ( [self isHighlighted] )
	{
		[[[NSColor blackColor] colorWithAlphaComponent:0.25] set];
		
		[NSBezierPath fillRect:backgroundRect];
	}	
	
	// ...
	
	[self drawFKSquareBezelStyleInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawFKSquareBezelStyleInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{		
	NSImage * normalImageToDraw = [self imageToDraw];
	
	NSRect srcRect = NSZeroRect;
	NSRect destRect = NSZeroRect;
	
	[NSGraphicsContext saveGraphicsState];
	
	// *****
	// Image
	// *****
	
	srcRect = NSZeroRect;
	destRect = NSZeroRect;
	
	if ( normalImageToDraw )
	{
		srcRect.size = [normalImageToDraw size];
		destRect.size = srcRect.size;
		
		destRect.origin.x = floor((NSWidth(cellFrame) - NSWidth(destRect)) / 2.0);
		destRect.origin.y = floor((NSHeight(cellFrame) - NSHeight(destRect)) / 2.0);
		
		float fraction = ( ( [self isEnabled] ) && ( [[controlView window] isKeyWindow] ) ? 1.0 : 0.5 );
		
		[normalImageToDraw drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
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
	
	[attributedTitle drawInRect:titleRect];
	
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

- (NSImage *)finalizeImage:(NSImage *)anImage
{
   	NSView * controlView = [self controlView];
	
	if ( ( [self isEnabled] ) && ( [[controlView window] isKeyWindow] ) )
	{
		return anImage;
	}
	
	NSSize newSize = [anImage size];
	NSRect srcRect = NSZeroRect;
	
	NSImage * newImage = [[NSImage alloc] initWithSize:newSize];
	
	srcRect.size = newSize;
	
	[newImage setFlipped:[controlView isFlipped]];
	//[newImage lockFocus];
		
	float fraction = 0.50;
	
	[anImage drawAtPoint:NSZeroPoint fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
	
	//[newImage unlockFocus];
	
    return [newImage autorelease];
}

@synthesize leftMargin;
@synthesize rightMargin;
@synthesize imageToTitleSpacing;
@end

#pragma mark -
#pragma makr FKGradientButtonCell
#pragma mark -

@implementation FKGradientButtonCell

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		NSColor * titleColor = [NSColor colorWithDeviceRed:52.0/255.0 green:52.0/255.0 blue:52.0/255.0 alpha:1.0];
		NSMutableParagraphStyle * style = [[[NSMutableParagraphStyle alloc] init] autorelease];
		
		[style setAlignment:[self alignment]];
		[style setLineBreakMode:NSLineBreakByTruncatingTail];
		
		NSMutableDictionary * aDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
			[self font],
			NSFontAttributeName,
			titleColor,
			NSForegroundColorAttributeName,
			style,
			NSParagraphStyleAttributeName,
			nil];
		
		[self setTitleStringAttributes:aDictionary];
		
		// ...
		
		leftMargin = 16.0;
		rightMargin = 16.0;
		imageToTitleSpacing = 8.0;
	}
	
	return self;
}

#pragma mark -
#pragma mark GETTERS

- (NSSize)cellSize
{
	NSSize cellSize = NSZeroSize;
	
	NSImage * image = [self image];
	NSSize imageSize = [image size];
	
	if ( nil != image )
	{
		cellSize.width += leftMargin + imageSize.width;
	}
	else
	{
		cellSize.width += leftMargin;
	}
		
	NSString  * title = [self title];
	NSAttributedString * attributedTitle = nil;
	
	if ( ( nil != title ) && ( ![title isEqualToString:@""] ) )
	{
		attributedTitle = [[[NSAttributedString alloc] initWithString:title attributes:titleStringAttributes] autorelease];
		
		if ( nil != image )
		{
			cellSize.width += imageToTitleSpacing + ceil([attributedTitle size].width);
		}
		else
		{
			cellSize.width += leftMargin + ceil([attributedTitle size].width);
		}
	}
		
	cellSize.height = 28.0;
	cellSize.width += rightMargin;
		
	return cellSize;
}

#pragma mark -
#pragma mark DRAWING

- (NSRect)image:(NSImage *)image rectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSRect imageRect = NSZeroRect;
	
	imageRect.size = [image size];
	
	if ( [self imagePosition] == NSImageOnly )
	{
		imageRect.origin.x = floor((NSWidth(cellFrame) - NSWidth(imageRect)) / 2.0);
	}
	else
	{
		imageRect.origin.x = leftMargin;
	}
	
	imageRect.origin.y = floor((NSHeight(cellFrame) - NSHeight(imageRect)) / 2.0);
	
	return imageRect;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{			
	NSBezierPath * path = nil;
	
	NSColor * startColor = nil;
	NSColor * endColor = nil;
	NSColor * strokeColor = nil;
	
	NSRect pathRect = NSZeroRect;
	
	BOOL isFlipped = [controlView isFlipped];
	BOOL isHighlighted = [self isHighlighted];
	
	if ( isFlipped )
	{
		startColor = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
		endColor = [NSColor colorWithDeviceRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
	}
	else
	{
		startColor = [NSColor colorWithDeviceRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];		
		endColor = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
	}
	
	// *******
	//
	// *******
	
	pathRect = NSInsetRect(cellFrame, 0.5, 0.5);	
	
	path = [NSBezierPath bezierPathWithRoundedRect:pathRect cornerRadius:10.0 cornerMask:FKEveryCorner];
	
	[path setLineJoinStyle:NSRoundLineJoinStyle];
	
	strokeColor = [NSColor colorWithDeviceRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1.0];
	
	// *******
	//
	// *******
	
	[path linearGradientFillWithStartColor:startColor endColor:endColor];
	
	// ...
	
	if ( isHighlighted )
	{
		[[[NSColor blackColor] colorWithAlphaComponent:0.25] set];
		
		[path fill];
	}
	
	// Stroke
	
	[strokeColor set];
	
	[path stroke];
	
	// ...
	
	[self drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	[NSGraphicsContext saveGraphicsState];
	
	NSImage * normalImageToDraw = [self imageToDraw];
	
	NSRect srcRect = NSZeroRect;
	NSRect destRect = NSZeroRect;
	
	// *****
	// Image
	// *****
	
	srcRect = NSZeroRect;
	destRect = NSZeroRect;
		
	if ( normalImageToDraw )
	{		
		srcRect.size = [normalImageToDraw size];
		
		destRect = [self image:normalImageToDraw rectForCellFrame:cellFrame inView:controlView];
		
		float fraction = ( ( [self isEnabled] ) && ( [[controlView window] isKeyWindow] ) ? 1.0 : 0.5 );
		
		[normalImageToDraw drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
	}
	
	//NSFrameRect(destRect);
	
	// *****
	// Titre
	// *****
	
	NSAttributedString * attributedTitle = [[[NSAttributedString alloc] initWithString:[self title] attributes:titleStringAttributes] autorelease];
	NSRect titleRect = NSZeroRect;
		
	titleRect.size.height = [attributedTitle size].height;
	
	if ( nil != normalImageToDraw )
	{
		titleRect.origin.x = NSMaxX(destRect) + imageToTitleSpacing;
	}
	else
	{
		titleRect.origin.x = NSMaxX(destRect) + leftMargin;
	}
	
	titleRect.origin.y = floor((NSHeight(cellFrame) - NSHeight(titleRect)) / 2.0);
	titleRect.size.width = NSWidth(cellFrame) - (NSMinX(titleRect) + rightMargin);
	
	//NSFrameRect(titleRect);
	
	[attributedTitle drawInRect:titleRect];
	
	[NSGraphicsContext restoreGraphicsState];
}

@end

#pragma mark -
#pragma makr FKPlateGradientButtonCell
#pragma mark -

@implementation FKPlateGradientButtonCell

- (id)init
{
	self = [super init];
	
	if ( self )
	{
	}
	
	return self;
}

#pragma mark -
#pragma mark GETTERS

- (NSRect)image:(NSImage *)image rectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSRect imageRect = [super image:image rectForCellFrame:cellFrame inView:controlView];
	
	if ( rightAnglesMask | FKLeftBorder )
	{
		imageRect.origin.x -= 1.0;
	}
	
	return imageRect;
}

#pragma mark -
#pragma mark SETTERS

- (void)setRightAnglesMask:(unsigned)anInt {rightAnglesMask = anInt;}
- (void)setStrokedBordersMask:(unsigned)anInt {strokedBordersMask = anInt;}

#pragma mark -
#pragma mark DRAWING

- (NSBezierPath *)fillPathWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSBezierPath * path = [NSBezierPath bezierPath];	
	
	NSRect pathRect = NSInsetRect(cellFrame, 0.0, 0.0);	
	
	float radius = NSHeight(pathRect) / 2.0;	
	
	NSPoint startPoint = NSZeroPoint;
	NSPoint point1 = NSZeroPoint;
	NSPoint point2 = NSZeroPoint;
	NSPoint point3 = NSZeroPoint;
	NSPoint point4 = NSZeroPoint;
	
	// startPoint	
	
	startPoint.x = NSMinX(pathRect);
	startPoint.y = NSMaxY(pathRect) - radius;
	
	[path moveToPoint:startPoint];
	
	// point1
	
	point1.x = NSMinX(pathRect);
	point1.y = NSMaxY(pathRect);	
	
	if ( rightAnglesMask & FKTopLeftAngle )
	{		
		// _____
		// |
		// |
		
		[path lineToPoint:point1];
	}
	else	
	{
		//  ____
		// /
		// |
		
		point1.x += radius;
		point1.y -= radius;
		
		[path appendBezierPathWithArcWithCenter:point1 radius:radius startAngle:180.0 endAngle:90.0 clockwise:YES];
	}
	
	// point2
	
	point2.x = NSMaxX(pathRect);
	point2.y = NSMaxY(pathRect);
	
	if ( rightAnglesMask & FKTopRightAngle )
	{
		// _____
		//     |
		//     |
		
		[path lineToPoint:point2];
	}
	else
	{
		// ____
		//     \
		//     |
		
		point2.x -= radius;
		point2.y -= radius;
		
		[path appendBezierPathWithArcWithCenter:point2 radius:radius startAngle:90.0 endAngle:0.0 clockwise:YES];
	}
	
	// point3
	
	point3.x = NSMaxX(pathRect);
	point3.y = NSMinY(pathRect);
	
	if ( rightAnglesMask & FKBottomRightAngle )
	{
		//     |
		//     |
		// -----
		
		[path lineToPoint:point3];
	}
	else
	{
		//     |
		//     /
		// ----
		
		point3.x -= radius;
		point3.y += radius;
		
		[path appendBezierPathWithArcWithCenter:point3 radius:radius startAngle:0.0 endAngle:270.0 clockwise:YES];
	}
	
	// point4
	
	point4.x = NSMinX(pathRect);
	point4.y = NSMinY(pathRect);
	
	if ( rightAnglesMask & FKBottomLeftAngle )
	{
		// |
		// |
		// |____
		
		[path lineToPoint:point4];
	}
	else
	{
		// |    
		// \   
		//  ----
		
		point4.x += radius;
		point4.y += radius;
		
		[path appendBezierPathWithArcWithCenter:point4 radius:radius startAngle:270.0 endAngle:180.0 clockwise:YES];
	}
	
	// ...
	
	if ( rightAnglesMask & FKBottomLeftAngle )
	{
		[path lineToPoint:startPoint];
	}
	
	return path;
}

- (NSBezierPath *)strokePathWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	NSBezierPath * path = [NSBezierPath bezierPath];	
	
	NSRect pathRect = NSInsetRect(cellFrame, 0.5, 0.5);	
	
	float radius = NSHeight(pathRect) / 2.0;
	
	NSPoint startPoint = NSZeroPoint;
	NSPoint point1 = NSZeroPoint;
	NSPoint point2 = NSZeroPoint;
	NSPoint point3 = NSZeroPoint;
	NSPoint point4 = NSZeroPoint;
	
	// startPoint	
	
	startPoint.x = NSMinX(pathRect);
	startPoint.y = NSMaxY(pathRect) - radius;
	
	[path moveToPoint:startPoint];
	
	// point1
	
	point1.x = NSMinX(pathRect);
	point1.y = NSMaxY(pathRect);	
		
	if ( rightAnglesMask & FKTopLeftAngle )
	{		
		// _____
		// |
		// |
		
		if ( strokedBordersMask & FKLeftBorder )
		{
			if ( !( strokedBordersMask & FKTopBorder ) )
			{
				point1.y += 0.5;
			}
			
			[path lineToPoint:point1];
		}
		else
		{
			point1.x -= 0.5;
			
			[path moveToPoint:point1];		
		}
	}
	else	
	{
		//  ____
		// /
		// |
		
		point1.x += radius;
		point1.y -= radius;
		
		[path appendBezierPathWithArcWithCenter:point1 radius:radius startAngle:180.0 endAngle:90.0 clockwise:YES];
	}
	
	// point2
	
	point2.x = NSMaxX(pathRect);
	point2.y = NSMaxY(pathRect);
	
	if ( rightAnglesMask & FKTopRightAngle )
	{
		
		// _____
		//     |
		//     |
		
		if ( strokedBordersMask & FKTopBorder )
		{
			if ( !( strokedBordersMask & FKRightBorder ) )
			{
				point2.x += 0.5;
			}
			
			[path lineToPoint:point2];
		}
		else
		{
			point2.y += 0.5;
			
			[path moveToPoint:point2];
		}
	}
	else
	{
		// ____
		//     \
		//     |
		
		point2.x -= radius;
		point2.y -= radius;
		
		[path appendBezierPathWithArcWithCenter:point2 radius:radius startAngle:90.0 endAngle:0.0 clockwise:YES];
	}
	
	// point3
	
	point3.x = NSMaxX(pathRect);
	point3.y = NSMinY(pathRect);
		
	if ( rightAnglesMask & FKBottomRightAngle )
	{
		//     |
		//     |
		// -----
		
		if ( strokedBordersMask & FKRightBorder )
		{
			if ( !( strokedBordersMask & FKBottomBorder ) )
			{
				point3.y += 0.5;
			}
			
			[path lineToPoint:point3];
		}
		else
		{
			point3.x += 0.5;
			
			[path moveToPoint:point3];
		}
	}
	else
	{
		//     |
		//     /
		// ----
		
		point3.x -= radius;
		point3.y += radius;
		
		[path appendBezierPathWithArcWithCenter:point3 radius:radius startAngle:0.0 endAngle:270.0 clockwise:YES];	
	}
	
	// point4
	
	point4.x = NSMinX(pathRect);
	point4.y = NSMinY(pathRect);
		
	if ( rightAnglesMask & FKBottomLeftAngle )
	{
		// |
		// |
		// |____
		
		if ( strokedBordersMask & FKBottomBorder )
		{
			if ( !( strokedBordersMask & FKLeftBorder ) )
			{
				point4.x -= 0.5;
			}
			
			[path lineToPoint:point4];
		}
		else
		{
			point4.y -= 0.5;
			
			[path moveToPoint:point4];	
		}
	}
	else
	{
		// |    
		// \   
		//  ----
		
		point4.x += radius;
		point4.y += radius;
		
		[path appendBezierPathWithArcWithCenter:point4 radius:radius startAngle:270.0 endAngle:180.0 clockwise:YES];
	}
	
	// ...
	
	if ( ( rightAnglesMask & FKBottomLeftAngle ) && ( strokedBordersMask & FKLeftBorder ) )
	{
		[path lineToPoint:startPoint];
	}
	
	return path;
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{		
	NSBezierPath * path = nil;
	
	NSColor * startColor = nil;
	NSColor * endColor = nil;
	NSColor * strokeColor = nil;
		
	BOOL isFlipped = [controlView isFlipped];
	BOOL isHighlighted = [self isHighlighted];
	
	if ( isFlipped )
	{
		startColor = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
		endColor = [NSColor colorWithDeviceRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];
	}
	else
	{
		startColor = [NSColor colorWithDeviceRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0];		
		endColor = [NSColor colorWithDeviceRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
	}
	
	// ...
	
	path = [self fillPathWithFrame:cellFrame inView:controlView];
	
	strokeColor = [NSColor lightBorderColor];
	
	// ...
	
	[path linearGradientFillWithStartColor:startColor endColor:endColor];
	
	// ...
	
	if ( isHighlighted )
	{
		[[[NSColor blackColor] colorWithAlphaComponent:0.25] set];
		
		[path fill];
	}
	
	// Stroke
	
	path = [self strokePathWithFrame:cellFrame inView:controlView];	
	
	if ( [self isEnabled] )
	{
		[strokeColor set];
	}
	else
	{
		[[NSColor colorWithDeviceRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0] set];
	}

	[path stroke];	
	
	// ...
	
	[self drawInteriorWithFrame:cellFrame inView:controlView];
	
	//NSFrameRect(cellFrame);
}

@synthesize rightAnglesMask;
@synthesize strokedBordersMask;
@end
