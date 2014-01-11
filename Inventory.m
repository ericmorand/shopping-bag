// 
//  Inventory.m
//  ShoppingBag
//
//  Created by Eric on 30/08/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "Inventory.h"

#import "StockMovement.h"

static Inventory * runningInventory = nil;

@implementation Inventory

+ (void)initialize
{
    [self setKeys:[NSArray arrayWithObjects:@"status", nil] triggerChangeNotificationsForDependentKey:@"statusIcon"];
	[self setKeys:[NSArray arrayWithObjects:@"status", nil] triggerChangeNotificationsForDependentKey:@"canRun"];
    [self setKeys:[NSArray arrayWithObjects:@"status", nil] triggerChangeNotificationsForDependentKey:@"canStop"];
}

+ (NSArray *)indexedValuesKeys {return [NSArray arrayWithObjects:@"name", @"status", nil];}
+ (NSArray *)uniqueValuesKeys {return [NSArray arrayWithObjects:@"name", nil];}

+ (Inventory *)runningInventory
{
	return runningInventory;
}

+ (void)setRunningInventory:(Inventory *)anInventory
{
	// On considere a ce point que les tests de validation ont deja eu lieu
	
	runningInventory = anInventory;
}

#pragma mark -
#pragma mark GETTERS

- (NSDate *)beginDate 
{
    NSDate * tmpValue = nil;
    
    [self willAccessValueForKey:@"beginDate"];
    tmpValue = [self primitiveValueForKey:@"beginDate"];
    [self didAccessValueForKey:@"beginDate"];
    
    return tmpValue;
}

- (StockSnapshot *)beginStockSnapshot 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"beginStockSnapshot"];
    tmpObject = [self primitiveValueForKey:@"beginStockSnapshot"];
    [self didAccessValueForKey:@"beginStockSnapshot"];
    
    return tmpObject;
}

- (NSDate *)endDate 
{
    NSDate * tmpValue = nil;
    
    [self willAccessValueForKey:@"endDate"];
    tmpValue = [self primitiveValueForKey:@"endDate"];
    [self didAccessValueForKey:@"endDate"];
    
    return tmpValue;
}

- (StockSnapshot *)endStockSnapshot 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"endStockSnapshot"];
    tmpObject = [self primitiveValueForKey:@"endStockSnapshot"];
    [self didAccessValueForKey:@"endStockSnapshot"];
    
    return tmpObject;
}

- (NSString *)name 
{
    NSString * tmpValue = nil;
    
    [self willAccessValueForKey:@"name"];
    tmpValue = [self primitiveValueForKey:@"name"];
    [self didAccessValueForKey:@"name"];
    
    return tmpValue;
}

- (NSNumber *)status 
{
    NSNumber * tmpValue = nil;
    
    [self willAccessValueForKey:@"status"];
    tmpValue = [self primitiveValueForKey:@"status"];
    [self didAccessValueForKey:@"status"];
    
    return tmpValue;
}

// ...

- (BOOL)canRun
{
	NSNumber * statusRunning = [NSNumber numberWithBool:InventoryStatusRunning];
	
	return [self validateStatus:&statusRunning error:nil];
}

- (BOOL)canStop
{
	NSNumber * statusDone = [NSNumber numberWithBool:InventoryStatusDone];
	
	return [self validateStatus:&statusDone error:nil];
}

- (NSString *)uniqueName
{	
	NSString * defaultName = NSLocalizedString(@"NewInventory", nil);
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

- (NSImage *)statusIcon
{	
	int statusAsInt = [[self status] intValue];
	
	switch ( statusAsInt )
	{
		case InventoryStatusRunning : {return [NSImage imageNamed:@"StatusGreen"]; break;}
		case InventoryStatusPaused : {return [NSImage imageNamed:@"StatusYellow"]; break;}
		case InventoryStatusIdle : {return [NSImage imageNamed:@"StatusGray"]; break;}
		case InventoryStatusDone : {return [NSImage imageNamed:@"StatusRed"]; break;}
	}
	
	return nil;
}

- (NSImage *)icon {
	return [NSImage imageNamed:@"Inventories"];
}

#pragma mark -
#pragma mark SETTERS

- (void)setBeginDate:(NSDate *)value 
{
    [self willChangeValueForKey:@"beginDate"];
    [self setPrimitiveValue:value forKey:@"beginDate"];
    [self didChangeValueForKey:@"beginDate"];
}

- (void)setBeginStockSnapshot:(StockSnapshot *)value 
{
    [self willChangeValueForKey:@"beginStockSnapshot"];
    [self setPrimitiveValue:value forKey:@"beginStockSnapshot"];
    [self didChangeValueForKey:@"beginStockSnapshot"];
}

- (void)setEndDate:(NSDate *)value 
{
    [self willChangeValueForKey:@"endDate"];
    [self setPrimitiveValue:value forKey:@"endDate"];
    [self didChangeValueForKey:@"endDate"];
}

- (void)setEndStockSnapshot:(StockSnapshot *)value 
{
    [self willChangeValueForKey:@"endStockSnapshot"];
    [self setPrimitiveValue:value forKey:@"endStockSnapshot"];
    [self didChangeValueForKey:@"endStockSnapshot"];
}

- (void)setName:(NSString *)value 
{
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveValue:value forKey:@"name"];
    [self didChangeValueForKey:@"name"];
}

- (void)setStatus:(NSNumber *)value 
{
    [self willChangeValueForKey:@"status"];
    [self setPrimitiveValue:value forKey:@"status"];
    [self didChangeValueForKey:@"status"];
}

// ...

- (void)addStockMovementsObject:(StockMovement *)value 
{    
    NSSet * changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"stockMovements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"stockMovements"] addObject:value];
    [self didChangeValueForKey:@"stockMovements" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeStockMovementsObject:(StockMovement *)value 
{
    NSSet * changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"stockMovements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"stockMovements"] removeObject:value];
    [self didChangeValueForKey:@"stockMovements" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateBeginDate:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateBeginStockSnapshot:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateEndDate:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateName:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateStatus:(id *)valueRef error:(NSError **)outError 
{	
	// idle -> running
	// running -> done
	// paused <-> running
	// paused -> done
	
	BOOL valid = NO;
	
	int statusAsInt = [[self status] intValue];
	int newStatusAsInt = [(NSNumber *)*valueRef intValue];
	
	if ( newStatusAsInt == statusAsInt )
	{
		valid = YES;
	}
	else
	{
		switch ( newStatusAsInt )
		{
			case InventoryStatusDone :
			{
				NSLog (@"InventoryStatusDone...");
			
				valid = ( statusAsInt == InventoryStatusPaused ) || ( statusAsInt == InventoryStatusRunning );
			
				break;
			}
			case InventoryStatusIdle :
			{
				valid = ( statusAsInt == InventoryStatusIdle );
			
				break;
			}
			case InventoryStatusPaused :
			{
				valid = ( statusAsInt == InventoryStatusRunning );
			
				break;
			}
			case InventoryStatusRunning :
			{
				valid = ( ( nil == runningInventory ) || ( self == runningInventory ) ) && ( statusAsInt != InventoryStatusDone );
			
				break;
			}
		}
	}
		
    return valid;
}

#pragma mark -
#pragma mark MISC

- (void)setDefaultValues
{
	[self setName:[self uniqueName]];
	[self setStatus:[NSNumber numberWithInt:InventoryStatusIdle]];
}

- (void)awakeFromFetch
{
	[super awakeFromFetch];
}

- (void)awakeFromInsert
{
	[super awakeFromInsert];
	
	[self setDefaultValues];
}

- (void)run
{
	[self setStatus:[NSNumber numberWithInt:InventoryStatusRunning]];
	[self setBeginDate:[NSDate date]];
	
	// On cree la photographie d'inventaire
	
	StockSnapshot * aStockSnapshot = [NSEntityDescription insertNewObjectForEntityForName:@"StockSnapshot" inManagedObjectContext:[self managedObjectContext]];
	
	[self setBeginStockSnapshot:aStockSnapshot];
	
	[Inventory setRunningInventory:self];
}

- (void)stop
{
	[self setStatus:[NSNumber numberWithInt:InventoryStatusDone]];
	[self setEndDate:[NSDate date]];
	
	// On cree la photographie d'inventaire
	
	StockSnapshot * aStockSnapshot = [NSEntityDescription insertNewObjectForEntityForName:@"StockSnapshot" inManagedObjectContext:[self managedObjectContext]];
	
	[self setEndStockSnapshot:aStockSnapshot];
	
	[Inventory setRunningInventory:nil];
}

@end
