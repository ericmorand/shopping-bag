//
//  FKModuleThemeRed.m
//  ShoppingBag
//
//  Created by Eric on 27/04/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleThemeRed.h"


@implementation FKModuleThemeRed

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setTopGradientStartColor:[NSColor colorWithDeviceRed:240.0/255.0 green:145.0/255.0 blue:145.0/255.0 alpha:1.0]];
		[self setTopGradientEndColor:[NSColor colorWithDeviceRed:195.0/255.0 green:101.0/255.0 blue:101.0/255.0 alpha:1.0]];
		[self setBottomGradientStartColor:[NSColor colorWithDeviceRed:179.0/255.0 green:68.0/255.0 blue:69.0/255.0 alpha:1.0]];
		[self setBottomGradientEndColor:[NSColor colorWithDeviceRed:162.0/255.0 green:51.0/255.0 blue:52.0/255.0 alpha:1.0]];
		[self setBorderColor:[NSColor colorWithDeviceRed:81.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0]];
		[self setStandardTextColor:[NSColor colorWithDeviceRed:61.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:0.9]];
		[self setBackgroundTextColor:[[self standardTextColor] colorWithAlphaComponent:0.75]];
	}
	
	return self;
}

@end
