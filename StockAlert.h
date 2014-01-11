//
//  StockAlert.h
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Product;

@interface StockAlert :  FKManagedObject  
{
}

- (Product *)product;
- (void)setProduct:(Product *)value;
- (BOOL)validateProduct: (id *)valueRef error:(NSError **)outError;

@end
