//
//  SBMOCHelper.m
//  ShoppingBag
//
//  Created by Eric on 10/03/10.
//  Copyright 2010 Alt Informatique. All rights reserved.
//

#import "SBMOCHelper.h"

static SBMOCHelper *sharedHelper = nil;

@implementation SBMOCHelper

+ (SBMOCHelper *)sharedHelper {
	if (nil == sharedHelper) {
		sharedHelper = [[SBMOCHelper alloc] init];
	}
	
	return sharedHelper;
}

#pragma mark -
#pragma mark GETTERS

- (NSArray *)fetchObjectsWithEntityName:(NSString *)inEntityName
							  predicate:(NSPredicate *)inPredicate
				 inManagedObjectContext:(NSManagedObjectContext *)inMoc {
	NSArray *results = nil;
	
	NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	NSEntityDescription * entity = [NSEntityDescription entityForName:inEntityName inManagedObjectContext:inMoc];
	
	[fetchRequest setEntity:entity];
	
	if (inPredicate != nil) {
		[fetchRequest setPredicate:inPredicate];
	}
	
	results = [inMoc executeFetchRequest:fetchRequest error:nil];
	
	return results;
}

- (NSArray *)fetchAllObjectsWithEntityName:(NSString *)inEntityName
					inManagedObjectContext:(NSManagedObjectContext *)inMoc {
	return [self fetchObjectsWithEntityName:inEntityName predicate:nil inManagedObjectContext:inMoc];
}

- (id)fetchFirstObjectWithEntityName:(NSString *)inEntityName
						   predicate:(NSPredicate *)inPredicate
			  inManagedObjectContext:(NSManagedObjectContext *)inMoc {
	id result = nil;
	
	NSArray *results = [self fetchObjectsWithEntityName:inEntityName predicate:inPredicate inManagedObjectContext:inMoc];
	
	if ([results count] > 0) {
		result = [results objectAtIndex:0];
	}
	
	return result;
}

@end
