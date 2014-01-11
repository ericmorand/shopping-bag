//
//  SBMOCHelper+ProductFamily.m
//  ShoppingBag
//
//  Created by Eric on 10/03/10.
//  Copyright 2010 Alt Informatique. All rights reserved.
//

#import "SBMOCHelper+ProductFamily.h"


@implementation SBMOCHelper (ProductFamily)

- (ProductFamily *)fetchProductFamilyWithName:(NSString *)inName inManagedObjectContext:(NSManagedObjectContext *)inMoc {
	return [self fetchFirstObjectWithEntityName:@"ProductFamily"
									  predicate:[NSPredicate predicateWithFormat:@"name == %@", inName]
						 inManagedObjectContext:inMoc];
}

@end
