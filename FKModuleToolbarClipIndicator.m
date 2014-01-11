//
//  FKModuleToolbarClipIndicator.m
//  FKKit
//
//  Created by Alt on 19/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleToolbarClipIndicator.h"
#import "FKModuleToolbarClipIndicatorCell.h"


@implementation FKModuleToolbarClipIndicator

+ (Class)cellClass
{
	return [FKModuleToolbarClipIndicatorCell class];
}

#pragma mark -
#pragma mark LAYOUT

- (void)sizeToFit
{
	[self setFrameSize:[[self cell] cellSize]];
}

#pragma mark -
#pragma mark DRAWING

- (void)drawRect:(NSRect)aRect
{
	[[self cell] drawWithFrame:aRect inView:self];
}

@end