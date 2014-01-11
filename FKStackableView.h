//
//  FKStackableView.h
//  ShoppingBag
//
//  Created by Eric on 09/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKView.h"

extern NSString * FKStackableViewWillCollapseNotification;
extern NSString * FKStackableViewDidCollapseNotification;
extern NSString * FKStackableViewWillExpandNotification;
extern NSString * FKStackableViewDidExpandNotification;

@class FKStackView;

@interface FKStackableView : FKView
{
	NSString *			title;
	NSImage *			image;
	
	BOOL				isCollapsed;
	
	NSScrollView *		scrollView;
	
	NSTrackingRectTag	trackingRectTag;
	
	// ...
	
	FKStackView *		stackView; // Not retained
	
	// Optimisations :
	
	NSRect				backgroundRect;
	NSRect				headerRect;
	NSRect				topSeparatorRect;
	NSRect				bottomSeparatorRect;
	NSRect				footerRect;
	
	// Layout
	
	NSSize				insetDeltas;
	
	float				collapsedHeight;
	float				expandedHeight;
	float				expandedHeaderHeight;
	float				expandedFooterHeight;
}

- (NSString *)title;
- (BOOL)isCollapsed;
- (float)collapsedHeight;

- (void)setTitle:(NSString *)aString;
- (void)setImage:(NSImage *)anImage;
- (void)setCollapsed:(BOOL)aBool;
- (void)setScrollView:(NSScrollView *)aView;
- (void)setStackView:(FKStackView *)aView;

@property (getter=isCollapsed,setter=setCollapsed:) BOOL				isCollapsed;
@property NSTrackingRectTag	trackingRectTag;
@property (assign,setter=setStackView:) FKStackView *		stackView;
@property (getter=collapsedHeight) float				collapsedHeight;
@property float				expandedHeight;
@property float				expandedHeaderHeight;
@property float				expandedFooterHeight;
@end
