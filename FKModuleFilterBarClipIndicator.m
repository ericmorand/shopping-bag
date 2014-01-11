//
//  FKModulePlateToolbarClipIndicator.m
//  FKKit
//
//  Created by alt on 02/10/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleFilterBarClipIndicator.h"
#import "FKModuleFilterBarClipIndicatorCell.h"


@implementation FKModuleFilterBarClipIndicator

+ (Class)cellClass {return [FKModuleFilterBarClipIndicatorCell class];}

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	
	if (nil != self) {
	}
	
	return self;
}

#pragma mark -
#pragma mark GETTERS

- (NSInteger)state {
	return [[self cell] state];
}

@end
