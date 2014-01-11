//
//  FKCurrencyFormatter.m
//  FKKit
//
//  Created by Eric on 15/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKCurrencyFormatter.h"


@implementation FKCurrencyFormatter

- (NSString *)stringForObjectValue:(id)anObject
{	
	if ( ![anObject isKindOfClass:[NSDecimalNumber class]] )
	{
		return nil;
	}
	
	NSLocale * currentLocale = [NSLocale currentLocale];
	NSString * currencySymbol = [currentLocale objectForKey:NSLocaleCurrencySymbol];
	
	return [NSString stringWithFormat:@"%@ %@", [super stringForObjectValue:anObject], currencySymbol];
}

@end
