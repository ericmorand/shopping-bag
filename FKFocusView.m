//
//  FKFocusView.m
//  FKKit
//
//  Created by Eric on 24/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKFocusView.h"


@implementation FKFocusView

- (NSView *)hitTest:(NSPoint)aPoint {return nil;}

- (void)drawRect:(NSRect)aRect
{
	NSRect insetBackground = NSInsetRect([self bounds], 1.5, 1.5);
		
	NSSetFocusRingStyle (NSFocusRingOnly);
	
	NSBezierPath * aPath = [NSBezierPath bezierPathWithRect:insetBackground];
	
	[aPath setLineWidth:3.0];
	
	[aPath stroke];
}

@end
