//
//  Sale.h
//  ShoppingBag
//
//  Created by Eric on 25/09/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Customer;
@class Invoice;
@class PaymentMethod;
@class SaleLine;

@interface Sale : FKManagedObject  
{
}

@property (nonatomic, retain) NSDecimalNumber * totalTTC;
@property (nonatomic, retain) NSDecimalNumber * totalTax;
@property (nonatomic, retain) NSDecimalNumber * discountedTotalHT;
@property (nonatomic, retain) NSDecimalNumber * discountedTotalTTC;
@property (nonatomic, retain) NSDecimalNumber * discountRate;
@property (nonatomic, retain) NSString * saleNumber;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSDecimalNumber * totalHT;
@property (nonatomic, retain) Customer * customer;
@property (nonatomic, retain) PaymentMethod * paymentMethod;
@property (nonatomic, retain) NSSet * saleLines;
@property (nonatomic, retain) Invoice * invoice;

@property (readonly) NSString * displayName;
@property (readonly) NSImage * icon;
@property (nonatomic, readonly) NSArray * amountByTaxRate;

- (void)addSaleLine:(SaleLine *)saleLine;

#pragma mark -
#pragma mark KVO

- (void)beginKeyValueObserving;
- (void)beginKeyValueObservingForSaleLine:(SaleLine *)saleLine;

#pragma mark -
#pragma mark COMPUTED VALUES

- (void)computeTotalHTAndTTC;
- (void)computeDiscountedTotalHTAndTTC;
- (void)computeTotalTax;

@end


@interface Sale (CoreDataGeneratedAccessors)
- (void)addSaleLinesObject:(SaleLine *)value;
- (void)removeSaleLinesObject:(SaleLine *)value;
- (void)addSaleLines:(NSSet *)value;
- (void)removeSaleLines:(NSSet *)value;

@end

