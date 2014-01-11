//
//  SupplyOrder.h
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Provider;
@class SupplyOrderLine;

@interface SupplyOrder :  FKManagedObject  
{
}

- (Provider *)provider;
- (void)setProvider:(Provider *)value;
- (BOOL)validateProvider: (id *)valueRef error:(NSError **)outError;

// Access to-many relationship via -[NSObject mutableSetValueForKey:]
- (void)addSupplyOrderLinesObject:(SupplyOrderLine *)value;
- (void)removeSupplyOrderLinesObject:(SupplyOrderLine *)value;

@end
