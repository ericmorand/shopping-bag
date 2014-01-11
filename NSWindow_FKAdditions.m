//
//  NSWindow_FKAdditions.m
//  FKKit
//
//  Created by Eric on 12/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "NSWindow_FKAdditions.h"


@implementation NSWindow (FKAdditions)

- (NSTextField *)firstResponderTextField
{
	NSTextField * firstResponderTextField = nil;
		
	if ( ( [[self firstResponder] isKindOfClass:[NSTextView class]] ) && ( [self fieldEditor:NO forObject:nil] != nil ) )
	{
		firstResponderTextField = [(NSTextView *)[self firstResponder] delegate];
	}
	
	return firstResponderTextField;
}

@end
