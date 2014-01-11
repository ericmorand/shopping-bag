//
//  ProviderProduct.h
//  ShoppingBag
//
//  Created by Eric on 07/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Product;
@class Provider;

@interface ProviderProduct :  FKManagedObject {
}

@property (nonatomic, retain) NSDecimalNumber * tauxMarge;  // Tmg = ((PV HT - PA HT) / PA HT)
@property (nonatomic, retain) NSDecimalNumber * tauxMarque;	// Tmq = ((PV HT - PA HT) / PV HT); ATTENTION : DOIT ETRE STRICTEMENT INFERIEUR A 1
@property (nonatomic, retain) NSDecimalNumber * coefficientMultiplicateur; // Cm = PV TTC / PA HT
@property (nonatomic, retain) NSDecimalNumber * providerPriceTTC;
@property (nonatomic, retain) NSString * providerReference;
@property (nonatomic, retain) NSDecimalNumber * providerPriceHT;
@property (nonatomic, retain) Product * product;
@property (nonatomic, retain) Provider * provider;

@end



