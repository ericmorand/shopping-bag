// 
//  FKSmartGroup.m
//  FKKit
//
//  Created by Eric on 25/04/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKSmartGroup.h"


@implementation FKSmartGroup 

+ (FKSmartGroup *)smartGroupInContext:(NSManagedObjectContext *)context
{
	return [[[FKSmartGroup alloc] initWithEntity:[NSEntityDescription entityForName:@"FKSmartGroup" inManagedObjectContext:context] insertIntoManagedObjectContext:context] autorelease];
}

- (void)dealloc
{
	[self setManagedObjects:nil];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (NSString *)fetchedEntityName 
{
    NSString * tmpValue = nil;
    
    [self willAccessValueForKey:@"fetchedEntityName"];
    tmpValue = [self primitiveValueForKey:@"fetchedEntityName"];
    [self didAccessValueForKey:@"fetchedEntityName"];
    
    return tmpValue;
}

- (NSFetchRequest *)fetchRequest
{
    if ( fetchRequest == nil )
	{
        [self setFetchRequest:[[[NSFetchRequest alloc] init] autorelease]];
		
        [fetchRequest setEntity: [NSEntityDescription entityForName:[self fetchedEntityName] inManagedObjectContext:[self managedObjectContext]]];
        [fetchRequest setPredicate:[self predicate]];
    }
    
    return fetchRequest;
}

- (NSData *)predicateData 
{
    NSData * tmpValue = nil;
    
    [self willAccessValueForKey:@"predicateData"];
    tmpValue = [self primitiveValueForKey:@"predicateData"];
    [self didAccessValueForKey:@"predicateData"];
    
    return tmpValue;
}

- (NSPredicate *)predicate
{	
    NSData * predicateData = nil;
	
    if ( predicate == nil )
	{
        predicateData = [self predicateData];
		
        if ( predicateData != nil )
		{
            predicate = [(NSPredicate *)[NSKeyedUnarchiver unarchiveObjectWithData:predicateData] retain];
        }
    }
    
    return predicate;
}

- (NSSet *)managedObjects
{
    if ( managedObjects == nil )
	{
        NSError * error = nil;
        NSArray * results = nil;
        
		NS_DURING
			
			results = [[self managedObjectContext] executeFetchRequest:[self fetchRequest] error:&error];
			
		NS_HANDLER
			
			//[localException raise];
			
			NSLog ([localException reason]);
			
		NS_ENDHANDLER
        
		if ( error != nil || results == nil )
		{
			[self setManagedObjects:[NSSet set]];
		}
		else
		{
			[self setManagedObjects:[NSSet setWithArray:results]];
		}
	}
	
    return managedObjects;
}

#pragma mark -
#pragma mark SETTERS

- (void)setFetchedEntityName:(NSString *)value 
{
    [self willChangeValueForKey:@"fetchedEntityName"];
    [self setPrimitiveValue:value forKey:@"fetchedEntityName"];
    [self didChangeValueForKey:@"fetchedEntityName"];
}

- (void)setFetchRequest:(NSFetchRequest *)newRequest
{
	if ( newRequest != fetchRequest )
	{
		[fetchRequest release];
		fetchRequest = [newRequest retain];
	}
}

- (void)setManagedObjects:(NSSet *)newSet
{
	if ( newSet != managedObjects )
	{
		[managedObjects release];
		managedObjects = [newSet retain];
	}
}

- (void)setPredicateData:(NSData *)value 
{
    [self willChangeValueForKey:@"predicateData"];
    [self setPrimitiveValue:value forKey:@"predicateData"];
    [self didChangeValueForKey:@"predicateData"];
}

- (void)setPredicate:(NSPredicate *)newPredicate
{
    if ( newPredicate != predicate )
	{
        [predicate release];
		
        if ( newPredicate == nil )
		{
            newPredicate = [NSPredicate predicateWithValue:YES];
        }
        
        predicate = [newPredicate retain];
		
		NSData * predicateData = [NSKeyedArchiver archivedDataWithRootObject:predicate];
		
		[self setPredicateData:predicateData];
    }
}

- (void)setUniqueName
{
	NSString * defaultName = NSLocalizedStringFromTable(@"Groupe intelligent", @"ItemsLocalized", nil);
	
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

- (BOOL)validateFetchedEntityName:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateName:(id *)valueRef error:(NSError **)outError 
{
	NSString * errorString = nil;
	NSString * suggestionString = nil;
	NSDictionary * userInfo = nil;
	NSError * error = nil;
	
	// Le nom du groupe doit etre defini
	
	if ( ( *valueRef == nil ) || ( [*valueRef isEqualToString:@""] ) )
	{
		errorString = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"InvalidName", nil, [NSBundle bundleForClass:[self class]], @""), *valueRef];
		suggestionString = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"FKSmartGroupNameBlank", nil, [NSBundle bundleForClass:[self class]], @""), *valueRef];		
		
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
		errorString = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"InvalidName", nil, [NSBundle bundleForClass:[self class]], @""), *valueRef];
		suggestionString = [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"FKSmartGroupNameAlreadyExists", nil, [NSBundle bundleForClass:[self class]], @""), *valueRef];
		
		userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errorString, NSLocalizedDescriptionKey, suggestionString, NSLocalizedRecoverySuggestionErrorKey, nil];
		
		error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSValidationErrorMinimum userInfo:userInfo];
		
		*outError = error;
		
		return NO;
	}
	
    return YES;
}

- (BOOL)validatePredicateData: (id *)valueRef error:(NSError **)outError 
{
    return YES;
}

#pragma mark -
#pragma mark MISC

- (void)awakeFromInsert
{
	[super awakeFromInsert];
	
	[self setUniqueName];
	[self setPredicate:[NSPredicate predicateWithValue:YES]];
}

- (void)refresh
{
	[self setManagedObjects:nil];
}

#pragma mark -
#pragma mark NSCOPYING

- (id)copyWithZone:(NSZone *)zone
{
    FKSmartGroup * copy = [super copyWithZone:zone];
	
	[copy setName:[self copyName]];
	[copy setFetchedEntityName:[[self fetchedEntityName] copy]];
	[copy setPredicateData:[[self predicateData] copy]];
	
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
