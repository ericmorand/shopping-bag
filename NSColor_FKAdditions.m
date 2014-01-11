//
//  NSColor_FKAdditions.m
//  FKKit
//
//  Created by alt on 01/01/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "NSColor_FKAdditions.h"


@implementation NSColor (FKAdditions)

+ (NSColor *)lightBorderColor {
	return [NSColor colorWithDeviceRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];	
}

+ (NSColor *)strongBorderColor {
	return [NSColor colorWithDeviceRed:81.0/255.0 green:81.0/255.0 blue:81.0/255.0 alpha:1.0];	
}

+ (NSColor *)toolbarEnabledForeColor {
	return [NSColor colorWithDeviceRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
}

+ (NSColor *)toolbarDisabledForeColor {
	return [self lightBorderColor];	
}

@end
