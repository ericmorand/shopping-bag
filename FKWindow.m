//
//  FKWindow.m
//  ShoppingBag
//
//  Created by Eric on 26/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKWindow.h"

NSString * FKWindowFirstResponderDidChange = @"FKWindowFirstResponderDidChange";
NSString * FKViewFirstResponderDidChange = @"FKViewFirstResponderDidChange";

@implementation FKWindow

@synthesize postsFirstResponderChangedNotifications;

#pragma mark -
#pragma mark GETTERS

- (float)toolbarHeight
{
    NSToolbar * toolbar = nil;
    NSRect windowFrame = NSZeroRect;
    float toolbarHeight = 0.0;
	
    toolbar = [self toolbar];
	
    if( toolbar && [toolbar isVisible] )
    {
        windowFrame = [NSWindow contentRectForFrameRect:[self frame] styleMask:[self styleMask]];
        toolbarHeight = NSHeight(windowFrame) - NSHeight([[self contentView] frame]);
    }
	
    return toolbarHeight;
}

#pragma mark -
#pragma mark RESPONDERS SUPPORT

- (BOOL)makeFirstResponder:(NSResponder *)aResponder
{
	return [self makeFirstResponder:aResponder notify:postsFirstResponderChangedNotifications];
}

- (BOOL)makeFirstResponder:(NSResponder *)aResponder notify:(BOOL)flag
{
	BOOL makeFirstResponder = [super makeFirstResponder:aResponder];
	
	if ( flag )
	{
		if ( makeFirstResponder )
		{
			if ( [aResponder isKindOfClass:[NSView class]] )
			{
				NSView * theView = (NSView *)aResponder;
				NSView * superview = [theView superview];
			
				// Si la vue qui est devenue "firstResponder" se trouve directement a l'interieur
				// d'une "clip view" (ex : NSTableView, NSTextView...), on retourne la supervue
				// de la "scroll view" au lieu de la supervue de la vue
			
				if ( [superview isKindOfClass:[NSClipView class]] )
				{
					superview = [[theView enclosingScrollView] superview];
				}
							
				NSDictionary * notificationDictionary = [NSDictionary dictionaryWithObject:theView forKey:@"FKViewAttributeName"];
				
				[[NSNotificationCenter defaultCenter] postNotificationName:FKViewFirstResponderDidChange
																	object:superview
																  userInfo:notificationDictionary];
			}
		}
	}
	
	return makeFirstResponder;
}

@end
