// 
//  StockAlert.m
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "StockAlert.h"

#import "Product.h"

@implementation StockAlert 


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

@end
