// 
//  SupplyOrder.m
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "SupplyOrder.h"

#import "Provider.h"
#import "SupplyOrderLine.h"

@implementation SupplyOrder 


- (Provider *)provider 
{
    id tmpObject;
    
    [self willAccessValueForKey: @"provider"];
    tmpObject = [self primitiveValueForKey: @"provider"];
    [self didAccessValueForKey: @"provider"];
    
    return tmpObject;
}

- (void)setProvider:(Provider *)value 
{
    [self willChangeValueForKey: @"provider"];
    [self setPrimitiveValue: value
                     forKey: @"provider"];
    [self didChangeValueForKey: @"provider"];
}


- (BOOL)validateProvider: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}


- (void)addSupplyOrderLinesObject:(SupplyOrderLine *)value 
{    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"supplyOrderLines" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [[self primitiveValueForKey: @"supplyOrderLines"] addObject: value];
    
    [self didChangeValueForKey:@"supplyOrderLines" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeSupplyOrderLinesObject:(SupplyOrderLine *)value 
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"supplyOrderLines" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [[self primitiveValueForKey: @"supplyOrderLines"] removeObject: value];
    
    [self didChangeValueForKey:@"supplyOrderLines" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

@end
