//
//  FKModuleThemeBrown.m
//  ShoppingBag
//
//  Created by Eric on 27/04/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleThemeBrown.h"


@implementation FKModuleThemeBrown

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setTopGradientStartColor:[NSColor colorWithDeviceRed:220.0/255.0 green:186.0/255.0 blue:127.0/255.0 alpha:1.0]];
		[self setTopGradientEndColor:[NSColor colorWithDeviceRed:182.0/255.0 green:142.0/255.0 blue:74.0/255.0 alpha:1.0]];
		[self setBottomGradientStartColor:[NSColor colorWithDeviceRed:138.0/255.0 green:97.0/255.0 blue:34.0/255.0 alpha:1.0]];
		[self setBottomGradientEndColor:[NSColor colorWithDeviceRed:134.0/255.0 green:93.0/255.0 blue:29.0/255.0 alpha:1.0]];
		[self setBorderColor:[NSColor colorWithDeviceRed:56.0/255.0 green:36.0/255.0 blue:0.0/255.0 alpha:1.0]];
		[self setStandardTextColor:[NSColor colorWithDeviceRed:25.0/255.0 green:30.0/255.0 blue:45.0/255.0 alpha:0.9]];
	}
	
	return self;
}

@end
