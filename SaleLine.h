//
//  SaleLine.h
//  ShoppingBag
//
//  Created by Eric on 18/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Product;
@class Sale;
@class StockMovement;

@interface SaleLine :  FKManagedObject {
	NSDate *		creationDate;
}

@property (nonatomic, retain) NSDecimalNumber * quantity;
@property (nonatomic, retain) NSDecimalNumber * productDiscountPriceHT;
@property (nonatomic, retain) NSDecimalNumber * productDiscountPriceTTC;
@property (nonatomic, retain) NSDecimalNumber * productTaxRate;
@property (nonatomic, retain) NSDecimalNumber * productBasePriceTTC;
@property (nonatomic, retain) NSDecimalNumber * discountRate;
@property (nonatomic, retain) NSDecimalNumber * lineTotalTTC;
@property (nonatomic, retain) NSDecimalNumber * productBasePriceHT;
@property (nonatomic, retain) NSDecimalNumber * lineTotalHT;
@property (nonatomic, retain) Product * product;
@property (nonatomic, retain) StockMovement * stockMovement;
@property (nonatomic, retain) Sale * sale;

@property (nonatomic, retain) NSDate * creationDate;

- (void)computeLineTotals;

@end



