//
//  FKModulePlateToolbarButtonCell.m
//  Shopping Bag
//
//  Created by Eric on 11/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleFilterBarButtonCell.h"

@implementation FKModuleFilterBarButtonCell

#pragma mark -
#pragma mark GETTERS

- (BOOL)usesCustomDrawing {
	return NO;
}

- (NSInteger)state {
	if ([self.toolbarItem isSelected]) {
		return NSOnState;
	}
	
	return NSOffState;
}

@end
