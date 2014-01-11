//
//  FKMultipleValuesProxy.m
//  ShoppingBag
//
//  Created by Eric on 03/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKMultipleValuesProxy.h"

@interface FKMultipleValuesProxy (Private)

- (void)setObjectsArray:(NSMutableArray *)anArray;

@end

@implementation FKMultipleValuesProxy

- (id)init
{
	self = [super init];
	
	if ( self )
	{
		[self setObjectsArray:[NSMutableArray array]];
	}
	
	return self;
}

- (void)dealloc
{
	[self setObjectsArray:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark SETTERS

- (void)setObjectsArray:(NSMutableArray *)anArray
{
	if ( anArray != objectsArray )
	{
		[objectsArray release];
		objectsArray = [anArray retain];
	}
}

#pragma mark -
#pragma mark OBJECTS SUPPORT

- (void)addObject:(id)anObject
{
	[objectsArray addObject:anObject];
}

- (id)valueForKey:(NSString *)key
{
	return [self valueForKeyPath:key];
}

- (id)valueForKeyPath:(NSString *)keyPath
{	
	id valueForKeyPath = nil;
	id aValue = nil;
	
	int i = 0;
	
	for ( ; i < [objectsArray count]; i++ )
	{
		aValue = [[objectsArray objectAtIndex:i] valueForKeyPath:keyPath];
				
		if ( nil == valueForKeyPath )
		{
			valueForKeyPath = aValue;
		}
		else if ( ![aValue isEqualTo:valueForKeyPath] )
		{
			valueForKeyPath = NSMultipleValuesMarker;
			
			break;
		}
	}
		
	return valueForKeyPath;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
	int i = 0;
	
	for ( ; i < [objectsArray count]; i++ )
	{
		[[objectsArray objectAtIndex:i] setValue:value forKey:key];
	}
}

- (BOOL)validateValue:(id *)ioValue forKey:(NSString *)key error:(NSError **)outError
{
	id anObject = nil;
	
	if ( [objectsArray count] > 0 )
	{
		anObject = [objectsArray objectAtIndex:0];
	}
	
	return [anObject validateValue:ioValue forKey:key error:outError];
}

@end
