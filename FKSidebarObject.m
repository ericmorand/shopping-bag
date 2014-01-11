// 
//  FKSidebarObject.m
//  FK
//
//  Created by Eric on 20/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKSidebarObject.h"
#import "FKGroup.h"


@implementation FKSidebarObject 

- (NSString *)name
{
    NSString * tmpValue = nil;
    
    [self willAccessValueForKey:@"name"];
    tmpValue = [self primitiveValueForKey:@"name"];
    [self didAccessValueForKey:@"name"];
    
    return tmpValue;
}

- (void)setName:(NSString *)value
{
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveValue:value forKey:@"name"];
    [self didChangeValueForKey:@"name"];
}

- (BOOL)validateName: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

- (NSNumber *)priority 
{
    NSNumber * tmpValue;
    
    [self willAccessValueForKey: @"priority"];
    tmpValue = [self primitiveValueForKey: @"priority"];
    [self didAccessValueForKey: @"priority"];
    
    return tmpValue;
}

- (void)setPriority:(NSNumber *)value 
{
    [self willChangeValueForKey: @"priority"];
    [self setPrimitiveValue: value forKey: @"priority"];
    [self didChangeValueForKey: @"priority"];
}

- (BOOL)validatePriority: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}


- (void)addGroupsObject:(FKGroup *)value 
{    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"groups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [[self primitiveValueForKey: @"groups"] addObject: value];
    
    [self didChangeValueForKey:@"groups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeGroupsObject:(FKGroup *)value 
{
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"groups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [[self primitiveValueForKey: @"groups"] removeObject: value];
    
    [self didChangeValueForKey:@"groups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}


- (FKSidebar *)sidebar 
{
    id tmpObject = nil;
    
    [self willAccessValueForKey:@"sidebar"];
    tmpObject = [self primitiveValueForKey:@"sidebar"];
    [self didAccessValueForKey:@"sidebar"];
    
    return tmpObject;
}

- (void)setSidebar:(FKSidebar *)value 
{
    [self willChangeValueForKey:@"sidebar"];
    [self setPrimitiveValue:value forKey:@"sidebar"];
    [self didChangeValueForKey:@"sidebar"];
}

- (BOOL)validateSidebar:(id *)valueRef error:(NSError **)outError {return YES;}

#pragma mark -
#pragma mark NSCOPYING

- (id)copyWithZone:(NSZone *)zone
{
    FKSidebarObject * copy = [[[self class] allocWithZone:zone] initWithEntity:[self entity] insertIntoManagedObjectContext:[self managedObjectContext]];
	
	[copy setName:[[self name] copy]];
	[copy setPriority:[self priority]];
	[copy setSidebar:[self sidebar]];
	
    return copy;
}

@end
