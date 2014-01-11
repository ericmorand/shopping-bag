//
//  FKPlatePopUpButton.h
//  FKKit
//
//  Created by Eric on 05/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKPlatePopUpButton : NSPopUpButton
{
}

- (FKPlateGradientButtonCell *)drawingCell;

- (void)setMainTitle:(NSString *)aString;
- (void)setTitleForegroundColor:(NSColor *)aColor;
- (void)setRightAnglesMask:(unsigned)anInt;
- (void)setStrokedBordersMask:(unsigned)anInt;

@end
