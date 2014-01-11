//
//  FKModuleToolbarButton.m
//  FKKit
//
//  Created by Alt on 19/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleToolbarButton.h"
#import "FKModuleToolbarButtonCell.h"


@interface FKModuleToolbarButton (Private)

- (void)setFirstLine:(NSString *)aString;
- (void)setSecondLine:(NSString *)aString;
- (void)calculateLayout;

@end

@implementation FKModuleToolbarButton

+ (Class)cellClass {return [FKModuleToolbarButtonCell class];}

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if (nil != self) {
		[self setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];		
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(frameDidChange:) name:NSViewFrameDidChangeNotification object:self];
		[self setPostsFrameChangedNotifications:YES];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:NSViewFrameDidChangeNotification object:self];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (BOOL)isOpaque {return NO;}
- (BOOL)mouseOver {return mouseOver;}
- (float)horizontalMargin {return [[self cell] horizontalMargin];}

//- (BOOL)isSelected {return [toolbarItem isSelected];}

- (FKModuleToolbar *)toolbar {
	return [[self cell] toolbar];
}

- (FKModuleToolbarItem *)toolbarItem {
	return [[self cell] toolbarItem];
}

#pragma mark -
#pragma mark SETTERS

- (void)setToolbar:(FKModuleToolbar *)aToolbar {
	[[self cell] setToolbar:aToolbar];
}

- (void)setToolbarItem:(FKModuleToolbarItem *)anItem {	
	[[self cell] setToolbarItem:anItem];
}

- (void)setMouseOver:(BOOL)flag {mouseOver = flag;}

- (void)setFirstLine:(NSString *)aString {[[self cell] setFirstLine:aString];}
- (void)setSecondLine:(NSString *)aString {[[self cell] setSecondLine:aString];}

#pragma mark -
#pragma mark MISC

- (void)viewWillMoveToWindow:(NSWindow *)newWindow
{
	NSNotificationCenter * defaultCenter = [NSNotificationCenter defaultCenter];
	
	[defaultCenter removeObserver:self name:NSWindowDidResignKeyNotification object:nil];
	[defaultCenter removeObserver:self name:NSWindowDidBecomeKeyNotification object:nil];
	
	if ( nil != newWindow )
	{
		[defaultCenter addObserver:self selector:@selector(windowDidChangeKeyNotification:) name:NSWindowDidResignKeyNotification object:newWindow];
		[defaultCenter addObserver:self selector:@selector(windowDidChangeKeyNotification:) name:NSWindowDidBecomeKeyNotification object:newWindow];
	}
}

- (void)windowDidChangeKeyNotification:(NSNotification *)notification
{
	[self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark LAYOUT & DRAWING

- (void)frameDidChange:(NSNotification *)aNotification {
	[[self cell] calculateLayout];
}

- (void)sizeToFit
{
	[self setFrameSize:[[self cell] cellSize]];
}

@end
