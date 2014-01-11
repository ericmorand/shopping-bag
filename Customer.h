//
//  Customer.h
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Address;
@class Sale;

#define CustomerPBoardDataType @"CustomerPBoardDataType"

@interface Customer :  FKManagedObject  
{
}

@property (readonly) NSImage* icon;

- (NSString *)customerNumber;
- (NSImage *)picture;
- (NSData *)pictureData ;

- (void)setCustomerNumber:(NSString *)value;
- (void)setPicture:(NSImage *)value;
- (void)setPictureData:(NSData *)value;


- (BOOL)validateCustomerNumber: (id *)valueRef error:(NSError **)outError;

- (NSString *)name;
- (void)setName:(NSString *)value;
- (BOOL)validateName: (id *)valueRef error:(NSError **)outError;

- (NSString *)notes;
- (void)setNotes:(NSString *)value;
- (BOOL)validateNotes: (id *)valueRef error:(NSError **)outError;

- (Address *)address;
- (void)setAddress:(Address *)value;
- (BOOL)validateAddress: (id *)valueRef error:(NSError **)outError;

// Access to-many relationship via -[NSObject mutableSetValueForKey:]
- (void)addSalesObject:(Sale *)value;
- (void)removeSalesObject:(Sale *)value;

- (NSString *)uniqueName;

@end
