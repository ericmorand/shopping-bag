//
//  NSDecimalNumber_FKAdditions.m
//  FK
//
//  Created by Eric on 28/02/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "NSDecimalNumber_FKAdditions.h"


@implementation NSDecimalNumber (FKAdditions)

+ (NSDecimalNumber *)hundred
{
	return [NSDecimalNumber decimalNumberWithMantissa:100 exponent:0 isNegative:NO];
}

- (NSDecimalNumber *)opposite
{
	return [self decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:YES]];
}

// - (NSDecimalNumber *)rateFrom:(NSDecimalNumber *)decimalNumber
// Retourne le taux qu'il faut appliquer a decimalNumber pour obtenir self
// ex : si decimalNumber vaut 175 et que self vaut 150, rateFrom: retourne
// ((175 - 150) / 150) = 0,17

- (NSDecimalNumber *)rateFrom:(NSDecimalNumber *)decimalNumber
{
	NSDecimalNumber * rate = nil;
	
	if ( [self isEqualTo:decimalNumber] )
	{
		rate = [NSDecimalNumber zero];
		rate = [rate decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumber defaultBehavior]];
	}
	else if ( ![self isEqualToZero] )
	{
		rate = [decimalNumber decimalNumberBySubtracting:self];
		rate = [rate decimalNumberByDividingBy:decimalNumber];
		rate = [rate decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumber defaultBehavior]];
	}
	else
	{
		rate = NSNotApplicableMarker;
	}
	
	return rate;
}

- (NSDecimalNumber *)decimalNumberByAddingRate:(NSDecimalNumber *)rate
{
	NSDecimalNumber * result = self;
	
	if ( ( nil != rate ) && ( ![rate isEqualTo:[NSDecimalNumber zero]] ) )
	{
		result = [self decimalNumberByMultiplyingBy:rate];
		result = [self decimalNumberByAdding:result];
		result = [result decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumber defaultBehavior]];
	}
	
	return result;
}

// - (NSDecimalNumber *)decimalNumberByRemovingRate:(NSDecimalNumber *)rate
// Retourne le nombre auquel il faut appliquer rate pour obtenir self
// ex : si self vaut 120 et que rate vaut 15%, rateTo: retourne
// (120 / (1 + 0,15)) = 120 / 1,15 = 104,35

- (NSDecimalNumber *)decimalNumberByRemovingRate:(NSDecimalNumber *)rate
{
	NSDecimalNumber * result = self;
	
	if ( ( nil != rate ) && ( ![rate isEqualTo:[NSDecimalNumber zero]] ) )
	{
		result = [rate decimalNumberByAdding:[NSDecimalNumber one]];
		result = [self decimalNumberByDividingBy:result];
		result = [result decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumber defaultBehavior]];
	}
	
	return result;
}

- (NSDecimalNumber *)decimalNumberBySubtractingRate:(NSDecimalNumber *)rate;
{
	NSDecimalNumber * result = self;
	
	if ( ( nil != rate ) && ( ![rate isEqualTo:[NSDecimalNumber zero]] ) )
	{
		result = [self decimalNumberByMultiplyingBy:rate];
		result = [self decimalNumberBySubtracting:result];
		result = [result decimalNumberByRoundingAccordingToBehavior:[NSDecimalNumber defaultBehavior]];
	}
	
	return result;
}

- (BOOL)isEqualToZero
{
	return ( [self compare:[NSDecimalNumber zero]] == NSOrderedSame );
}

- (BOOL)isPositive
{
	return ( [self compare:[NSDecimalNumber zero]] == NSOrderedDescending );
}

- (BOOL)isNegative
{
	return ( [self compare:[NSDecimalNumber zero]] == NSOrderedAscending );
}

@end
