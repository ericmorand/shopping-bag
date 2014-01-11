//
//  ProductFamily.h
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Product;

@interface ProductFamily :  FKManagedObject  
{
}

@property (readonly) NSImage * icon;

//- (NSImage *)icon;
- (NSData *)iconData;
- (NSString *)name;

//- (void)setIcon:(NSImage *)anImage;
- (void)setIconData:(NSData *)value;
- (void)setName:(NSString *)value;

- (BOOL)validateName:(id *)valueRef error:(NSError **)outError;

// Access to-many relationship via -[NSObject mutableSetValueForKey:]
- (void)addProductsObject:(Product *)value;
- (void)removeProductsObject:(Product *)value;

@end
