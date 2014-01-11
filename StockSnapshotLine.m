// 
//  StockSnapshotLine.m
//  ShoppingBag
//
//  Created by Eric on 19/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "StockSnapshotLine.h"

#import "StockSnapshot.h"
#import "Product.h"

@implementation StockSnapshotLine 

#pragma mark -
#pragma mark GETTERS

- (Product *)product 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"product"];
    tmpObject = [self primitiveValueForKey:@"product"];
    [self didAccessValueForKey:@"product"];
    
    return tmpObject;
}

- (NSNumber *)quantity 
{
    NSNumber * tmpValue = nil;
    
    [self willAccessValueForKey:@"quantity"];
    tmpValue = [self primitiveValueForKey:@"quantity"];
    [self didAccessValueForKey:@"quantity"];
    
    return tmpValue;
}

- (StockSnapshot *)stockSnapshot 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"stockSnapshot"];
    tmpObject = [self primitiveValueForKey:@"stockSnapshot"];
    [self didAccessValueForKey:@"stockSnapshot"];
    
    return tmpObject;
}

#pragma mark -
#pragma mark SETTERS

- (void)setProduct:(Product *)value 
{
    [self willChangeValueForKey:@"product"];
    [self setPrimitiveValue:value forKey:@"product"];
    [self didChangeValueForKey:@"product"];
}

- (void)setQuantity:(NSNumber *)value 
{
    [self willChangeValueForKey:@"quantity"];
    [self setPrimitiveValue:value forKey:@"quantity"];
    [self didChangeValueForKey:@"quantity"];
}

- (void)setStockSnapshot:(StockSnapshot *)value 
{
    [self willChangeValueForKey:@"stockSnapshot"];
    [self setPrimitiveValue:value forKey:@"stockSnapshot"];
    [self didChangeValueForKey:@"stockSnapshot"];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateProduct:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateQuantity:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateStockSnapshot:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

@end
