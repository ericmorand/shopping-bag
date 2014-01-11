//
//  StockSnapshot.h
//  ShoppingBag
//
//  Created by Eric on 19/09/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Product;
@class StockSnapshotLine;

@interface StockSnapshot : FKManagedObject  
{
}

- (NSDate *)date;

- (void)setDate:(NSDate *)value;

- (BOOL)validateDate:(id *)valueRef error:(NSError **)outError;

// Access to-many relationship via -[NSObject mutableSetValueForKey:]
- (void)addStockSnapshotLinesObject:(StockSnapshotLine *)value;
- (void)removeStockSnapshotLinesObject:(StockSnapshotLine *)value;

@end
