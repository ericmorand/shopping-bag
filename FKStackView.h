//
//  FKStackView.h
//  ShoppingBag
//
//  Created by Eric on 23/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKView.h"

@class FKStackableView;

@interface FKStackView : FKView
{
	NSMutableArray *		stackedViewsArray;	
	FKStackableView *		expandedView; // Not retained

	FKStackableView *		collapsingView;
	
	id						delegate;
	
	NSSize					interviewSpacing;
	
	BOOL					needsReload;
}

- (void)reloadData;
- (void)tile;

- (void)setStackedViewsArray:(NSMutableArray *)anArray;
- (void)setExpandedView:(FKStackableView *)aView;
- (void)setDelegate:(id)anObject;

- (void)expandStackedView:(FKStackableView *)stackedView updateFirstResponder:(BOOL)firstResponderFlag animate:(BOOL)animateFlag;
- (void)collapseStackedView:(FKStackableView *)stackedView;

@property (assign,setter=setExpandedView:) FKStackableView *		expandedView;
@property (retain) FKStackableView *		collapsingView;
@property BOOL					needsReload;
@end

@interface NSObject (FKStackViewDelegate)

- (unsigned)stackViewNumberOfStackedViews:(FKStackView *)aStackView;
- (NSView *)stackView:(FKStackView *)aStackView stackedViewAtIndex:(int)viewIndex;

@end