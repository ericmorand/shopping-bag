//
//  FKGroup.h
//  FKKit
//
//  Created by Eric on 15/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FKSidebarObject.h"


@interface FKGroup :  FKSidebarObject  
{
}

+ (FKGroup *)groupInContext:(NSManagedObjectContext *)context;

- (NSString *)copyName;

// Access to-many relationship via -[NSObject mutableSetValueForKey:]
- (void)addObjectsObject:(NSManagedObject *)value;
- (void)removeObjectsObject:(NSManagedObject *)value;

- (void)setUniqueName;

@end
