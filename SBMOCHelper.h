//
//  SBMOCHelper.h
//  ShoppingBag
//
//  Created by Eric on 10/03/10.
//  Copyright 2010 Alt Informatique. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBMOCHelper : NSObject {

}

+ (SBMOCHelper *)sharedHelper;

- (NSArray *)fetchObjectsWithEntityName:(NSString *)inEntityName predicate:(NSPredicate *)inPredicate
				 inManagedObjectContext:(NSManagedObjectContext *)inMoc;
- (id)fetchFirstObjectWithEntityName:(NSString *)inEntityName predicate:(NSPredicate *)inPredicate
			  inManagedObjectContext:(NSManagedObjectContext *)inMoc;
- (NSArray *)fetchAllObjectsWithEntityName:(NSString *)inEntityName
					inManagedObjectContext:(NSManagedObjectContext *)inMoc;

@end
