// 
//  StockMovement.m
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "StockMovement.h"

#import "Inventory.h"
#import "Sale.h"
#import "SaleLine.h"
#import "SupplyOrder.h"
#import "Product.h"

@implementation StockMovement 

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

- (Inventory *)inventory 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"inventory"];
    tmpObject = [self primitiveValueForKey:@"inventory"];
    [self didAccessValueForKey:@"inventory"];
    
    return tmpObject;
}

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

- (NSString *)reason 
{
    NSString * tmpValue = nil;
    
    [self willAccessValueForKey:@"reason"];
    tmpValue = [self primitiveValueForKey:@"reason"];
    [self didAccessValueForKey:@"reason"];
    
    return tmpValue;
}

- (SaleLine *)saleLine 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"saleLine"];
    tmpObject = [self primitiveValueForKey:@"saleLine"];
    [self didAccessValueForKey:@"saleLine"];
    
    return tmpObject;
}

- (SupplyOrder *)supplyOrder 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"supplyOrder"];
    tmpObject = [self primitiveValueForKey:@"supplyOrder"];
    [self didAccessValueForKey:@"supplyOrder"];
    
    return tmpObject;
}

- (NSString *)description {
	return [NSString stringWithFormat:
			@"Mouvement de stock => date : %@ - produit : %@ - quantite : %@ - raison : %@ - vente : %@", 
			self.date, self.product.name, self.quantity, self.reason, self.saleLine];
}

#pragma mark -
#pragma mark SETTERS

- (void)setDate:(NSDate *)value 
{
    [self willChangeValueForKey:@"date"];
    [self setPrimitiveValue:value forKey:@"date"];
    [self didChangeValueForKey:@"date"];
}

- (void)setInventory:(Inventory *)value 
{
    [self willChangeValueForKey:@"inventory"];
    [self setPrimitiveValue:value forKey:@"inventory"];
    [self didChangeValueForKey:@"inventory"];
}

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

- (void)setReason:(NSString *)value 
{
    [self willChangeValueForKey:@"reason"];
    [self setPrimitiveValue:value forKey:@"reason"];
    [self didChangeValueForKey:@"reason"];
}

- (void)setSaleLine:(SaleLine *)value 
{
    [self willChangeValueForKey:@"saleLine"];
    [self setPrimitiveValue:value forKey:@"saleLine"];
    [self didChangeValueForKey:@"saleLine"];
}

- (void)setSupplyOrder:(SupplyOrder *)value 
{
    [self willChangeValueForKey:@"supplyOrder"];
    [self setPrimitiveValue:value forKey:@"supplyOrder"];
    [self didChangeValueForKey:@"supplyOrder"];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateDate:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateInventory:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateProduct:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateQuantity:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateReason:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateSaleLine:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateSupplyOrder:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

@end
