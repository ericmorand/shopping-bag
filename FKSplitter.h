//
//  FKSplitter.h
//  FK
//
//  Created by Eric on 11/09/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum {
	FKSplitterHandlePositionNone = 0,
	FKSplitterHandlePositionLeft,
	FKSplitterHandlePositionRight
} FKSplitterHandlePosition;

@interface FKSplitter : NSView
{
	NSImage *							spacerImage;
	NSImage *							handleImage;
	NSString *							title;
	
	NSSplitView *						splitView;	// Weak reference
	int									splitViewDivider;
	
	NSPoint								trackingStartPoint;
	float								trackingStartPosition;
	float								minConstrainedPosition;
	float								maxConstrainedPosition;
	
	// Arrow
	
	BOOL								arrowIsHighlighted;
	int									state;
	
	// Settings
	
	BOOL								splitsVertically;
	FKSplitterHandlePosition			handlePosition;
	
	// Target/Action
	
	id									target;
	
	SEL									action;
	SEL									doubleAction;
	SEL									handleAction;
	SEL									doubleHandleAction;
	
	// Drawing
	
	BOOL								tileSpacerImage;
}

+ (FKSplitter *)splitter;
+ (float)splitterHeight;
+ (NSImage *)standardSpacerImage;

- (float)height;
- (NSRect)handleRect;

- (void)setSpacerImage:(NSImage *)anImage;
- (void)setHandleImage:(NSImage *)anImage;
- (void)setTitle:(NSString *)aString;
- (void)setSplitView:(NSSplitView *)aView;
- (void)setSplitViewDivider:(int)anInt;
- (void)setTarget:(id)anObject;
- (void)setTileSpacerImage:(BOOL)aBool;

- (void)setAction:(SEL)aSelector;
- (void)setDoubleAction:(SEL)aSelector;
- (void)setHandleAction:(SEL)aSelector;
- (void)setDoubleHandleAction:(SEL)aSelector;

- (void)setSplitsVertically:(BOOL)flag;
- (void)setHandlePosition:(FKSplitterHandlePosition)aPosition;

@property (setter=setSplitViewDivider:) int									splitViewDivider;
@property float								trackingStartPosition;
@property float								minConstrainedPosition;
@property float								maxConstrainedPosition;
@property BOOL								arrowIsHighlighted;
@property int									state;
@property (setter=setSplitsVertically:) BOOL								splitsVertically;
@property (assign,setter=setTarget:) id									target;
@property (setter=setAction:) SEL									action;
@property (setter=setDoubleAction:) SEL									doubleAction;
@property (setter=setHandleAction:) SEL									handleAction;
@property (setter=setDoubleHandleAction:) SEL									doubleHandleAction;
@property (setter=setTileSpacerImage:) BOOL								tileSpacerImage;
@end
