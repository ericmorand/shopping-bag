//
//  FKButton.h
//  FKKit
//
//  Created by Eric on 01/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKButtonCell.h"


@interface FKButton : NSButton
{
}

- (void)commonSetup;

- (void)setFkBezelStyle:(FKBezelStyle)aStyle;
- (void)setBorderMask:(unsigned)anInt;
- (void)setLeftMargin:(float)aFloat;
- (void)setRightMargin:(float)aFloat;

@end

@interface FKGradientButton : FKButton
{
}

@end

@interface FKPlateGradientButton : FKGradientButton
{
}

- (void)setRightAnglesMask:(unsigned)anInt;
- (void)setStrokedBordersMask:(unsigned)anInt;

@end

@interface FKRSPlateGradientButton : FKPlateGradientButton
{
}

@end