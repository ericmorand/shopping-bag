//
//  FKTabView.h
//  FKKit
//
//  Created by alt on 01/11/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FKTabViewItem;

typedef enum _FKTabViewAlignment {
	FKTabViewLeftAlignment = 0,
	FKTabViewCenterAlignment = 1,
	FKTabViewRightAlignment = 2
} FKTabViewAlignment;

@interface FKTabView : NSView
{
	FKView *				placeholderView;
	
	// ...
	
	NSMutableArray *		tabViewItems;
	NSMutableArray *		tabViewItemRects;
	
    FKTabViewItem *			selectedTabViewItem; // Weak reference
    FKTabViewItem *			pressedTabViewItem; // Weak reference
	FKTabViewItem *			mouseOverTabViewItem; // Weak reference
	
	NSDictionary *			labelAttributes;
	
	NSRect					tabsAreaRect; // Zone disponible pour dessiner les onglets
	NSRect					tabsUnionRect; // Zone effectivement couverte par les onglets
	NSRect					placeholderRect;	
	
	float					tabHeight;
	float					labelMargin;
	float					commonWidth;
	float					tabsAreaHeight;
	float					interItemsMargin;
	
	id						delegate; // Weak reference
	
	FKTabViewAlignment		alignment;
	
	BOOL					needsReload;
}

- (int)numberOfTabViewItems;
- (NSRect)tabRectForTabViewItem:(FKTabViewItem *)anItem;
- (int)indexOfTabViewItem:(FKTabViewItem *)tabViewItem;

- (void)setPlaceholderView:(FKView *)aView;
- (void)setTabViewItems:(NSMutableArray *)anArray;
- (void)setTabViewItemRects:(NSMutableArray *)anArray;
- (void)setLabelAttributes:(NSDictionary *)aDictionary;
- (void)setDelegate:(id)anObject;
- (void)setAlignment:(FKTabViewAlignment)anInt;

- (void)reloadData;
- (void)addTabViewItem:(FKTabViewItem *)tabViewItem;
- (void)selectTabViewItem:(FKTabViewItem *)tabViewItem;
- (void)selectTabViewItemAtIndex:(int)index;
- (void)selectTabViewItemWithIdentifier:(NSString *)identifier;
- (void)updateCommonWidthWithNewTabViewItem:(FKTabViewItem *)anItem;

- (void)setupLayout;
- (void)tile;
- (void)drawTabViewItem:(FKTabViewItem *)anItem;

@property (nonatomic, retain) FKView *			placeholderView;
@property (nonatomic, retain) NSMutableArray *	tabViewItems;
@property (nonatomic, retain) NSMutableArray *	tabViewItemRects;
@property (nonatomic, retain) FKTabViewItem *	selectedTabViewItem;
@property (nonatomic, retain) FKTabViewItem *	pressedTabViewItem;
@property (nonatomic, retain) FKTabViewItem *	mouseOverTabViewItem;
@property (nonatomic, retain) NSDictionary *	labelAttributes;
@property float									tabHeight;
@property float									labelMargin;
@property float									commonWidth;
@property float									tabsAreaHeight;
@property float									interItemsMargin;
@property (assign,setter=setDelegate:) id		delegate;
@property (assign) FKTabViewAlignment			alignment;
@property (assign) BOOL							needsReload;
@end

@interface NSObject (FKTabViewDelegate)

- (NSUInteger)fkTabViewNumberOfItems:(FKTabView *)aTabView;
- (NSString *)fkTabView:(FKTabView *)aTabView identifierForItemAtIndex:(NSUInteger)itemIndex;
- (NSView *)fkTabView:(FKTabView *)aTabView viewForItemAtIndex:(NSUInteger)itemIndex;
- (NSString *)fkTabView:(FKTabView *)aTabView labelForItemAtIndex:(NSUInteger)itemIndex;
- (BOOL)fkTabView:(FKTabView *)tabView shouldSelectTabViewItem:(FKTabViewItem *)tabViewItem;
- (void)fkTabView:(FKTabView *)tabView willSelectTabViewItem:(FKTabViewItem *)tabViewItem;
- (void)fkTabView:(FKTabView *)tabView didSelectTabViewItem:(FKTabViewItem *)tabViewItem;
- (void)fkTabViewDidChangeNumberOfTabViewItems:(FKTabView *)tabView;

@end
