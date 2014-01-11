//
//  FKModuleToolbar.h
//  FKKit
//
//  Created by Alt on 19/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class FKModuleToolbarItem;
@class FKModuleToolbarButton;
@class FKModuleToolbarClipIndicator;

@interface FKModuleToolbar : NSView {
	NSString *						identifier;
	NSDictionary *					selectableItemIdentifiers;
	NSMutableDictionary *			selectedItemIdentifiers;
	NSMutableArray *				currentItems;
	NSMutableArray *				visibleItems;
	id								delegate;
	float							horizontalMargin;
	float							interItemsMargin;
	float							separatorToItemMargin;
	float							widthToFitAllItems;
	float							itemViewOriginX;
	NSUInteger						numberOfAreas;
	FKModuleToolbarButton *			clipIndicator;
	BOOL							isClipIndicatorVisible;
	BOOL							needsReload;
	BOOL							autosavesConfiguration;
	float							iconHeight;
	float							itemHeight;
}

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDictionary * selectableItemIdentifiers;
@property (nonatomic, retain) NSMutableDictionary * selectedItemIdentifiers;
@property (nonatomic, retain) NSMutableArray * currentItems;
@property (nonatomic, retain) NSMutableArray * visibleItems;
@property (assign) id delegate;
@property float horizontalMargin;
@property float	interItemsMargin;
@property float	separatorToItemMargin;
@property float	widthToFitAllItems;
@property float	itemViewOriginX;
@property NSUInteger numberOfAreas;
@property (nonatomic, retain) FKModuleToolbarButton * clipIndicator;
@property (setter=setClipIndicatorVisible:) BOOL isClipIndicatorVisible;
@property BOOL needsReload;
@property BOOL autosavesConfiguration;
@property float	iconHeight;
@property float	itemHeight;

- (Class)buttonClass;
- (Class)clipIndicatorClass;
- (float)widthToFitAllItems;
- (NSMutableDictionary *)labelStringAttributes;

- (void)setSelectedItemIdentifier:(NSString *)itemIdentifier forAreaAtIndex:(int)areaIndex;
- (BOOL)isSelectableItemWithIdentifier:(NSString *)itemIdentifier forAreaAtIndex:(int)areaIndex;

- (void)reloadData;
- (void)tile;

- (void)toolbarItemClicked:(id)sender;

@end

@interface NSObject (FKModuleToolbarDelegate)

- (int)moduleToolbarNumberOfAreas:(FKModuleToolbar *)aToolbar;
- (NSArray *)moduleToolbarItemIdentifiers:(FKModuleToolbar *)aToolbar forAreaAtIndex:(int)areaIndex;
- (FKModuleToolbarItem *)moduleToolbar:(FKModuleToolbar *)aToolbar itemForItemIdentifier:(NSString *)anItemIdentifier forAreaAtIndex:(int)areaIndex;
- (NSArray *)moduleToolbarSelectableItemIdentifiers:(FKModuleToolbar *)aToolbar forAreaAtIndex:(int)areaIndex;

@end