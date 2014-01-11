//
//  Provider.h
//  ShoppingBag
//
//  Created by Eric on 09/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Address;
@class PaymentMethod;
@class ProviderProduct;

@interface Provider :  FKManagedObject  
{
}

@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * faxNumber;
@property (nonatomic, retain) NSString * emailAddress;
@property (nonatomic, retain) NSData * iconData;
@property (nonatomic, retain) NSString * name;
//@property (nonatomic, retain) NSImage * icon;
@property (nonatomic, retain) NSSet* providerProducts;
@property (nonatomic, retain) NSSet* paymentMethod;
@property (nonatomic, retain) NSSet* addresses;

@property (readonly) NSImage * icon;

@end


@interface Provider (CoreDataGeneratedAccessors)
- (void)addProviderProductsObject:(ProviderProduct *)value;
- (void)removeProviderProductsObject:(ProviderProduct *)value;
- (void)addProviderProducts:(NSSet *)value;
- (void)removeProviderProducts:(NSSet *)value;

- (void)addPaymentMethodObject:(PaymentMethod *)value;
- (void)removePaymentMethodObject:(PaymentMethod *)value;
- (void)addPaymentMethod:(NSSet *)value;
- (void)removePaymentMethod:(NSSet *)value;

- (void)addAddressesObject:(Address *)value;
- (void)removeAddressesObject:(Address *)value;
- (void)addAddresses:(NSSet *)value;
- (void)removeAddresses:(NSSet *)value;

@end

