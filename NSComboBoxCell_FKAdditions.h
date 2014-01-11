//
//  NSComboBoxCell_FKAdditions.h
//  FKKit
//
//  Created by Eric on 15/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSComboBoxCell (FKAdditions)

- (NSButtonCell *)buttonCell;
- (void)setButtonCell:(NSButtonCell *)aCell;

@end
