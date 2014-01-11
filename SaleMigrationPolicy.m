//
//  SaleMigrationPolicy.m
//  ShoppingBag
//
//  Created by Eric on 07/04/13.
//  Copyright 2013 Alt Informatique. All rights reserved.
//

#import "SaleMigrationPolicy.h"
#import "Sale.h"

@implementation SaleMigrationPolicy

- (BOOL)createRelationshipsForDestinationInstance:(Sale *)dInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error {
	NSManagedObjectContext *destinationMoc = manager.destinationContext;
	NSArray *results = nil;
	NSLog(@"%@", dInstance);
	if (dInstance.saleLines == nil) {
		// retrieve stock movements based on sale number
		NSEntityDescription *stockMovementEntity = [NSEntityDescription entityForName:@"StockMovement" inManagedObjectContext:destinationMoc];
		NSString *reason = nil;
		NSString *saleNumber = nil;
		
		NSPredicate *predicate = nil;
		NSFetchRequest *request = nil;
		
		predicate = [NSPredicate predicateWithFormat:@"reason == %@", [NSString stringWithFormat:@"Vente n°%@", dInstance.saleNumber]];
		request = [[[NSFetchRequest alloc] init] autorelease];
		
		[request setEntity:stockMovementEntity];
		[request setPredicate:predicate];
		
		results = [destinationMoc executeFetchRequest:request error:nil];
		
		NSLog(@"%@", results); return NO;
	}
	
	return YES;
}

@end
