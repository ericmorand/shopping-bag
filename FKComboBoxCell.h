//
//  FKComboBoxCell.h
//  FK
//
//  Created by Eric on 15/07/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FKPlatePopUpButtonCell.h"


@interface FKComboBoxCell : NSComboBoxCell
{
	FKPlatePopUpButtonCell *	buttonCell;
}

- (NSButtonCell *)buttonCell;

- (void)setDelegate:(id)delegate;
- (void)setButtonCell:(NSButtonCell *)aCell;
- (void)setRightAnglesMask:(unsigned)anInt;
- (void)setStrokedBordersMask:(unsigned)anInt;

@end

@interface NSObject (FKComboBoxCellDelegate)

- (BOOL)comboBoxShouldSelectRow:(int)rowIndex;
- (void)comboBoxWillDisplayCell:(id)aCell atRow:(int)rowIndex;
- (float)comboBoxHeightOfRow:(int)row;

@end