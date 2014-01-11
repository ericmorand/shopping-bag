//
//  FKButtonCell.h
//  FKKit
//
//  Created by Eric on 01/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


typedef enum _FKBezelStyle {
	FKBorderOnlyBezelStyle		= 1,
	FKSquareBezelStyle			= 2,
	FKRoundedGradientStyle		= 3
} FKBezelStyle;

@interface FKButtonCell : NSButtonCell
{	
	FKBezelStyle			fkBezelStyle;
	unsigned				borderMask;
	float					leftMargin;
	float					rightMargin;
	float					imageToTitleSpacing;
		
	NSMutableDictionary *	titleStringAttributes;
}

- (void)setFkBezelStyle:(FKBezelStyle)aStyle;
- (void)setBorderMask:(unsigned)anInt;
- (void)setLeftMargin:(float)aFloat;
- (void)setRightMargin:(float)aFloat;

- (void)setTitleStringAttributes:(NSMutableDictionary *)aDictionary;

@property (setter=setLeftMargin:) float					leftMargin;
@property (setter=setRightMargin:) float					rightMargin;
@property float					imageToTitleSpacing;
@end

#pragma mark -
#pragma mark FKGradientButtonCell
#pragma mark -

@interface FKGradientButtonCell : FKButtonCell
{
}

@end

#pragma mark -
#pragma mark FKPlateGradientButtonCell
#pragma mark -

@interface FKPlateGradientButtonCell : FKGradientButtonCell
{
	unsigned	rightAnglesMask;
	unsigned	strokedBordersMask;
}

- (void)setRightAnglesMask:(unsigned)anInt;
- (void)setStrokedBordersMask:(unsigned)anInt;

- (NSBezierPath *)fillPathWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
- (NSBezierPath *)strokePathWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@property (setter=setRightAnglesMask:) unsigned	rightAnglesMask;
@property (setter=setStrokedBordersMask:) unsigned	strokedBordersMask;
@end
