// 
//  Invoice.m
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Invoice.h"

#import "Sale.h"

@implementation Invoice 

- (NSDate *)date 
{
    NSDate * tmpValue;
    
    [self willAccessValueForKey: @"date"];
    tmpValue = [self primitiveValueForKey: @"date"];
    [self didAccessValueForKey: @"date"];
    
    return tmpValue;
}

- (void)setDate:(NSDate *)value 
{
    [self willChangeValueForKey: @"date"];
    [self setPrimitiveValue: value forKey: @"date"];
    [self didChangeValueForKey: @"date"];
}

- (BOOL)validateDate: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

- (NSString *)invoiceNumber 
{
    NSString * tmpValue;
    
    [self willAccessValueForKey: @"invoiceNumber"];
    tmpValue = [self primitiveValueForKey: @"invoiceNumber"];
    [self didAccessValueForKey: @"invoiceNumber"];
    
    return tmpValue;
}

- (void)setInvoiceNumber:(NSString *)value 
{
    [self willChangeValueForKey: @"invoiceNumber"];
    [self setPrimitiveValue: value forKey: @"invoiceNumber"];
    [self didChangeValueForKey: @"invoiceNumber"];
}

- (BOOL)validateInvoiceNumber: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}


- (Sale *)sale 
{
    id tmpObject;
    
    [self willAccessValueForKey: @"sale"];
    tmpObject = [self primitiveValueForKey: @"sale"];
    [self didAccessValueForKey: @"sale"];
    
    return tmpObject;
}

- (void)setSale:(Sale *)value 
{
    [self willChangeValueForKey: @"sale"];
    [self setPrimitiveValue: value
                     forKey: @"sale"];
    [self didChangeValueForKey: @"sale"];
}


- (BOOL)validateSale: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

@end
