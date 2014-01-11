//
//  StockSnapshotLine.h
//  ShoppingBag
//
//  Created by Eric on 19/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>

@class StockSnapshot;
@class Product;

@interface StockSnapshotLine :  FKManagedObject  
{
}

- (Product *)product;
- (NSNumber *)quantity;
- (StockSnapshot *)stockSnapshot;

- (void)setProduct:(Product *)value;
- (void)setQuantity:(NSNumber *)value;
- (void)setStockSnapshot:(StockSnapshot *)value;

- (BOOL)validateProduct: (id *)valueRef error:(NSError **)outError;
- (BOOL)validateQuantity:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateStockSnapshot: (id *)valueRef error:(NSError **)outError;

@end
