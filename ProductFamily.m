// 
//  ProductFamily.m
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "ProductFamily.h"
#import "Product.h"


@implementation ProductFamily 

+ (NSArray *)indexedValuesKeys {return [NSArray arrayWithObjects:@"name", nil];}

#pragma mark -
#pragma mark GETTERS

- (NSImage *)icon {
    //[self willAccessValueForKey:@"icon"];
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
	return [NSImage imageNamed:@"ProductFamilies"];
}

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
    
    [self willAccessValueForKey:@"name"];
    tmpValue = [self primitiveValueForKey:@"name"];
    [self didAccessValueForKey:@"name"];
    
    return tmpValue;
}

#pragma mark -
#pragma mark SETTERS

- (void)setIcon:(NSImage *)anImage
{
    [self willChangeValueForKey:@"icon"];
    [self setPrimitiveValue:anImage forKey:@"icon"];
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

- (void)addProductsObject:(Product *)value 
{    
    NSSet * changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"products" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"products"] addObject:value];
    [self didChangeValueForKey:@"products" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeProductsObject:(Product *)value 
{
    NSSet * changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"products" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"products"] removeObject:value];
    [self didChangeValueForKey:@"products" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateName:(id *)valueRef error:(NSError **)outError 
{
    return YES;
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
	NSString * defaultName = NSLocalizedString(@"NewProductFamily", nil);
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

- (void)awakeFromFetch
{
	[super awakeFromFetch];
}

- (void)awakeFromInsert
{
	[super awakeFromInsert];
	
	[self setDefaultValues];
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
