//
//  FKModuleThemeOrange.m
//  ShoppingBag
//
//  Created by Eric on 27/04/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleThemeOrange.h"


@implementation FKModuleThemeOrange

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setTopGradientStartColor:[NSColor colorWithDeviceRed:255.0/255.0 green:221.0/255.0 blue:20.0/255.0 alpha:1.0]];
		[self setTopGradientEndColor:[NSColor colorWithDeviceRed:255.0/255.0 green:203.0/255.0 blue:20.0/255.0 alpha:1.0]];
		[self setBottomGradientStartColor:[NSColor colorWithDeviceRed:255.0/255.0 green:169.0/255.0 blue:20.0/255.0 alpha:1.0]];
		[self setBottomGradientEndColor:[NSColor colorWithDeviceRed:255.0/255.0 green:134.0/255.0 blue:20.0/255.0 alpha:1.0]];
		[self setBorderColor:[NSColor colorWithDeviceRed:255.0/255.0 green:100.0/255.0 blue:20.0/255.0 alpha:1.0]];
		[self setStandardTextColor:[NSColor colorWithDeviceRed:25.0/255.0 green:30.0/255.0 blue:45.0/255.0 alpha:0.9]];
	}
	
	return self;
}

@end
