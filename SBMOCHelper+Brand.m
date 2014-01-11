//
//  SBMOCHelper+Brand.m
//  ShoppingBag
//
//  Created by Eric on 10/03/10.
//  Copyright 2010 Alt Informatique. All rights reserved.
//

#import "SBMOCHelper+Brand.h"


@implementation SBMOCHelper (Brand)

- (Brand *)fetchBrandWithName:(NSString *)inName inManagedObjectContext:(NSManagedObjectContext *)inMoc {
	return [self fetchFirstObjectWithEntityName:@"Brand"
									  predicate:[NSPredicate predicateWithFormat:@"name == %@", inName]
						 inManagedObjectContext:inMoc];
}

@end
