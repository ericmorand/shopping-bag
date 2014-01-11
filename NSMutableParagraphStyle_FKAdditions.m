//
//  NSMutableParagraphStyle_FKAdditions.m
//  FK
//
//  Created by Eric on 22/07/05.
//  Copyright 2005 Eric Morand. All rights reserved.
//

#import "NSMutableParagraphStyle_FKAdditions.h"


@implementation NSMutableParagraphStyle (FKAdditions)

+ (NSMutableParagraphStyle *)paragraphStyleWithAlignment:(NSTextAlignment)alignment
{	
	return [[[NSMutableParagraphStyle alloc] initWithAlignment:(NSTextAlignment)alignment] autorelease];
}

- (id)initWithAlignment:(NSTextAlignment)alignment
{
	self = [super init];
	
	if ( self )
	{
		[self setAlignment:alignment];
	}
	
	return self;
}

@end
