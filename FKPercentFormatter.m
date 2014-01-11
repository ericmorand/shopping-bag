//
//  FKPercentFormatter.m
//  FKKit
//
//  Created by Eric on 14/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKPercentFormatter.h"


@implementation FKPercentFormatter

- (NSString *)stringForObjectValue:(id)anObject
{		
	if ( ![anObject isKindOfClass:[NSDecimalNumber class]] )
	{
		return nil;
	}
	
	NSDecimalNumber * objectValue = [(NSDecimalNumber *)anObject decimalNumberByMultiplyingBy:[NSDecimalNumber hundred]];
	
	return [NSString stringWithFormat:@"%@%%", [super stringForObjectValue:objectValue]];
}

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString  **)error
{
	BOOL returnValue = [super getObjectValue:obj forString:string errorDescription:error];

	NSDecimalNumber * objectValue = nil;
	
	if ( returnValue )
	{
		objectValue = *obj;
		
		*obj = [objectValue decimalNumberByDividingBy:[NSDecimalNumber hundred]];
    }
	
    return returnValue;
}

@end
