//
//  StockMovement.h
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Inventory;
@class Product;
@class SaleLine;
@class SupplyOrder;

@interface StockMovement :  FKManagedObject  
{
}

- (NSDate *)date;
- (Inventory *)inventory;
- (Product *)product;
- (NSNumber *)quantity;
- (NSString *)reason;
- (SaleLine *)saleLine;
- (SupplyOrder *)supplyOrder;

- (void)setDate:(NSDate *)value;
- (void)setInventory:(Inventory *)value;
- (void)setProduct:(Product *)value;
- (void)setQuantity:(NSNumber *)value;
- (void)setReason:(NSString *)value;
- (void)setSaleLine:(SaleLine *)value;
- (void)setSupplyOrder:(SupplyOrder *)value;

- (BOOL)validateDate:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateInventory:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateProduct:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateQuantity:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateReason:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateSaleLine:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateSupplyOrder:(id *)valueRef error:(NSError **)outError;

@end
