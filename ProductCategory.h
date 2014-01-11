//
//  ProductCategory.h
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Product;

@interface ProductCategory :  FKManagedObject  
{
}

@property (readonly) NSImage * icon;

+ (ProductCategory *)productCategoryInContext:(NSManagedObjectContext *)aContext;

//- (NSImage *)icon;
- (NSData *)iconData;
- (NSString *)name;

- (void)setIcon:(NSImage *)anImage;
- (void)setIconData:(NSData *)value;
- (void)setName:(NSString *)value;

// Access to-many relationship via -[NSObject mutableSetValueForKey:]
- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;

- (BOOL)validateIconData:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateName: (id *)valueRef error:(NSError **)outError;

@end
