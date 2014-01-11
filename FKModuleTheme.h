//
//  FKModuleTheme.h
//  ShoppingBag
//
//  Created by Eric on 26/04/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKModuleTheme : NSObject
{
	NSColor *	topGradientStartColor;
	NSColor *	topGradientEndColor;
	NSColor *	bottomGradientStartColor;
	NSColor *	bottomGradientEndColor;
	
	NSColor *	borderColor;
	
	NSColor *	standardTextColor;
	NSColor *	highlightTextColor;
	NSColor *	backgroundTextColor;
	
	NSShadow *	standardTextShadow;
	NSShadow *	highlightTextShadow;
	
	NSFont *	textFont;
}

+ (FKModuleTheme *)currentTheme;
+ (void)setCurrentTheme:(FKModuleTheme *)aTheme;

+ (FKModuleTheme *)blueTheme;
+ (FKModuleTheme *)brownTheme;
+ (FKModuleTheme *)orangeTheme;
+ (FKModuleTheme *)purpleTheme;

- (NSColor *)backgroundStandardTextColor;
- (NSColor *)backgroundHighlightTextColor;

- (NSColor *)borderColor;
- (NSColor *)standardTextColor;
- (NSColor *)highlightTextColor;
- (NSColor *)backgroundTextColor;
- (NSShadow *)standardTextShadow;
- (NSShadow *)highlightTextShadow;
- (NSFont *)textFont;

- (void)setTopGradientStartColor:(NSColor *)aColor;
- (void)setTopGradientEndColor:(NSColor *)aColor;
- (void)setBottomGradientStartColor:(NSColor *)aColor;
- (void)setBottomGradientEndColor:(NSColor *)aColor;
- (void)setBorderColor:(NSColor *)aColor;
- (void)setStandardTextColor:(NSColor *)aColor;
- (void)setHighlightTextColor:(NSColor *)aColor;
- (void)setStandardTextShadow:(NSShadow *)aShadow;
- (void)setHighlightTextShadow:(NSShadow *)aShadow;
- (void)setTextFont:(NSFont *)aFont;

- (void)drawRectGradientInRect:(NSRect)aRect usingBorderMask:(unsigned int)borderMask;
- (void)drawGradientRoundedRect:(NSRect)aRect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask;

- (void)drawGradientPlateInRect:(NSRect)aRect inView:(NSView *)aView bezeled:(BOOL)isBezeled hollow:(BOOL)isHollow;
- (void)drawBezeledPlateInRect:(NSRect)aRect fillColor:(NSColor *)fillColor hollow:(BOOL)isHollow;

- (void)drawRoundedRect:(NSRect)aRect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask fillColor:(NSColor *)fillColor;
- (void)drawBezeledRoundedRect:(NSRect)aRect cornerRadius:(float)radius cornerMask:(unsigned int)cornerMask fillColor:(NSColor *)fillColor hollow:(BOOL)isHollow;


@end
