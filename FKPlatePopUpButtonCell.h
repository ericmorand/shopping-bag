//
//  FKPlatePopUpButtonCell.h
//  FKKit
//
//  Created by Eric on 05/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKPlatePopUpButtonCell : NSPopUpButtonCell
{
	NSString *						mainTitle;
	NSColor *						titleForegroundColor;
	
	NSSize							arrowSize;
	
	FKPlateGradientButtonCell *		drawingCell;
}

- (FKPlateGradientButtonCell *)drawingCell;

- (NSRect)drawingRectForCellFrame:(NSRect)cellFrame inView:(NSView *)controlView;

- (void)setMainTitle:(NSString *)aString;
- (void)setTitleForegroundColor:(NSColor *)aColor;
- (void)setRightAnglesMask:(unsigned)anInt;
- (void)setStrokedBordersMask:(unsigned)anInt;
- (void)setDrawingCell:(NSButtonCell *)aCell;

- (NSBezierPath *)strokePathWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;

@end
