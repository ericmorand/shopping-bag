//
//  FKModuleGradientTextFieldCell.m
//  ShoppingBag
//
//  Created by Eric on 01/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleGradientTextFieldCell.h"

@interface FKModuleGradientTextFieldCell (Private)

- (void)drawTitleWithFrame:(NSRect)titleFrame inView:(NSView *)controlView;

@end

@implementation FKModuleGradientTextFieldCell

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[NSGraphicsContext saveGraphicsState];
	
	NSBezierPath * aPath = [NSBezierPath bezierPathWithRect:cellFrame];	
	
	[aPath linearGradientFillWithStartColor:[NSColor colorWithDeviceRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]
								   endColor:[NSColor colorWithDeviceRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0]];
	
	[NSGraphicsContext restoreGraphicsState];
	
	// ...
	
	[self drawTitleWithFrame:cellFrame inView:controlView];
}

- (void)drawTitleWithFrame:(NSRect)titleFrame inView:(NSView *)controlView
{
	NSRect titleRect = titleFrame;
	
	NSFont * textFont = [[FKModuleTheme currentTheme] textFont];
	NSColor * textColor = nil;
	NSShadow * textShadow = nil;
	
	NSMutableParagraphStyle * style = [[[NSMutableParagraphStyle alloc] init] autorelease];
	
	[style setLineBreakMode:NSLineBreakByTruncatingTail];	
	
	NSMutableDictionary * attributes = [[[NSMutableDictionary alloc ] init] autorelease];
	
	[attributes setObject:style forKey:NSParagraphStyleAttributeName];		
	
	// *****
	// Titre
	// *****
	
	if ( ![[controlView window] isKeyWindow] )
	{
		textColor = [[FKModuleTheme currentTheme] backgroundStandardTextColor];
		textShadow = [[FKModuleTheme currentTheme] standardTextShadow];
	}
	else
	{
		textColor = [[FKModuleTheme currentTheme] standardTextColor];
		textShadow = [[FKModuleTheme currentTheme] standardTextShadow];
	}
		
	// ...
	
	[attributes setObject:textFont forKey:NSFontAttributeName];		
	[attributes setObject:style forKey:NSParagraphStyleAttributeName];	
	[attributes setObject:textColor forKey:NSForegroundColorAttributeName];
	
	if ( textShadow )
	{
		[attributes setObject:textShadow forKey:NSShadowAttributeName];
	}
	
	NSAttributedString * titleAttrString = [[NSAttributedString alloc] initWithString:[self title] attributes:attributes];
	
	// On centre le texte horizontalement et verticalement		
	
	NSSize titleSize = NSZeroSize;
	
	titleSize = [titleAttrString size];

	titleRect.size.width = ceil(titleSize.width);	
	titleRect.size.height = ceil(titleSize.height);
	titleRect.origin.x += (NSWidth(titleFrame) - NSWidth(titleRect)) / 2.0;
	titleRect.origin.y += (NSHeight(titleFrame) - NSHeight(titleRect)) / 2.0;	
	
	[titleAttrString drawInRect:titleRect];
}

@end
