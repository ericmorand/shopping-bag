//
//  FKModuleThemePurple.m
//  ShoppingBag
//
//  Created by Eric on 26/04/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleThemePurple.h"


@implementation FKModuleThemePurple

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setTopGradientStartColor:[NSColor colorWithDeviceRed:215.0/255.0 green:192.0/255.0 blue:245.0/255.0 alpha:1.0]];
		[self setTopGradientEndColor:[NSColor colorWithDeviceRed:179.0/255.0 green:152.0/255.0 blue:221.0/255.0 alpha:1.0]];
		[self setBottomGradientStartColor:[NSColor colorWithDeviceRed:166.0/255.0 green:136.0/255.0 blue:213.0/255.0 alpha:1.0]];
		[self setBottomGradientEndColor:[NSColor colorWithDeviceRed:143.0/255.0 green:113.0/255.0 blue:191.0/255.0 alpha:1.0]];
		[self setBorderColor:[NSColor colorWithDeviceRed:83.0/255.0 green:68.0/255.0 blue:109.0/255.0 alpha:1.0]];
		[self setStandardTextColor:[NSColor colorWithDeviceRed:46.0/255.0 green:36.0/255.0 blue:63.0/255.0 alpha:0.9]];
	}
	
	return self;
}

@end
