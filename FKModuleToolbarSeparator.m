//
//  FKModuleToolbarSeparator.m
//  FKKit
//
//  Created by Alt on 20/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleToolbarSeparator.h"


@implementation FKModuleToolbarSeparator

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
	
    if ( self )
	{
    }
    
	return self;
}

- (void)setToolbar:(FKModuleToolbar *)aToolbar {toolbar = aToolbar;}
- (void)setToolbarItem:(FKModuleToolbarItem *)anItem {toolbarItem = anItem;}

- (void)drawRect:(NSRect)aRect {
	NSColor * textColor = [NSColor lightBorderColor];
	//NSShadow * shadow = [toolbar textShadow];
//	
//	[shadow setShadowColor:[toolbar standardTextShadowColor]];
	
	NSRect bezierRect = aRect;
	
	bezierRect.size.width = 1.0;
	bezierRect.size.height -= 1.0;
	bezierRect.origin.y += 1.0;	
		
	[textColor set];
	//[shadow set];
	
	[NSBezierPath fillRect:bezierRect];
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

@synthesize toolbar;
@synthesize toolbarItem;
@end
