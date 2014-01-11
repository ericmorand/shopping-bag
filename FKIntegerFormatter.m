//
//  FKIntegerFormatter.m
//  FKKit
//
//  Created by Eric on 18/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKIntegerFormatter.h"


@implementation FKIntegerFormatter

- (NSString *)stringForObjectValue:(id)anObject
{	
	if ( ![anObject isKindOfClass:[NSNumber class]] )
	{
		return nil;
	}
	
	NSNumberFormatter * aFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	
	[aFormatter setFormat:@"#,##0"];
	[aFormatter setLocalizesFormat:YES];
	
	return [aFormatter stringForObjectValue:anObject];
}

@end
