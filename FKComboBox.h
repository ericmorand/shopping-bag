//
//  FKComboBox.h
//  FK
//
//  Created by Eric on 05/03/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKComboBox : NSComboBox
{
}

- (void)setPlaceholderString:(NSString *)string;

- (void)setRightAnglesMask:(unsigned)anInt;
- (void)setStrokedBordersMask:(unsigned)anInt;

@end

@interface NSObject (FKComboBoxDataSource)

- (id)textFieldObjectValueForSelectedItemOfComboBox:(FKComboBox *)aComboBox;

@end

@interface NSObject (FKComboBoxDelegate)

- (BOOL)comboBox:(FKComboBox *)aComboBox shouldSelectRow:(int)rowIndex;
- (void)comboBox:(FKComboBox *)aComboBox willDisplayCell:(id)aCell atRow:(int)rowIndex;
- (float)comboBox:(FKComboBox *)aComboBox heightOfRow:(int)row;

@end