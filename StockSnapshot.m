// 
//  StockSnapshot.m
//  ShoppingBag
//
//  Created by Eric on 19/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "StockSnapshot.h"

#import "Product.h"
#import "stockSnapshotLine.h"

@implementation StockSnapshot 

#pragma mark -
#pragma mark GETTERS

- (NSDate *)date 
{
    NSDate * tmpValue = nil;
    
    [self willAccessValueForKey:@"date"];
    tmpValue = [self primitiveValueForKey:@"date"];
    [self didAccessValueForKey:@"date"];
    
    return tmpValue;
}

#pragma mark -
#pragma mark SETTERS

- (void)setDate:(NSDate *)value 
{
    [self willChangeValueForKey:@"date"];
    [self setPrimitiveValue:value forKey:@"date"];
    [self didChangeValueForKey:@"date"];
}

// ...

- (void)addStockSnapshotLinesObject:(StockSnapshotLine *)value 
{    
    NSSet * changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"stockSnapshotLines" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"stockSnapshotLines"] addObject:value];
    [self didChangeValueForKey:@"stockSnapshotLines" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeStockSnapshotLinesObject:(StockSnapshotLine *)value 
{
    NSSet * changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"stockSnapshotLines" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"stockSnapshotLines"] removeObject:value];
    [self didChangeValueForKey:@"stockSnapshotLines" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateDate:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

#pragma mark -
#pragma mark MISC

- (void)awakeFromInsert
{
	[super awakeFromInsert];
	
	// ...
	
	[self setDate:[NSDate date]];
	
	// On fait une photographie du stock
	
	NSManagedObjectContext * managedObjectContext = [self managedObjectContext];	
	
	NSArray * allProducts = nil;
	NSEnumerator * productsEnumerator = nil;
	Product * aProduct = nil;
	
	StockSnapshotLine * aSnapshotLine = nil;
		
	NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription * entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:managedObjectContext];
	
	[fetchRequest setEntity:entity];
	
	allProducts = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
	
	for ( aProduct in allProducts )
	{
		//NSLog (@"aProduct = %@", [aProduct name]);
		
		aSnapshotLine = [NSEntityDescription insertNewObjectForEntityForName:@"StockSnapshotLine" inManagedObjectContext:managedObjectContext];
		
		[aSnapshotLine setProduct:aProduct];
		[aSnapshotLine setQuantity:[aProduct currentStock]];
		
		[self addStockSnapshotLinesObject:aSnapshotLine];
	}
}

@end
