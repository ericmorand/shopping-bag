//
//  FKDecimalFormatter.m
//  FKKit
//
//  Created by Eric on 18/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKDecimalFormatter.h"


@implementation FKDecimalFormatter

- (NSString *)stringForObjectValue:(id)anObject
{	
	if ( ![anObject isKindOfClass:[NSDecimalNumber class]] )
	{
		return nil;
	}
	
	NSNumberFormatter * aFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	
	[aFormatter setFormat:@"#,##0.00"];
	[aFormatter setLocalizesFormat:YES];
	
	return [aFormatter stringForObjectValue:anObject];
}

@end
