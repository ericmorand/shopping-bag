//
//  FKTableView.h
//  FK
//
//  Created by Eric Morand on Mon Apr 05 2004.
//  Copyright (c) 2004 Eric Morand. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface FKTableView : NSTableView
{
	#include "FKTableView_Vars.h"
}

#include "FKTableView_Methods.h"

@property (retain) NSArray *			_savedTableColumns;
@property (retain) NSColor	*			_rowSeparatorColor;
@property float				_rowSeparatorWidth;
@end

@interface NSObject (FKTableViewDelegate)

- (BOOL)tableView:(FKTableView *)tableView isSeparatorRowAtIndex:(int)rowIndex;
- (BOOL)tableView:(FKTableView *)tableView isOptionalColumn:(NSTableColumn *)aTableColumn;
- (id)tableView:(FKTableView *)tableView objectAtRow:(int)rowIndex;
- (unsigned)tableView:(FKTableView *)tableView rowForObject:(id)anObject;
- (NSColor *)tableView:(FKTableView *)tableView colorForRowAtIndex:(int)rowIndex;

@end