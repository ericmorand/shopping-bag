//
//  FKModuleToolbarSeparatorItem.m
//  FKKit
//
//  Created by Alt on 20/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleToolbarSeparatorItem.h"
#import "FKModuleToolbarSeparator.h"


@implementation FKModuleToolbarSeparatorItem

#pragma mark -
#pragma mark GETTERS

- (BOOL)isSeparator {return YES;}

- (id)view
{
	if ( view == nil )
	{
		FKModuleToolbarSeparator * aSeparator = [[[FKModuleToolbarSeparator alloc] initWithFrame:NSZeroRect] autorelease];
		
		NSSize separatorSize = NSZeroSize;
			
		separatorSize.width = 2.0;
		separatorSize.height = [toolbar itemHeight];
		
		[aSeparator setFrameSize:separatorSize];
		[aSeparator setToolbar:toolbar];
		[aSeparator setToolbarItem:self];
		
		[self setView:aSeparator];
	}
	
	return view;
}

- (int)tag {return -1;}

#pragma mark -
#pragma mark SETTERS

- (void)setEnabled:(BOOL)flag {}

@end
