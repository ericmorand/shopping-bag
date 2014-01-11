//
//  FKSmartGroup.h
//  FKKit
//
//  Created by Eric on 25/04/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FKSidebarObject.h"


@interface FKSmartGroup : FKSidebarObject
{
    NSFetchRequest *	fetchRequest;	
    NSPredicate *		predicate;         
    NSSet *				managedObjects;
}

+ (FKSmartGroup *)smartGroupInContext:(NSManagedObjectContext *)context;

- (NSString *)fetchedEntityName;
- (NSFetchRequest *)fetchRequest;
- (NSPredicate *)predicate;
- (NSData *)predicateData;
- (NSSet *)managedObjects;

- (void)setFetchedEntityName:(NSString *)value;
- (void)setFetchRequest:(NSFetchRequest *)newRequest;
- (void)setManagedObjects:(NSSet *)newSet;
- (void)setPredicate:(NSPredicate *)newPredicate;
- (void)setPredicateData:(NSData *)value;
- (void)setUniqueName;

- (BOOL)validatePredicateData:(id *)valueRef error:(NSError **)outError;
- (BOOL)validateFetchedEntityName:(id *)valueRef error:(NSError **)outError;

- (void)refresh;

@end
