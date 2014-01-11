// 
//  SupplyOrderLine.m
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "SupplyOrderLine.h"

#import "Product.h"
#import "SupplyOrder.h"

@implementation SupplyOrderLine 

- (NSNumber *)quantity 
{
    NSNumber * tmpValue;
    
    [self willAccessValueForKey: @"quantity"];
    tmpValue = [self primitiveValueForKey: @"quantity"];
    [self didAccessValueForKey: @"quantity"];
    
    return tmpValue;
}

- (void)setQuantity:(NSNumber *)value 
{
    [self willChangeValueForKey: @"quantity"];
    [self setPrimitiveValue: value forKey: @"quantity"];
    [self didChangeValueForKey: @"quantity"];
}

- (BOOL)validateQuantity: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}


- (Product *)product 
{
    id tmpObject;
    
    [self willAccessValueForKey: @"product"];
    tmpObject = [self primitiveValueForKey: @"product"];
    [self didAccessValueForKey: @"product"];
    
    return tmpObject;
}

- (void)setProduct:(Product *)value 
{
    [self willChangeValueForKey: @"product"];
    [self setPrimitiveValue: value
                     forKey: @"product"];
    [self didChangeValueForKey: @"product"];
}


- (BOOL)validateProduct: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}


- (SupplyOrder *)supplyOrder 
{
    id tmpObject;
    
    [self willAccessValueForKey: @"supplyOrder"];
    tmpObject = [self primitiveValueForKey: @"supplyOrder"];
    [self didAccessValueForKey: @"supplyOrder"];
    
    return tmpObject;
}

- (void)setSupplyOrder:(SupplyOrder *)value 
{
    [self willChangeValueForKey: @"supplyOrder"];
    [self setPrimitiveValue: value
                     forKey: @"supplyOrder"];
    [self didChangeValueForKey: @"supplyOrder"];
}


- (BOOL)validateSupplyOrder: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

@end
