//
//  FKNumberFormatter.m
//  FKKit
//
//  Created by Eric on 15/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKNumberFormatter.h"


@implementation FKNumberFormatter

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString  **)error
{
    BOOL returnValue = NO;	
	NSDecimalNumber * objectValue = nil;
	
	NSLocale * currentLocale = [NSLocale currentLocale];
	NSString * groupingSeperator = [currentLocale objectForKey:NSLocaleGroupingSeparator];	
	NSDictionary * localeDictionary = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
	
	NSMutableString * mutableString = [NSMutableString stringWithString:string];
	
	// ...
	
	[mutableString replaceOccurrencesOfString:groupingSeperator withString:@"" options:nil range:NSMakeRange(0, [mutableString length])];
	
	objectValue = [NSDecimalNumber decimalNumberWithString:mutableString locale:localeDictionary];	
	
	if ( ![objectValue isEqualTo:[NSDecimalNumber notANumber]] )
	{
		returnValue = YES;
        
		*obj = objectValue;
    }
	else
	{
        if ( error )
		{
            *error = NSLocalizedString(@"Invalid number", @"Number formatter error");
		}
    }
	
    return returnValue;
}

@end
