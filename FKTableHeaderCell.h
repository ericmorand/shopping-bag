//
//  FKTableHeaderCell.h
//  FKFramework
//
//  Created by Eric on 18/03/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKTableHeaderCell : NSTableHeaderCell
{
	float		horizontalMargin;
	
	int			sortPriority;
	
	BOOL		isSortable;
	BOOL		isAscending;
	BOOL		showsSortIndicator;
}

@property float		horizontalMargin;
@property int			sortPriority;
@property BOOL		isSortable;
@property BOOL		isAscending;
@property BOOL		showsSortIndicator;
@end
