//
//  FKView.h
//  ShoppingBag
//
//  Created by Eric on 10/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKFocusView.h"

@interface FKView : NSView
{
	NSColor *			backgroundColor;
	NSColor *			borderColor;
	NSView *			contentView; // Not retained
	
	FKFocusView *		focusView;
	
	NSSize				minSize;
	unsigned			borderMask;
	BOOL				isHighlighted;
	
	// Responder chain
	
	NSResponder *		firstResponder; // Not retained
	NSResponder *		lastResponder;	// Not retained
}

@property (nonatomic, retain) NSColor *	borderColor;
@property (nonatomic, retain) FKFocusView *	focusView;
@property (setter=setHighlighted:) BOOL	isHighlighted;
@property (assign) NSResponder *	firstResponder;
@property (assign) NSResponder *	lastResponder;

- (NSRect)contentFrame;
+ (NSSize)frameSizeForContentSize:(NSSize)contentSize;

- (NSSize)minSize;
- (NSResponder *)firstResponder;
- (NSResponder *)lastResponder;

- (void)setBackgroundColor:(NSColor *)aColor;
- (void)setMinSize:(NSSize)aSize;
- (void)setBorderMask:(unsigned)anInt;
- (void)setHighlighted:(BOOL)flag;

- (void)setContentView:(NSView *)aView;

- (void)setFirstResponder:(NSResponder *)aResponder;
- (void)setLastResponder:(NSResponder *)aResponder;

@end
