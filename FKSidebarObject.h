//
//  FKSidebarObject.h
//  FK
//
//  Created by Eric on 20/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <CoreData/CoreData.h>

@class FKGroup;
@class FKSidebar;

@interface FKSidebarObject :  NSManagedObject <NSCopying>
{
}

- (NSString *)name;
- (void)setName:(NSString *)value;
- (BOOL)validateName:(id *)valueRef error:(NSError **)outError;

- (NSNumber *)priority;
- (void)setPriority:(NSNumber *)value;
- (BOOL)validatePriority:(id *)valueRef error:(NSError **)outError;

// Access to-many relationship via -[NSObject mutableSetValueForKey:]

- (void)addGroupsObject:(FKGroup *)value;
- (void)removeGroupsObject:(FKGroup *)value;

- (FKSidebar *)sidebar;
- (void)setSidebar:(FKSidebar *)value;
- (BOOL)validateSidebar:(id *)valueRef error:(NSError **)outError;

@end
