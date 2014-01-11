//
//  FKLine.m
//  FKKit
//
//  Created by Eric on 25/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKLine.h"


@implementation FKLine

- (void)drawRect:(NSRect)rect
{
	[[NSColor colorWithDeviceRed:205.0/255.0 green:205.0/255.0 blue:205.0/255.0 alpha:1.0] set];
	
	[NSBezierPath fillRect:rect];
}

@end
