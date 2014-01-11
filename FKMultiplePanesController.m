//
//  FKMultiplePanesController.m
//  FKKit
//
//  Created by Eric on 31/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKMultiplePanesController.h"

NSString * FKMultiplePanesControllerLastPanelIdentifierKey = @"%@MultiplePanesController.LastPanelIdentifier";
NSString * FKMultiplePanesControllerWindowFrameAutosaveName = @"%@MultiplePanesController.WindowFrameAutosaveName";

@interface FKMultiplePanesController (Private)

- (NSString *)lastPanelIdentifierKey;

@end

@implementation FKMultiplePanesController

- (id)initWithIdentifier:(NSString *)anIdentifier
{
	self = [super initWithWindowNibName:anIdentifier];
		
	if ( self )
	{
		[self setShouldCascadeWindows:NO];
		
		[self setPaneViewsArray:[NSMutableArray array]];
		[self setPaneIdentifiersArray:[NSMutableArray array]];
		[self setIdentifier:anIdentifier];
		
		needsReload = YES;
	}
	
	return self;
}

- (void)dealloc
{
	[self setPaneViewsArray:nil];
	[self setPaneIdentifiersArray:nil];
	[self setIdentifier:nil];
	
	[super dealloc];
}

- (void)awakeFromNib
{
	NSWindow * window = [self window];
	
	[window setDelegate:self];
	[window setFrameAutosaveName:[self windowFrameAutosaveName]];
	
	// ...
		
	NSView * paneView = nil;
	NSString * paneIdentifier = nil;
	
	NSRect windowFrame = [window frame];	
	
	int i = 0;
	int numberOfPanes = [self numberOfPanes];
	
	maxWidth = 0.0;	
	
	for ( i = 0; i < numberOfPanes; i++ )
	{
		paneIdentifier = [self identifierForPaneAtIndex:i];

		if ( nil != paneIdentifier )
		{
			[paneIdentifiersArray addObject:paneIdentifier];
		
			paneView = [self viewForPaneAtIndex:i];
			
			if ( nil != paneView )
			{
				[paneView setFrameWidth:MIN(NSWidth([paneView frame]), NSWidth(windowFrame))];
				[paneView setFrameHeight:MIN(NSHeight([paneView frame]), NSHeight(windowFrame))];
				
				[paneViewsArray addObject:paneView];
			}
			else
			{
				[paneViewsArray addObject:[NSNull null]];
			}
		}
	}
	
	// ...
	
    NSToolbar * aToolbar = [window toolbar];
	NSString * lastItemIdentifier = nil;
	
	if ( !aToolbar )
	{
		aToolbar = [[[NSToolbar alloc] initWithIdentifier:[NSString stringWithFormat:@"%@MultiplePanesControllerToolbar", identifier]] autorelease];
	}
	
    [aToolbar setDelegate:self];
    [aToolbar setAutosavesConfiguration:YES];
    
    [[self window] setToolbar:aToolbar];
	
	lastItemIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:[self lastPanelIdentifierKey]];
	
	if ( ( nil == lastItemIdentifier ) || ( ![paneIdentifiersArray containsObject:lastItemIdentifier] ) )
	{
		lastItemIdentifier = [paneIdentifiersArray objectAtIndex:0];
	}
	
	[aToolbar setSelectedItemIdentifier:lastItemIdentifier];
	
	[self switchPane:[self toolbar:aToolbar itemForItemIdentifier:lastItemIdentifier willBeInsertedIntoToolbar:NO]];
}

#pragma mark -
#pragma mark GETTERS

- (int)numberOfPanes {return 0;}
- (NSView *)viewForPaneAtIndex:(int)paneIndex {return nil;}
- (NSString *)identifierForPaneAtIndex:(int)paneIndex {return nil;}
- (BOOL)showsResizeIndicatorForPaneAtIndex:(int)paneIndex {return YES;}

- (NSSize)contentMinSizeForPaneAtIndex:(int)paneIndex
{
	return NSMakeSize(0.0, 0.0);
}

- (NSSize)contentMaxSizeForPaneAtIndex:(int)paneIndex
{
	return NSMakeSize(800.0, 800.0);
}

- (NSString *)lastPanelIdentifierKey
{
	return [NSString stringWithFormat:FKMultiplePanesControllerLastPanelIdentifierKey, identifier];
}

- (NSString *)windowFrameAutosaveName
{
	return [NSString stringWithFormat:FKMultiplePanesControllerWindowFrameAutosaveName, identifier];
}

#pragma mark -
#pragma mark SETTERS

- (void)setPaneViewsArray:(NSMutableArray *)anArray
{
	if ( anArray != paneViewsArray )
	{
		[paneViewsArray release];
		paneViewsArray = [anArray retain];
	}
}

- (void)setPaneIdentifiersArray:(NSMutableArray *)anArray
{
	if ( anArray != paneIdentifiersArray )
	{
		[paneIdentifiersArray release];
		paneIdentifiersArray = [anArray retain];
	}
}

- (void)setIdentifier:(NSString *)aString
{
	if ( aString != identifier )
	{
		[identifier release];
		identifier = [aString retain];
	}
}

- (void)switchPane:(id)sender
{	
	NSToolbarItem * toolbarItem = sender;
	NSString * paneIdentifier = [toolbarItem itemIdentifier];
	
	NSWindow * window = [self window];
	NSView * paneView = nil;
	
	int paneIndex = [paneIdentifiersArray indexOfObject:paneIdentifier];
	
	paneView = [paneViewsArray objectAtIndex:paneIndex];
	
	if ( ( nil != paneView ) && ( [window contentView] != paneView ) )
	{
		[window setContentView:[[[NSView alloc] initWithFrame:NSZeroRect] autorelease]];
		
		NSRect windowFrame = [NSWindow contentRectForFrameRect:[window frame] styleMask:[window styleMask]];
		
		float newHeight = NSHeight(windowFrame) - NSHeight([[window contentView] frame]) + NSHeight([paneView bounds]);
		float newWidth = NSWidth([paneView bounds]);
		
		windowFrame.origin.y += windowFrame.size.height;
		windowFrame.origin.y -= newHeight;
		windowFrame.size.height = newHeight;
		windowFrame.size.width = newWidth;
		
		windowFrame = [NSWindow frameRectForContentRect:windowFrame styleMask:[window styleMask]];
		
		BOOL paneIsResizable = [self showsResizeIndicatorForPaneAtIndex:paneIndex];
		
		[window setShowsResizeIndicator:paneIsResizable];
		[[window standardWindowButton:NSWindowZoomButton] setEnabled:paneIsResizable];
		
		[window setContentMinSize:[self contentMinSizeForPaneAtIndex:paneIndex]];
		//[window setContentMaxSize:[self contentMaxSizeForPaneAtIndex:paneIndex]];
		[window setFrame:windowFrame display:YES animate:YES];
		[window setContentView:paneView];
		[window setTitle:[toolbarItem label]];
		
		[[NSUserDefaults standardUserDefaults] setValue:paneIdentifier forKey:[self lastPanelIdentifierKey]];
	}
}

#pragma mark -
#pragma mark NSToolbar Delegate

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	NSToolbarItem * anItem = [[NSToolbarItem alloc] initWithItemIdentifier:anItemIdentifier];
	NSString * localizedLabel = nil;
	
	localizedLabel = NSLocalizedString(anItemIdentifier, @"");
	
	[anItem setImage:[NSImage imageNamed:anItemIdentifier]];
	[anItem setLabel:localizedLabel];
	[anItem setTarget:self];
	[anItem setAction:@selector(switchPane:)];	
	
	return anItem;
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar*)toolbar
{
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{	
    return paneIdentifiersArray;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

#pragma mark -
#pragma mark NSTableView DELEGATE

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(int)rowIndex
{	
	[aCell setFont:[NSFont systemFontOfSize:[NSFont smallSystemFontSize]]];	
}

@synthesize delegate;
@synthesize needsReload;
@synthesize maxWidth;
@end
