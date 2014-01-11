//
//  FKModuleToolbarFlatButton.m
//  FKKit
//
//  Created by Alt on 27/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleToolbarFlatButton.h"

@interface FKModuleToolbarFlatButton (Private)

- (void)setNormalL:(NSImage *)anImage;
- (void)setNormalFill:(NSImage *)anImage;
- (void)setNormalR:(NSImage *)anImage;
- (void)setPressedL:(NSImage *)anImage;
- (void)setPressedFill:(NSImage *)anImage;
- (void)setPressedR:(NSImage *)anImage;

@end

@implementation FKModuleToolbarFlatButton

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if ( self )
	{
		[self setNormalL:[NSImage imageNamed:@"FKModuleToolbarFlatButtonL" forClass:[self class]]];
		[self setNormalFill:[NSImage imageNamed:@"FKModuleToolbarFlatButtonFill" forClass:[self class]]];
		[self setNormalR:[NSImage imageNamed:@"FKModuleToolbarFlatButtonR" forClass:[self class]]];
		[self setPressedL:[NSImage imageNamed:@"FKModuleToolbarFlatButtonL-Pressed" forClass:[self class]]];
		[self setPressedFill:[NSImage imageNamed:@"FKModuleToolbarFlatButtonFill-Pressed" forClass:[self class]]];
		[self setPressedR:[NSImage imageNamed:@"FKModuleToolbarFlatButtonR-Pressed" forClass:[self class]]];		
		
		//horizontalMargin = 16.0;
		
		[self setFont:[NSFont systemFontOfSize:[NSFont systemFontSize]]];
	}
	
	return self;
}

#pragma mark -
#pragma mark SETTERS

- (void)setNormalL:(NSImage *)anImage
{
	if ( anImage != normalL	)
	{
		[normalL release];
		normalL = [anImage copy];
	}
}

- (void)setNormalFill:(NSImage *)anImage
{
	if ( anImage != normalFill	)
	{
		[normalFill release];
		normalFill = [anImage copy];
	}
}

- (void)setNormalR:(NSImage *)anImage
{
	if ( anImage != normalR	)
	{
		[normalR release];
		normalR = [anImage copy];
	}
}

- (void)setPressedL:(NSImage *)anImage
{
	if ( anImage != pressedL )
	{
		[pressedL release];
		pressedL = [anImage copy];
	}
}

- (void)setPressedFill:(NSImage *)anImage
{
	if ( anImage != pressedFill	)
	{
		[pressedFill release];
		pressedFill = [anImage copy];
	}
}

- (void)setPressedR:(NSImage *)anImage
{
	if ( anImage != pressedR	)
	{
		[pressedR release];
		pressedR = [anImage copy];
	}
}

#pragma mark -
#pragma mark LAYOUT & DRAWING

/*- (void)sizeToFit
{
	NSSize sizeToFit = NSZeroSize;
	
	sizeToFit.width += horizontalMargin;
	
	if ( [self image] )
	{
		sizeToFit.width += [[self image] size].width + horizontalMargin;
	}
	
	if ( ( [self title] != nil ) && ( ![[self title] isEqualToString:@""] ) )
	{
		NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self font], NSFontAttributeName, nil];
		
		sizeToFit.width += ceil([[self title] sizeWithAttributes:attributes].width) + horizontalMargin;
	}
	
	sizeToFit.height = 27.0;
	
	[self setFrameSize:sizeToFit];
}

- (void)drawRect:(NSRect)aRect
{
	//NSFrameRect(aRect);
	
	BOOL isKeyWindow = [[self window] isKeyWindow];
	
	// ****
	// Fond
	// ****
	
	NSImage * imageL = nil;
	NSImage * imageFill = nil;
	NSImage * imageR = nil;
		
	if ( [[self cell] isHighlighted] )
	{
		imageL = pressedL;
		imageFill = pressedFill;
		imageR = pressedR;
	}
	else
	{
		imageL = normalL;
		imageFill = normalFill;
		imageR = normalR;	
	}
	
	NSRect srcRect = NSZeroRect;
	NSRect destRect = aRect;
	
	float fraction = 1.0;
	
	if ( ( ![self isEnabled] ) || ( ![[self window] isKeyWindow] ) )
	{
		fraction = 0.50;
	}
	
	// Left
	
	srcRect.size = [imageL size];
	
	destRect.size = srcRect.size;
		
	if ( [self isFlipped] )
	{
		[imageL setFlipped:YES];
	}
	
	[imageL drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
	
	// Fill
	
	srcRect.size = [imageFill size];
	
	destRect.origin.x += destRect.size.width;
	destRect.size.width = (aRect.origin.x + aRect.size.width) - (destRect.origin.x + [imageR size].width);
	
	if ( [self isFlipped] )
	{
		[imageFill setFlipped:YES];
	}
	
	[imageFill drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
	
	// Right
	
	srcRect.size = [imageR size];
	
	destRect.origin.x += destRect.size.width;
	destRect.size = srcRect.size;
	
	if ( [self isFlipped] )
	{
		[imageR setFlipped:YES];
	}
	
	[imageR drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:fraction];
	
	// *****
	// Titre
	// *****
	
	if ( [self title] )
	{
		NSColor * titleColor = [NSColor controlTextColor];
		
		if ( ( ![self isEnabled] ) || ( ![[self window] isKeyWindow] ) )
		{
			titleColor = [NSColor disabledControlTextColor];
		}
		
		NSRect titleRect = NSZeroRect;
		
		NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:[self font], NSFontAttributeName, titleColor, NSForegroundColorAttributeName, nil];
		NSAttributedString * titleAttrString = [[[NSAttributedString alloc] initWithString:[self title] attributes:attributes] autorelease];
		
		titleRect.size = [titleAttrString size];
		
		titleRect.origin.x += horizontalMargin;
		titleRect.origin.y = floor((aRect.size.height - titleRect.size.height) / 2.0);
		
		[titleAttrString drawInRect:titleRect];
	}
}
*/
@end
