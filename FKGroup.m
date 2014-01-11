// 
//  FKGroup.m
//  FKKit
//
//  Created by Eric on 15/06/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKGroup.h"


@implementation FKGroup 

+ (FKGroup *)groupInContext:(NSManagedObjectContext *)context
{
	return [[[FKGroup alloc] initWithEntity:[NSEntityDescription entityForName:@"FKGroup" inManagedObjectContext:context] insertIntoManagedObjectContext:context] autorelease];
}

- (void)addObjectsObject:(NSManagedObject *)value 
{    
    NSSet * changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"objects" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"objects"] addObject:value];
    [self didChangeValueForKey:@"objects" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)removeObjectsObject:(NSManagedObject *)value 
{
    NSSet * changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    
    [self willChangeValueForKey:@"objects" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"objects"] removeObject:value];
    [self didChangeValueForKey:@"objects" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    
    [changedObjects release];
}

- (void)setUniqueName
{
	NSString * defaultName = NSLocalizedStringFromTable(@"Groupe", @"ItemsLocalized", nil);
	
	int index = 1;	
	
	NSString * groupName = [defaultName stringByAppendingFormat:@" %d", index];	
	
	NSError * error = nil;
	
	while ( ![self validateValue:&groupName forKey:@"name" error:&error] )
	{
		index++;
		
		groupName = [defaultName stringByAppendingFormat:@" %d", index];
	}
	
	[self setName:groupName];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateName:(id *)valueRef error:(NSError **)outError 
{
	NSString * errorString = nil;
	NSString * suggestionString = nil;
	NSDictionary * userInfo = nil;
	NSError * error = nil;
	
	// Le nom du groupe doit etre defini
	
	if ( ( *valueRef == nil ) || ( [*valueRef isEqualToString:@""] ) )
	{
		errorString = NSLocalizedStringFromTable(@"InvalidName", @"MessagesLocalized", @"");
		suggestionString = NSLocalizedStringFromTable(@"FKSmartGroupNameBlank", @"MessagesLocalized", @"");
		
		userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, suggestionString, NSLocalizedRecoverySuggestionErrorKey, nil];
		
		error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationErrorMinimum userInfo:userInfo];
		
		*outError = error;		
		
		return NO;
	}
	
    // Le nom du groupe doit etre unique
	
	NSArray * results = nil;
    NSPredicate * aPredicate = nil;
	NSFetchRequest * aFetchRequest = nil;
	
	aPredicate = [NSPredicate predicateWithFormat:@"(SELF != %@) AND (name LIKE %@)", self, *valueRef];	
	aFetchRequest = [[[NSFetchRequest alloc] init] autorelease];
	
	[aFetchRequest setEntity:[self entity]];
	[aFetchRequest setPredicate:aPredicate];
	
	results = [[self managedObjectContext] executeFetchRequest:aFetchRequest error:nil];
	
	if ( [results count] > 0 )
	{
		errorString = [NSString stringWithFormat:NSLocalizedStringFromTable(@"InvalidName", @"MessagesLocalized", @""), *valueRef];
		suggestionString = [NSString stringWithFormat:NSLocalizedStringFromTable(@"FKSmartGroupNameAlreadyExists", @"MessagesLocalized", @""), *valueRef];
		
		userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, suggestionString, NSLocalizedRecoverySuggestionErrorKey, nil];
		
		error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationErrorMinimum userInfo:userInfo];
		
		*outError = error;
		
		return NO;
	}
	
    return YES;
}

#pragma mark -
#pragma mark MISC

- (void)awakeFromInsert
{
	[super awakeFromInsert];
	
	[self setUniqueName];
}

#pragma mark -
#pragma mark NSCOPYING

- (id)copyWithZone:(NSZone *)zone
{
    FKGroup * copy = [super copyWithZone:zone];
		
	[copy setName:[self copyName]];
	
	// Objects
	
	NSMutableSet * objectSet = [self mutableSetValueForKey:@"objects"];
	FKSidebarObject * anObject = nil;
	
	for ( anObject in objectSet )
	{
		[copy addObjectsObject:[anObject copy]];
	}
	
    return copy;
}

- (NSString *)copyName
{
	NSString * defaultName = [[self name] stringByAppendingString:@" - copie"];
	
	int index = 1;	
	
	NSString * copyName = defaultName;
	
	NSError * error = nil;
	
	while ( ![self validateValue:&copyName forKey:@"name" error:&error] )
	{
		index++;
		
		copyName = [defaultName stringByAppendingFormat:@" %d", index];
	}
	
	return copyName;
}

@end
