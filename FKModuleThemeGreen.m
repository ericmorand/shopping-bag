//
//  FKModuleThemeGreen.m
//  ShoppingBag
//
//  Created by Eric on 27/04/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "FKModuleThemeGreen.h"


@implementation FKModuleThemeGreen

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setTopGradientStartColor:[NSColor colorWithDeviceRed:174.0/255.0 green:221.0/255.0 blue:152.0/255.0 alpha:1.0]];
		[self setTopGradientEndColor:[NSColor colorWithDeviceRed:130.0/255.0 green:178.0/255.0 blue:106.0/255.0 alpha:1.0]];
		[self setBottomGradientStartColor:[NSColor colorWithDeviceRed:103.0/255.0 green:159.0/255.0 blue:75.0/255.0 alpha:1.0]];
		[self setBottomGradientEndColor:[NSColor colorWithDeviceRed:103.0/255.0 green:159.0/255.0 blue:58.0/255.0 alpha:1.0]];
		[self setBorderColor:[NSColor colorWithDeviceRed:51.0/255.0 green:79.0/255.0 blue:37.0/255.0 alpha:1.0]];
		[self setStandardTextColor:[NSColor colorWithDeviceRed:31.0/255.0 green:59.0/255.0 blue:17.0/255.0 alpha:0.9]];
	}
	
	return self;
}

@end
