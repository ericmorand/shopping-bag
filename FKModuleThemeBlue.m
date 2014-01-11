//
//  FKModuleThemeBlue.m
//  ShoppingBag
//
//  Created by Eric on 26/04/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleThemeBlue.h"


@implementation FKModuleThemeBlue

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setTopGradientStartColor:[NSColor colorWithDeviceRed:176.0/255.0 green:211.0/255.0 blue:254.0/255.0 alpha:1.0]];
		[self setTopGradientEndColor:[NSColor colorWithDeviceRed:138.0/255.0 green:173.0/255.0 blue:248.0/255.0 alpha:1.0]];;
		[self setBottomGradientStartColor:[NSColor colorWithDeviceRed:119.0/255.0 green:159.0/255.0 blue:244.0/255.0 alpha:1.0]];
		[self setBottomGradientEndColor:[NSColor colorWithDeviceRed:96.0/255.0 green:136.0/255.0 blue:222.0/255.0 alpha:1.0]];
		[self setBorderColor:[NSColor colorWithDeviceRed:51.0/255.0 green:73.0/255.0 blue:118.0/255.0 alpha:1.0]];
		[self setStandardTextColor:[NSColor colorWithDeviceRed:25.0/255.0 green:30.0/255.0 blue:45.0/255.0 alpha:0.9]];
	}
	
	return self;
}

@end
