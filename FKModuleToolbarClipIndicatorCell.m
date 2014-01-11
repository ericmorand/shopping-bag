//
//  FKModuleToolbarClipIndicatorCell.m
//  FKKit
//
//  Created by alt on 02/10/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleToolbarClipIndicatorCell.h"
#import "FKModuleToolbarClipIndicator.h"
#import "FKModuleToolbarSeparatorItem.h"

@implementation FKModuleToolbarClipIndicatorCell

@synthesize clippedItems;
@synthesize horizontalMargin;
@synthesize toolbar;
@synthesize toolbarItem;

- (id)init {
	self = [super init];
    
	if (nil != self)
	{
		self.usesItemFromMenu = NO;
		self.altersStateOfSelectedItem = NO;
		
		self.menu.autoenablesItems = NO;
		
		horizontalMargin = 0.0;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willPopUpNotification:) name:NSPopUpButtonCellWillPopUpNotification object:self];
    }
	
    return self;
}

- (void)dealloc {
	self.clippedItems = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (NSSize)chevronsSize {
	return NSMakeSize(15.0, 10.0);
}

- (NSSize)cellSize {
	NSSize cellSize = [self chevronsSize];
	
	cellSize.width += (2 * horizontalMargin);
	cellSize.height = 18.0;
	
	return cellSize;
}

- (NSColor *)foreColor {
	if ([self state] == NSOnState) {
		return [NSColor whiteColor];
	}
	
	return [NSColor colorWithDeviceRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
}

- (NSShadow *)shadow {
	NSShadow * result = [[[NSShadow alloc] init] autorelease];
	NSColor * shadowColor = nil;
	
	if ([self state] == NSOnState) {
		shadowColor = [NSColor blackColor];
	}
	else {
		shadowColor = [NSColor whiteColor];
	}
	
	[result setShadowOffset:NSMakeSize(0.0, -1.0)];
	[result setShadowBlurRadius:0.0];
	[result setShadowColor:[shadowColor colorWithAlphaComponent:0.50]];
	
	return result;
}

#pragma mark -
#pragma mark NOTIFICATIONS

- (void)willPopUpNotification:(NSNotification *)aNotification
{
	// Generation du menu
	
	[self removeAllItems];
	
	NSMenuItem * aMenuItem = nil;
	NSMenu * menu = [self menu];
	
	int i = 0;
		
	for ( ; i < [clippedItems count]; i++ )
	{
		FKModuleToolbarItem * aToolbarItem = [clippedItems objectAtIndex:i];
		
		if ( [aToolbarItem isKindOfClass:[FKModuleToolbarSeparatorItem class]] )
		{
			aMenuItem = [NSMenuItem separatorItem];
		}
		else
		{
			aMenuItem = [[[NSMenuItem alloc] initWithTitle:[aToolbarItem label] action:@selector(menuItemClicked:) keyEquivalent:@""] autorelease];
		
			[aMenuItem setImage:[aToolbarItem image]];
			[aMenuItem setTarget:self];
			[aMenuItem setTag:i];
			[aMenuItem setEnabled:[aToolbarItem isEnabled]];
			[aMenuItem setState:([aToolbarItem isSelected] ? NSOnState : NSOffState)];
		}
		
		[menu addItem:aMenuItem];
	}
}

#pragma mark -
#pragma mark ACTIONS

- (void)menuItemClicked:(id)sender;
{
	FKModuleToolbarItem * aToolbarItem = [clippedItems objectAtIndex:[sender tag]];
		
	[[aToolbarItem toolbar] toolbarItemClicked:aToolbarItem];
}

- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)untilMouseUp
{
	NSRect menuRect = cellFrame;
	
	menuRect.origin.x += menuRect.size.width + 12.0;
	menuRect.origin.y += 1.0;
	
	return [super trackMouse:theEvent inRect:menuRect ofView:[self controlView] untilMouseUp:NO];
}

- (void)removeItemWithTag:(int)aTag
{
	NSMenu * menu = [self menu];
	NSMenuItem * item = [menu itemWithTag:aTag];
	
	if ( item )
	{
		[menu removeItem:item];
	}
}

#pragma mark -
#pragma mark LAYOUT

- (void)calculateLayout {}

#pragma mark -
#pragma mark DRAWING

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[self drawInteriorWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	NSSize chevronsSize = [self chevronsSize];
	NSRect chevronsRect = NSZeroRect;
	
	chevronsRect.origin.x = floor((NSWidth(cellFrame) - chevronsSize.width) / 2.0) + 1.0; // + 1.0 pour l'esthetique
	chevronsRect.origin.y = floor((NSHeight(cellFrame) - chevronsSize.height) / 2.0);
	chevronsRect.size = chevronsSize;
	
	[self drawChevronsWithFrame:chevronsRect inView:controlView];
}

- (void)drawChevronsWithFrame:(NSRect)chevronsFrame inView:(NSView *)controlView {
	// Initialisation des variables
	
	NSAffineTransform * transform = nil;
	
	[NSGraphicsContext saveGraphicsState];
	
	[self.foreColor set];
	[self.shadow set];
	
	// ...
	
	NSBezierPath * chevronPath = [NSBezierPath bezierPath];
	NSPoint p1, p2, p3, p4, p5, p6;
	
	p1 = chevronsFrame.origin;
	
	p2.x = p1.x + 4.0; p2.y = p1.y;
	p3.x = p2.x + 4.0; p3.y = p2.y + ceil(NSHeight(chevronsFrame) / 2.0) - 0.5;
	p4.x = p2.x; p4.y = p3.y + ceil(NSHeight(chevronsFrame) / 2.0) - 0.5;
	p5.x = p1.x; p5.y = p4.y;
	p6.x = p2.x; p6.y = p3.y;
	
	[chevronPath moveToPoint:p1];
	[chevronPath lineToPoint:p2];
	[chevronPath lineToPoint:p3];
	[chevronPath lineToPoint:p4];
	[chevronPath lineToPoint:p5];
	[chevronPath lineToPoint:p6];
	[chevronPath closePath];
	
	// Chevron gauche
	
	transform = [NSAffineTransform transform];
	
	[chevronPath fill];	
	
	// Chevron droit
	
	transform = [NSAffineTransform transform];
	
	[transform translateXBy:6.0 yBy:0.0];
	
	[chevronPath transformUsingAffineTransform:transform];
	
	[chevronPath fill];
	
	[NSGraphicsContext restoreGraphicsState];
}

@end
