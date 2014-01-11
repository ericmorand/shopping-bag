// 
//  Brand.m
//  ShoppingBag
//
//  Created by Eric on 01/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "Brand.h"

#import "Provider.h"

@implementation Brand 

+ (Brand *)brandInContext:(NSManagedObjectContext *)aContext
{
	return [[[Brand alloc] initWithEntity:[NSEntityDescription entityForName:@"Brand" inManagedObjectContext:aContext] insertIntoManagedObjectContext:aContext] autorelease];
}

+ (NSArray *)indexedValuesKeys {return [NSArray arrayWithObjects:@"name", nil];}

#pragma mark -
#pragma mark GETTERS

- (Provider *)favoriteProvider 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"favoriteProvider"];
    tmpObject = [self primitiveValueForKey:@"favoriteProvider"];
    [self didAccessValueForKey:@"favoriteProvider"];
    
    return tmpObject;
}

//- (NSImage *)icon
//{
//    [self willAccessValueForKey:@"icon"];
//    NSImage * icon = [self primitiveValueForKey:@"icon"];
//    [self didAccessValueForKey:@"icon"];
//	
//    if ( icon == nil )
//	{
//        NSData * iconData = [self valueForKey:@"iconData"];
//		
//        if ( iconData != nil )
//		{
//            icon = [NSKeyedUnarchiver unarchiveObjectWithData:iconData];
//			
//            [self setPrimitiveValue:icon forKey:@"icon"];
//        }
//    }
//	
//    return icon;
//}


- (NSData *)iconData 
{
    NSData * tmpValue = nil;
    
    [self willAccessValueForKey:@"iconData"];
    tmpValue = [self primitiveValueForKey:@"iconData"];
    [self didAccessValueForKey:@"iconData"];
    
    return tmpValue;
}

- (NSString *)name 
{
    NSString * tmpValue = nil;
    
    [self willAccessValueForKey: @"name"];
    tmpValue = [self primitiveValueForKey: @"name"];
    [self didAccessValueForKey: @"name"];
    
    return tmpValue;
}

// ...

- (NSString *)defaultName {
	return NSLocalizedString(@"NewBrand", nil);
}

- (NSImage *)icon {
	return [NSImage imageNamed:@"Brands"];
}

#pragma mark -
#pragma mark SETTERS

- (void)setFavoriteProvider:(Provider *)value 
{
    [self willChangeValueForKey:@"favoriteProvider"];
    [self setPrimitiveValue:value forKey: @"favoriteProvider"];
    [self didChangeValueForKey:@"favoriteProvider"];
}

- (void)setIcon:(NSImage *)value 
{
    [self willChangeValueForKey:@"icon"];
    [self setPrimitiveValue:value forKey:@"icon"];
    [self didChangeValueForKey:@"icon"];
}

- (void)setIconData:(NSData *)value 
{
    [self willChangeValueForKey:@"iconData"];
    [self setPrimitiveValue:value forKey:@"iconData"];
    [self didChangeValueForKey:@"iconData"];
}

- (void)setName:(NSString *)value 
{
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveValue:value forKey:@"name"];
    [self didChangeValueForKey:@"name"];
}

#pragma mark -
#pragma mark DEFAULT VALUES

- (void)setDefaultValues
{
	[self setName:[self uniqueName]];
	[self setIcon:[NSImage imageNamed:@"NSApplicationIcon"]];
}

- (NSString *)uniqueName
{	
	NSString * defaultName = NSLocalizedString(@"NewBrand", nil);
	NSString * uniqueName = defaultName;
	
//	unsigned index = 0;
//	
//	FKMOCIndexesManager * defaultIndexesManager = [FKMOCIndexesManager defaultManager];
//	
//	while ( ![defaultIndexesManager validateValue:&uniqueName forIndexedKey:@"name" ofObject:self] )
//	{		
//		index++;
//		
//		uniqueName = [defaultName stringByAppendingFormat:@" (%d)", index];
//	}
	
	return uniqueName;
}

#pragma mark -
#pragma mark MISC

- (void)awakeFromFetch {
	[super awakeFromFetch];
}

- (void)awakeFromInsert {
	[super awakeFromInsert];
}

- (void)willSave
{
    NSImage * icon = [self primitiveValueForKey:@"icon"];
	
	id tmpValue = nil;
	
    if ( icon != nil )
	{
        tmpValue = [NSKeyedArchiver archivedDataWithRootObject:icon];
    }
	
	[self setPrimitiveValue:tmpValue forKey:@"iconData"];
	
    [super willSave];
}

@end
