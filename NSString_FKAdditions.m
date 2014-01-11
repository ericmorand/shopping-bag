//
//  NSString_FKAdditions.m
//  FKKit
//
//  Created by Eric on 21/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "NSString_FKAdditions.h"


@implementation NSString (FKAdditions)

- (NSString *)stringByCapitalizingFirstCharacter
{
	NSString * stringByCapitalizingFirstCharacter = nil;
	
	NSString * firstCharacter = nil;
	NSString * remainingString = nil;
	
	if ( [self length] > 0 )
	{
		firstCharacter = [[self substringToIndex:1] uppercaseString];
		remainingString = [self substringFromIndex:1];
	
		stringByCapitalizingFirstCharacter = [firstCharacter stringByAppendingString:remainingString];
	}
	
	return stringByCapitalizingFirstCharacter;
}

- (NSString *)stringByLowercasingFirstCharacter
{
	NSString * stringByLowercasingFirstCharacter = nil;
	
	NSString * firstCharacter = nil;
	NSString * remainingString = nil;
	
	if ( [self length] > 0 )
	{
		firstCharacter = [[self substringToIndex:1] lowercaseString];
		remainingString = [self substringFromIndex:1];
		
		stringByLowercasingFirstCharacter = [firstCharacter stringByAppendingString:remainingString];
	}
	
	return stringByLowercasingFirstCharacter;
}

- (NSComparisonResult)numericCompare:(NSString *)aString
{
	return [self compare:aString options:NSNumericSearch];
}

@end
