//
//  FKModuleToolbar.m
//  FKKit
//
//  Created by Alt on 19/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleToolbar.h"
#import "FKModuleToolbarButton.h"
#import "FKModuleToolbarSeparator.h"
#import "FKModuleToolbarSeparatorItem.h"
#import "FKModuleToolbarSpaceItem.h"
#import "FKModuleToolbarClipIndicator.h"
#import "FKModuleToolbarClipIndicatorCell.h"

@interface FKModuleToolbar (Private)

- (NSString *)configurationAutosavingKey;
- (id)plistObjectWithConfiguration;
- (float)availableWidth;

- (FKModuleToolbarItem *)itemWithIdentifier:(NSString *)itemIdentifier forAreaAtIndex:(int)areaIndex;
- (NSString *)selectedItemIdentifierForAreaAtIndex:(int)areaIndex;

- (void)refreshVisibleItems;
- (void)validateCurrentItems;
- (FKModuleToolbarItem *)findFirstVisibleItemWithIdentifier:(NSString *)anIdentifier;

- (void)addToolbarItem:(FKModuleToolbarItem *)anItem inArea:(int)areaIndex;

- (void)tile;
- (void)frameWidthDidChange;
- (void)frameHeightDidChange;

- (void)saveConfiguration;
- (BOOL)restoreSavedConfiguration;
- (void)restoreConfigurationFromPlistObject:(id)plistObject;

- (int)askDelegateForNumberOfAreas;
- (NSArray *)askDelegateForItemIdentifiersForAreaAtIndex:(int)anIndex;
- (FKModuleToolbarItem *)askDelegateForItemForItemIdentifier:(NSString *)itemIdentifier forAreaAtIndex:(int)anIndex;
- (NSArray *)askDelegateForSelectableItemIdentifiersForAreaAtIndex:(int)anIndex;

@end

@implementation FKModuleToolbar

@synthesize identifier;
@synthesize selectableItemIdentifiers;
@synthesize selectedItemIdentifiers;
@synthesize currentItems;
@synthesize visibleItems;
@synthesize delegate;
@synthesize horizontalMargin;
@synthesize interItemsMargin;
@synthesize separatorToItemMargin;
@synthesize widthToFitAllItems;
@synthesize itemViewOriginX;
@synthesize numberOfAreas;
@synthesize clipIndicator;
@synthesize isClipIndicatorVisible;
@synthesize needsReload;
@synthesize autosavesConfiguration;
@synthesize iconHeight;
@synthesize itemHeight;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
	
    if (nil != self) {
		self.currentItems = [NSMutableArray array];
		self.visibleItems = [NSMutableArray array];
		self.selectedItemIdentifiers = [NSMutableDictionary dictionary];
		
		self.horizontalMargin = 12.0;
		self.interItemsMargin = 20.0;
		self.iconHeight = 32.0;
		self.itemHeight = 48.0;
					
		self.clipIndicator = [[[[self clipIndicatorClass] alloc] initWithFrame:NSZeroRect] autorelease];
		
		[clipIndicator setToolbar:self];
		[clipIndicator sizeToFit];
		
		needsReload = NO;
    }
	
    return self;
}

- (void)dealloc {
	self.currentItems = nil;
	self.selectableItemIdentifiers = nil;
	self.clipIndicator = nil;
	
	[super dealloc];
}

- (void)viewWillMoveToWindow:(NSWindow *)newWindow {
	NSWindow * oldWindow = [self window];
	
	if (oldWindow) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSWindowDidUpdateNotification object:oldWindow];
	}
	
	if (newWindow) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidUpdate:) name:NSWindowDidUpdateNotification object:newWindow];
	}
}

#pragma mark -
#pragma mark GETTERS

- (float)widthToFitAllItems {
	if (needsReload) {
		[self reloadData];
	}
	
	return widthToFitAllItems;
}

- (Class)buttonClass {
	return [FKModuleToolbarButton class];
}

- (Class)clipIndicatorClass {
	return [FKModuleToolbarClipIndicator class];
}

- (BOOL)isSelectableItemWithIdentifier:(NSString *)itemIdentifier forAreaAtIndex:(int)areaIndex {
	BOOL isSelectable = NO;
	
	NSArray * selectedItemIdentifiersArray = [selectableItemIdentifiers objectForKey:[NSNumber numberWithInt:areaIndex]];
	
	isSelectable = [selectedItemIdentifiersArray containsObject:itemIdentifier];
	
	return isSelectable;
}

- (float)availableWidth {
	return NSWidth([self bounds]);
}

- (FKModuleToolbarItem *)findFirstVisibleItemWithIdentifier:(NSString *)anIdentifier; {
	for (FKModuleToolbarItem * anItem in visibleItems) {
		if ([[anItem itemIdentifier] isEqualToString:anIdentifier]) {
			return anItem;
		}
	}
	
	return nil;
}

- (NSMutableDictionary *)labelStringAttributes {
	NSMutableParagraphStyle * style = [[[NSMutableParagraphStyle alloc] initWithAlignment:NSCenterTextAlignment] autorelease];
	
	[style setLineBreakMode:NSLineBreakByWordWrapping];
	
	return [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:11.0], NSFontAttributeName, style, NSParagraphStyleAttributeName, nil];	
}

- (NSString *)selectedItemIdentifierForAreaAtIndex:(int)areaIndex {
	return [selectedItemIdentifiers objectForKey:[NSNumber numberWithInt:areaIndex]];
}

#pragma mark -
#pragma mark SETTERS

- (void)setFrameSize:(NSSize)newSize {
	NSSize oldSize = [self frame].size;
	
	[super setFrameSize:newSize];
	
	if (newSize.width != oldSize.width) {
		[self frameWidthDidChange];
	}	
	
	if (newSize.height != oldSize.height) {
		[self frameHeightDidChange];
	}
}

- (void)setIdentifier:(NSString *)aString {
	if (aString != identifier) {
		[identifier release];
		identifier = [aString retain];
				
		[self restoreSavedConfiguration];
	}
}

- (void)setDelegate:(id)anObject {
	if (anObject != delegate) {
		delegate = anObject;
		
		needsReload = YES;
	}
}

- (void)setSelectedItemIdentifier:(NSString *)itemIdentifier forAreaAtIndex:(int)areaIndex {	
	if (needsReload) {
		[self reloadData];
	}
		
	FKModuleToolbarItem * selectedItem = nil;
	NSNumber * areaIndexAsNumber = nil;
		
	areaIndexAsNumber = [NSNumber numberWithInt:areaIndex];
	
	if ([self isSelectableItemWithIdentifier:itemIdentifier forAreaAtIndex:areaIndex]) {
		if (itemIdentifier != [self selectedItemIdentifierForAreaAtIndex:areaIndex]) {
			[selectedItemIdentifiers setObject:itemIdentifier forKey:areaIndexAsNumber];
			
			selectedItem = [self itemWithIdentifier:itemIdentifier forAreaAtIndex:areaIndex];
			
			for (FKModuleToolbarItem * anItem in currentItems) {
				if ([anItem toolbarAreaIndex] == areaIndex) {
					[anItem setSelected:(anItem == selectedItem)];
					[[anItem view] setNeedsDisplay:YES];
				}
			}
			
			// Action !!!
			
			if ([selectedItem action] != nil) {
				[[selectedItem target] performSelector:[selectedItem action] withObject:selectedItem];
			}
			
			if ([clipIndicator superview] == self) {
				[clipIndicator setNeedsDisplay:YES];
			}
			
			[self saveConfiguration];
		}
	}
}

#pragma mark -
#pragma mark LAYOUT & DRAWING

- (void)reloadData {
	FKModuleToolbarItem * anItem = nil;
	id anItemView = nil;
	
	for (anItem in visibleItems) {
		anItemView = [anItem view];
		
		[anItemView removeFromSuperview];
	}
	
	// ...
		
	[currentItems removeAllObjects];
	
	numberOfAreas = [self askDelegateForNumberOfAreas];
	
	int areaIndex = 0;
	
	NSMutableDictionary * aDictionary = [NSMutableDictionary dictionary];
	
	itemViewOriginX = interItemsMargin;
	
	for (areaIndex = 0; areaIndex < numberOfAreas; areaIndex++) {
		NSArray * itemIdentifiers = [self askDelegateForItemIdentifiersForAreaAtIndex:areaIndex];
		NSArray * selectableItemIdentifiersArray = [self askDelegateForSelectableItemIdentifiersForAreaAtIndex:areaIndex];
		
		if (selectableItemIdentifiersArray) {
			[aDictionary setObject:selectableItemIdentifiersArray forKey:[NSNumber numberWithInt:areaIndex]];
		}
		
		if ([itemIdentifiers count] > 0){
			for (NSString * anItemIdentifier in itemIdentifiers) {
				if ([anItemIdentifier isEqualToString:FKModuleToolbarSeparatorItemIdentifier]) {
					anItem = [[[FKModuleToolbarSeparatorItem alloc] initWithItemIdentifier:anItemIdentifier] autorelease];
				}
				else {
					anItem = [self askDelegateForItemForItemIdentifier:anItemIdentifier forAreaAtIndex:areaIndex];
				}
				
				if (anItem) {					
					[self addToolbarItem:anItem inArea:areaIndex];
				}
			}
		}
		
		if ((areaIndex + 1) < numberOfAreas) {
			anItem = [[[FKModuleToolbarSeparatorItem alloc] initWithItemIdentifier:FKModuleToolbarSeparatorItemIdentifier] autorelease];
			
			[self addToolbarItem:anItem inArea:areaIndex];
		}
	}
			
	self.selectableItemIdentifiers = [NSDictionary dictionaryWithDictionary:aDictionary];
	
	[self tile];
	
	self.needsReload = NO;
		
	[self validateCurrentItems];
	[self restoreSavedConfiguration];
}

- (void)addToolbarItem:(FKModuleToolbarItem *)anItem inArea:(int)areaIndex {
	[anItem setToolbar:self];
	[anItem setToolbarAreaIndex:areaIndex];
	
	[currentItems addObject:anItem];
}

- (void)refreshVisibleItems {
	[visibleItems removeAllObjects];
	
	float availableWidth = NSWidth([self bounds]);	
	
	FKModuleToolbarItem * anItem = nil;
	id anItemView = nil;
	
	
	BOOL enoughRoom = YES;
	
	// On commence par determiner s'il y a assez de place pour faire
	// rentrer tous les items dans la barre d'outils
	
	enoughRoom = (widthToFitAllItems <= availableWidth);
	
	// S'il n'y a pas assez de place, on determine les items visibles
	// en tenant compte de la largeur du "clip indicator" et de la marge
	// qui doit le separer du bord droit de la barre d'outils

	if (!enoughRoom) {		
		availableWidth -= NSWidth([clipIndicator frame]) + interItemsMargin;
	}
			
	for (anItem in currentItems) {
		anItemView = [anItem view];
		
		if ((NSMaxX([anItemView frame]) + interItemsMargin) <= availableWidth) {			
			[visibleItems addObject:anItem];
		}
		else {
			break;
		}
	}
}

- (void)frameWidthDidChange {
	[self tile];
}

- (void)tile {
	int i = 0;
		
	FKModuleToolbarItem * anItem = nil;
	id anItemView = nil;
	
	NSRect selfFrame = [self frame];
	NSRect viewFrame = NSZeroRect;
	
	// Layout
	
	widthToFitAllItems = 0.0;
	
	itemViewOriginX = interItemsMargin;
	
	for ( i = 0; i < [currentItems count]; i++ )
	{
		anItem = [currentItems objectAtIndex:i];
		anItemView = [anItem view];
		
		if ( ( [anItemView isKindOfClass:[FKModuleToolbarButton class]] ) && ( [anItemView respondsToSelector:@selector(sizeToFit)] ) )
		{
			[anItemView sizeToFit];
		}
		
		viewFrame = [anItemView frame];
		
		//viewFrame.size.height = [self itemHeight];
		viewFrame.origin.x = itemViewOriginX;
		viewFrame.origin.y = floor((NSHeight(selfFrame) - NSHeight(viewFrame)) / 2.0) + 0.0;
				
		[anItemView setFrame:viewFrame];
		
		itemViewOriginX += NSWidth([anItemView frame]) + interItemsMargin;
	}
	
	widthToFitAllItems = itemViewOriginX;
	
	// Items visibles
	
	[self refreshVisibleItems];
		
	for (i = 0; i < [visibleItems count]; i++) {
		anItem = [visibleItems objectAtIndex:i];
		anItemView = [anItem view];
			
		if ([anItemView superview] != self) {
			[self addSubview:anItemView];
		}
	}
			
	// Overflow...
	
	NSPoint clipOrigin = NSZeroPoint;
	
	if (i < [currentItems count]) {
		anItem = [currentItems objectAtIndex:i];
		anItemView = [anItem view];
		
		clipOrigin.x = NSMinX([anItemView frame]);
		clipOrigin.y = floor((NSHeight([self frame]) - NSHeight([clipIndicator frame])) / 2.0);
		
		[clipIndicator setFrameOrigin:clipOrigin];
		
		[self addSubview:clipIndicator];
		
		NSMutableArray * clippedItems = [NSMutableArray array];
		
		for (i; i < [currentItems count]; i++) {
			anItem = [currentItems objectAtIndex:i];
			anItemView = [anItem view];
		
			[clippedItems addObject:anItem];
			
			if ([anItemView superview] == self) {			
				[anItemView removeFromSuperview];
			}
		}
		
		[[clipIndicator cell] setClippedItems:[NSArray arrayWithArray:clippedItems]];
	}
	else {
		[clipIndicator removeFromSuperview];
	}
	
	[self setNeedsDisplay:YES];
}

- (void)frameHeightDidChange {
	id anItemView = nil;
	
	NSRect selfFrame = [self frame];
	
	for (FKModuleToolbarItem * anItem in currentItems) {		
		anItemView = [anItem view];
		
		[anItemView setFrameY:floor((NSHeight(selfFrame) - NSHeight([anItemView frame])) / 2.0)];
	}
}

#pragma mark -
#pragma mark ACTIONS

- (FKModuleToolbarItem *)itemWithIdentifier:(NSString *)itemIdentifier forAreaAtIndex:(int)areaIndex
{
	FKModuleToolbarItem * anItem = nil;
	
	
	for ( anItem in currentItems )
	{
		
		if ( ( [[anItem itemIdentifier] isEqualToString:itemIdentifier] ) && ( [anItem toolbarAreaIndex] == areaIndex ) )
		{
			break;
		}
	}
	
	return anItem;
}

- (void)toolbarItemClicked:(id)sender {
	FKModuleToolbarItem * clickedItem = nil;
	NSString * itemIdentifier = nil;
	
	int areaIndex = -1;
	
	if ([sender isKindOfClass:[FKModuleToolbarItem class]]) {
		clickedItem = (FKModuleToolbarItem *)sender;
		itemIdentifier = [clickedItem itemIdentifier];
		areaIndex = [clickedItem toolbarAreaIndex];
		
		if ([self isSelectableItemWithIdentifier:itemIdentifier forAreaAtIndex:areaIndex]) {
			[self setSelectedItemIdentifier:itemIdentifier forAreaAtIndex:areaIndex];
		}
		else {
			[[clickedItem target] performSelector:[clickedItem action] withObject:clickedItem];
		}
	}
}

#pragma mark -
#pragma mark NOTIFICATIONS

- (void)windowDidUpdate:(NSNotification *)aNotification
{	
	if ( needsReload )
	{
		[self reloadData];
	}
	
	[self performSelector:@selector(validateCurrentItems) withObject:nil afterDelay:0];
}

#pragma mark -
#pragma mark VALIDATIONS

- (void)validateCurrentItems
{	
	FKModuleToolbarItem * anItem = nil;
	
	for ( anItem in currentItems )
	{
		[anItem update];
	}
	
	if ( [clipIndicator superview] == self )
	{
		[clipIndicator setNeedsDisplay:YES];
	}
}

#pragma mark -
#pragma mark DELEGATE METHODS

- (int)askDelegateForNumberOfAreas
{
	if ( [delegate respondsToSelector:@selector(moduleToolbarNumberOfAreas:)] )
	{
		return [delegate moduleToolbarNumberOfAreas:self];
	}
	
	return 0;
}

- (NSArray *)askDelegateForItemIdentifiersForAreaAtIndex:(int)areaIndex
{
	if ( [delegate respondsToSelector:@selector(moduleToolbarItemIdentifiers:forAreaAtIndex:)] )
	{
		return [delegate moduleToolbarItemIdentifiers:self forAreaAtIndex:areaIndex];
	}
	
	return nil;	
}

- (FKModuleToolbarItem *)askDelegateForItemForItemIdentifier:(NSString *)itemIdentifier forAreaAtIndex:(int)areaIndex
{
	if ( [delegate respondsToSelector:@selector(moduleToolbar:itemForItemIdentifier:forAreaAtIndex:)] )
	{
		return [delegate moduleToolbar:self itemForItemIdentifier:itemIdentifier forAreaAtIndex:areaIndex];
	}
	
	return nil;		
}

- (NSArray *)askDelegateForSelectableItemIdentifiersForAreaAtIndex:(int)areaIndex;
{
	if ( [delegate respondsToSelector:@selector(moduleToolbarSelectableItemIdentifiers:forAreaAtIndex:)] )
	{
		return [delegate moduleToolbarSelectableItemIdentifiers:self forAreaAtIndex:areaIndex];
	}
	
	return nil;
}

#pragma mark -
#pragma mark AUTOSAVING

static NSString * savedConfigurationSelectedItemIdentifiersKey = @"selectedItemIdentifiers";

- (void)saveConfiguration
{
	id object = [self plistObjectWithConfiguration];
	
	NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];

	[userDefaults setObject:object forKey:[self configurationAutosavingKey]];
}

- (BOOL)restoreSavedConfiguration
{
    BOOL result;
    id object;
	
	NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
	
    object = [userDefaults objectForKey:[self configurationAutosavingKey]];
	
    if (object)
    {
        [self restoreConfigurationFromPlistObject:object];
       
		result = YES;
    }
    else
    {
        result = NO;
    }
	
    return result;
}

- (void)restoreConfigurationFromPlistObject:(id)plistObject
{
    if ( [plistObject isKindOfClass:[NSDictionary class]] )
    {
        NSDictionary * configurationDict = (NSDictionary *)plistObject;
        		
		NSArray * itemIdentifiersArray = nil;
		NSString * anItemIdentifier = nil;
		int areaIndex = 0;
		
		itemIdentifiersArray = [configurationDict objectForKey:savedConfigurationSelectedItemIdentifiersKey];
		
		for ( areaIndex = 0; areaIndex < [itemIdentifiersArray count]; areaIndex++ )
		{
			anItemIdentifier = [itemIdentifiersArray objectAtIndex:areaIndex];
			
			[self setSelectedItemIdentifier:anItemIdentifier forAreaAtIndex:areaIndex];
		}
	}
}

- (id)plistObjectWithConfiguration
{
	NSMutableDictionary * plistObject = [NSMutableDictionary dictionary];
		
	NSArray * itemIdentifiers = [selectedItemIdentifiers allValues];
	
	[plistObject setObject:itemIdentifiers forKey:savedConfigurationSelectedItemIdentifiersKey];
	
	return plistObject;
}

- (NSString *)configurationAutosavingKey
{
    return [NSString stringWithFormat:@"FKModuleToolbar Configuration %@", identifier];
}

@end
