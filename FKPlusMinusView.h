//
//  FKPlusMinusView.h
//  ShoppingBag
//
//  Created by Eric on 03/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FKPlusMinusViewButton;

@interface FKPlusMinusView : NSView
{
	FKPlusMinusViewButton *		plusButton;
	FKPlusMinusViewButton *		minusButton;
}

- (FKPlusMinusViewButton *)plusButton;
- (FKPlusMinusViewButton *)minusButton;

- (void)setTarget:(id)anObject;
- (void)setPlusAction:(SEL)aSelector;
- (void)setMinusAction:(SEL)aSelector;

@end

@interface FKPlusMinusViewButton : NSButton
{
}

@end

@interface FKPlusMinusViewButtonCell : NSButtonCell
{
	NSBezierPath *		backgroundPath;
	NSBezierPath *		borderPath;
	
	BOOL				isRightCornered;
}

- (void)setBackgroundPath:(NSBezierPath *)aPath;
- (void)setBorderPath:(NSBezierPath *)aPath;
- (void)setIsRightCornered:(BOOL)flag;

@property (setter=setIsRightCornered:) BOOL				isRightCornered;
@end