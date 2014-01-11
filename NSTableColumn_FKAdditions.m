//
//  NSTableColumn_FKAdditions.m
//  FK
//
//  Created by Eric Morand on Fri Apr 16 2004.
//  Copyright (c) 2004 FKy Creations. All rights reserved.
//

#import "NSTableColumn_FKAdditions.h"


@implementation NSTableColumn (FKAdditions)

- (NSString *)title
{
	return [[self headerCell] stringValue];
}

- (void)setTitle:(NSString *)title {[[self headerCell] setStringValue:title];}

@end
