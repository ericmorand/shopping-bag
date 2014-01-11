//
//  SupplyOrderLine.h
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Product;
@class SupplyOrder;

@interface SupplyOrderLine :  FKManagedObject  
{
}

- (NSNumber *)quantity;
- (void)setQuantity:(NSNumber *)value;
- (BOOL)validateQuantity: (id *)valueRef error:(NSError **)outError;

- (Product *)product;
- (void)setProduct:(Product *)value;
- (BOOL)validateProduct: (id *)valueRef error:(NSError **)outError;

- (SupplyOrder *)supplyOrder;
- (void)setSupplyOrder:(SupplyOrder *)value;
- (BOOL)validateSupplyOrder: (id *)valueRef error:(NSError **)outError;

@end
