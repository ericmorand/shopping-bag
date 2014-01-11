//
//  SaleLineMigrationPolicy.m
//  ShoppingBag
//
//  Created by Eric on 27/12/10.
//  Copyright 2010 Alt Informatique. All rights reserved.
//

#import "SaleLineMigrationPolicy.h"
#import "SaleLine.h"
#import "Product.h"
#import "TaxRate.h"

@implementation SaleLineMigrationPolicy

static num = 0;

- (BOOL)create2DestinationInstancesForSourceInstance:(SaleLine *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error {	
	NSManagedObjectContext *destinationMoc = manager.destinationContext;
	SaleLine *destination = [NSEntityDescription insertNewObjectForEntityForName:@"SaleLine" inManagedObjectContext:destinationMoc];	
	Product *product = nil;
	
	NSArray *allKeys = [[[sInstance entity] attributesByName] allKeys];
	id value = nil;
	
	for (NSString *key in allKeys) {
		value = [sInstance valueForKey:key];
		
		if ([key isEqualToString:@"productTaxRate"]) {			
			if (value == nil) {				
				product = [sInstance valueForKey:@"product"];
				value = product.taxRate.rate;
				
				if (value == nil) {
					value = [NSDecimalNumber zero];
				}
			}
		}

		[destination setValue:value forKey:key];
	}
	
	NSArray *results = nil;
	
	// sale
	Sale *sale = nil;
	
	if (sInstance.sale != nil) {
		NSArray *sales = [manager destinationInstancesForEntityMappingNamed:@"SaleToSale" sourceInstances:[NSArray arrayWithObject:sInstance.sale]];
		
		if ([sales count] > 0) {
			sale = [sales objectAtIndex:0];
		}
	}
	
	// stock movement
	StockMovement *stockMovement = nil;
	
	if (sInstance.stockMovement != nil) {
		NSArray *stockMovements = [manager destinationInstancesForEntityMappingNamed:@"StockMovementToStockMovement" sourceInstances:[NSArray arrayWithObject:sInstance.stockMovement]];
		
		if ([stockMovements count] > 0) {
			stockMovement = [stockMovements objectAtIndex:0];
		}
	}
	
	NSEntityDescription *stockMovementEntity = [NSEntityDescription entityForName:@"StockMovement" inManagedObjectContext:destinationMoc];
	NSEntityDescription *saleEntity = [NSEntityDescription entityForName:@"Sale" inManagedObjectContext:destinationMoc];
	NSString *reason = nil;
	NSString *saleNumber = nil;
	
	NSPredicate *predicate = nil;
	NSFetchRequest *request = nil;

	// retrieve stock movement
	if (stockMovement == nil) {
		predicate = [NSPredicate predicateWithFormat:@"saleLine == %@", sInstance];
		request = [[NSFetchRequest alloc] init];
	
		[request setEntity:stockMovementEntity];
		[request setPredicate:predicate];
	
		results = [destinationMoc executeFetchRequest:request error:nil];
	
		[request release];
	
		if ([results count] < 1) {
			destination = nil;
		}
		else {	
			stockMovement = [results objectAtIndex:0];
		}
	}
	
	// retrieve sale
	if (sale == nil) {
		reason = [stockMovement reason];
			
		NSRange range = [reason rangeOfString:@"Vente n°"];
			
		if (range.location != NSNotFound) {
			saleNumber = [reason substringFromIndex:range.location + range.length];
				
			predicate = [NSPredicate predicateWithFormat:@"saleNumber == %@", saleNumber];
			request = [[NSFetchRequest alloc] init];
				
			[request setEntity:saleEntity];
			[request setPredicate:predicate];
				
			results = [destinationMoc executeFetchRequest:request error:nil];
				
			[request release];
				
			if ([results count] < 1) {
				destination = nil;
			}
			else {
				sale = [results objectAtIndex:0];
			}
		}
	}
	
	// product
	Product *destinationProduct = nil;
	
	if (sInstance.product != nil) {
		NSArray *destinationProducts = [manager destinationInstancesForEntityMappingNamed:@"ProductToProduct" sourceInstances:[NSArray arrayWithObject:sInstance.product]];
		
		if ([destinationProducts count] > 0) {
			destinationProduct = [destinationProducts objectAtIndex:0];
		}
	}
	
	if (destinationProduct == nil) {
		destination = nil;
	}
	
	if (destination) {
		[destination setSale:sale];
		[destination setStockMovement:stockMovement];
		[destination setProduct:destinationProduct];
		
		[manager associateSourceInstance:sInstance withDestinationInstance:destination forEntityMapping:mapping];
	}
	
	num++;
	
	NSLog(@"%d", num);
	
	return YES;
}

@end
