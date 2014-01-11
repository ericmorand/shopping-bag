//
//  Product.h
//  ShoppingBag
//
//  Created by Eric on 07/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Brand;
@class ProductCategory;
@class ProductFamily;
@class ProviderProduct;
@class Sale;
@class StockAlert;
@class StockMovement;
@class TaxRate;
@class Provider;

#define ProductPBoardDataType @"ProductPBoardDataType"

@interface Product : FKManagedObject {
}

@property (nonatomic, retain) NSNumber * isDiscontinued;
@property (nonatomic, retain) NSString * reference;
@property (nonatomic, retain) NSImage * versoIcon;
@property (nonatomic, retain) NSDecimalNumber * unitPriceTTC;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDecimalNumber * unitPriceHT;
@property (nonatomic, retain) NSData * rectoIconData;
@property (nonatomic, retain) NSNumber * currentStock;
@property (nonatomic, retain) NSDate * discontinuedDate;
//@property (nonatomic, retain) NSImage* rectoIcon;
@property (nonatomic, retain) NSData * versoIconData;
@property (nonatomic, retain) NSData * barcodeImageData;
@property (nonatomic, retain) NSString * barcode;
@property (nonatomic, retain) NSImage * barcodeImage;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) Brand * brand;
@property (nonatomic, retain) NSSet* stockMovements;
@property (nonatomic, retain) StockAlert * stockAlert;
@property (nonatomic, retain) ProductFamily * productFamily;
@property (nonatomic, retain) NSSet * productCategories;
@property (nonatomic, retain) NSSet * sales;
@property (nonatomic, retain) NSSet * providerProducts;
@property (nonatomic, retain) TaxRate * taxRate;
@property (nonatomic, retain) NSNumber *salePriceIncludesTax;

@property (readonly) NSImage* rectoIcon;
@property (readonly) Provider *primaryProvider;

- (void)computeUnitPriceHT;
- (void)computeUnitPriceTTC;

@end


@interface Product (CoreDataGeneratedAccessors)
- (void)addStockMovementsObject:(StockMovement *)value;
- (void)removeStockMovementsObject:(StockMovement *)value;
- (void)addStockMovements:(NSSet *)value;
- (void)removeStockMovements:(NSSet *)value;

- (void)addProductCategoriesObject:(ProductCategory *)value;
- (void)removeProductCategoriesObject:(ProductCategory *)value;
- (void)addProductCategories:(NSSet *)value;
- (void)removeProductCategories:(NSSet *)value;

- (void)addSalesObject:(Sale *)value;
- (void)removeSalesObject:(Sale *)value;
- (void)addSales:(NSSet *)value;
- (void)removeSales:(NSSet *)value;

- (void)addProviderProductsObject:(ProviderProduct *)value;
- (void)removeProviderProductsObject:(ProviderProduct *)value;
- (void)addProviderProducts:(NSSet *)value;
- (void)removeProviderProducts:(NSSet *)value;

@end

