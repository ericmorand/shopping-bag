// 
//  Customer.m
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "Customer.h"

#import "Address.h"
#import "Sale.h"

@implementation Customer 

+ (NSArray *)indexedValuesKeys {return [NSArray arrayWithObjects:@"name", @"customerNumber", nil];}

#pragma mark -
#pragma mark GETTERS

- (Address *)address 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"address"];
    tmpObject = [self primitiveValueForKey:@"address"];
    [self didAccessValueForKey:@"address"];
    
    return tmpObject;
}

- (NSString *)customerNumber 
{
    NSString * tmpValue = nil;
    
    [self willAccessValueForKey:@"customerNumber"];
    tmpValue = [self primitiveValueForKey:@"customerNumber"];
    [self didAccessValueForKey:@"customerNumber"];
    
    return tmpValue;
}

- (NSImage *)picture
{
    [self willAccessValueForKey:@"picture"];
    NSImage * picture = [self primitiveValueForKey:@"picture"];
    [self didAccessValueForKey:@"picture"];
	
    if ( picture == nil )
	{
        NSData * pictureData = [self valueForKey:@"pictureData"];
		
        if ( pictureData != nil )
		{
            picture = [NSKeyedUnarchiver unarchiveObjectWithData:pictureData];
			
            [self setPrimitiveValue:picture forKey:@"picture"];
        }
    }
	
    return picture;
}

- (NSData *)pictureData 
{
    NSData * tmpValue = nil;
    
    [self willAccessValueForKey:@"pictureData"];
    tmpValue = [self primitiveValueForKey:@"pictureData"];
    [self didAccessValueForKey:@"pictureData"];
    
    return tmpValue;
}

- (NSImage *)icon {
	return [NSImage imageNamed:@"Customers"];
}

#pragma mark -
#pragma mark SETTERS

- (void)setAddress:(Address *)value 
{
    [self willChangeValueForKey:@"address"];
    [self setPrimitiveValue:value forKey:@"address"];
    [self didChangeValueForKey:@"address"];
}

- (void)setCustomerNumber:(NSString *)value 
{
    [self willChangeValueForKey:@"customerNumber"];
    [self setPrimitiveValue:value forKey:@"customerNumber"];
    [self didChangeValueForKey:@"customerNumber"];
}

- (void)setPicture:(NSImage *)value 
{
    [self willChangeValueForKey:@"picture"];
    [self setPrimitiveValue:value forKey:@"picture"];
    [self didChangeValueForKey:@"picture"];
}

- (void)setPictureData:(NSData *)value
{
    [self willChangeValueForKey:@"pictureData"];
    [self setPrimitiveValue:value forKey:@"pictureData"];
    [self didChangeValueForKey:@"pictureData"];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateCustomerNumber: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

- (NSString *)name 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey: @"name"];
    tmpValue = [self primitiveValueForKey: @"name"];
    [self didAccessValueForKey: @"name"];
    
    return tmpValue;
}

- (void)setName:(NSString *)value 
{
    [self willChangeValueForKey: @"name"];
    [self setPrimitiveValue: value forKey: @"name"];
    [self didChangeValueForKey: @"name"];
}

- (BOOL)validateName: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

- (NSString *)notes 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey: @"notes"];
    tmpValue = [self primitiveValueForKey: @"notes"];
    [self didAccessValueForKey: @"notes"];
    
    return tmpValue;
}

- (void)setNotes:(NSString *)value 
{
    [self willChangeValueForKey: @"notes"];
    [self setPrimitiveValue: value forKey: @"notes"];
    [self didChangeValueForKey: @"notes"];
}

- (BOOL)validateNotes: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}


- (BOOL)validateAddress:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (void)addSalesObject:(Sale *)value 
{    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"sales" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"sales"] addObject:value];
    [self didChangeValueForKey:@"sales" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeSalesObject:(Sale *)value 
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"sales" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"sales"] removeObject:value];
    [self didChangeValueForKey:@"sales" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (BOOL)validateSales:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

#pragma mark -
#pragma mark MISC

// ...

- (void)setDefaultValues {
	[self setName:[self uniqueName]];
	[self setPicture:[NSImage imageNamed:@"NSApplicationIcon"]];
	[self setAddress:[NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:[self managedObjectContext]]];
}

- (NSString *)uniqueName
{	
	NSString * defaultName = NSLocalizedString(@"NewCustomer", nil);
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

- (void)awakeFromFetch {
	[super awakeFromFetch];
}

- (void)awakeFromInsert {
	[super awakeFromInsert];
}

- (void)willSave
{
	NSImage * picture = nil;
	id tmpValue = nil;
	
	// Picture
	
    picture = [self primitiveValueForKey:@"picture"];	
	
    if ( picture != nil )
	{
        tmpValue = [NSKeyedArchiver archivedDataWithRootObject:picture];
    }
	
	[self setPrimitiveValue:tmpValue forKey:@"pictureData"];
	
	// Super
    
	[super willSave];
}

@end
