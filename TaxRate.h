//
//  TaxRate.h
//  ShoppingBag
//
//  Created by Eric on 06/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Product;

@interface TaxRate : FKManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * rate;
@property (nonatomic, retain) NSSet* products;

@property (readonly) NSString * displayName;
@property (readonly) NSImage * icon;

- (NSString *)uniqueName;

@end


@interface TaxRate (CoreDataGeneratedAccessors)
- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;
- (void)addProducts:(NSSet *)value;
- (void)removeProducts:(NSSet *)value;

@end

