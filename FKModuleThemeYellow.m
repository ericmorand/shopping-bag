//
//  FKModuleThemeYellow.m
//  ShoppingBag
//
//  Created by Eric on 29/04/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleThemeYellow.h"


@implementation FKModuleThemeYellow

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setTopGradientStartColor:[NSColor colorWithDeviceRed:253.0/255.0 green:215.0/255.0 blue:60.0/255.0 alpha:1.0]];
		[self setTopGradientEndColor:[NSColor colorWithDeviceRed:253.0/255.0 green:215.0/255.0 blue:60.0/255.0 alpha:1.0]];
		[self setBottomGradientStartColor:[NSColor colorWithDeviceRed:255.0/255.0 green:207.0/255.0 blue:12.0/255.0 alpha:1.0]];
		[self setBottomGradientEndColor:[NSColor colorWithDeviceRed:255.0/255.0 green:207.0/255.0 blue:12.0/255.0 alpha:1.0]];
		[self setBorderColor:[NSColor colorWithDeviceRed:255.0/255.0 green:187.0/255.0 blue:0.0/255.0 alpha:1.0]];
		[self setStandardTextColor:[NSColor orangeColor]]; //[NSColor colorWithDeviceRed:255.0/255.0 green:200.0/255.0 blue:45.0/255.0 alpha:1.0]];
	}
	
	return self;
}

@end
