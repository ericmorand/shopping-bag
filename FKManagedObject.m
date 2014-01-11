//
//  FKManagedObject.m
//  FKKit
//
//  Created by Eric on 17/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKManagedObject.h"

@interface FKManagedObject (Private)

+ (NSString *)indexedKey;
- (void)setTemporaryImageFilesDictionary:(NSMutableDictionary *)aDictionary;

@end

@implementation FKManagedObject

+ (NSArray *)indexedValuesKeys {return nil;}
+ (NSArray *)uniqueValuesKeys {return nil;}

#pragma mark -

- (void)dealloc {	
	//[self stopKeyValueObserving];
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (id)valueForKey:(NSString *)key
{		
	id valueForKey = nil;
	
	NS_DURING
		
		valueForKey = [super valueForKey:key];
				
	NS_HANDLER
		
		valueForKey = nil;
		
	NS_ENDHANDLER	
	
	return valueForKey;
}

- (id)primitiveValueForKey:(NSString *)key
{		
	id primitiveValueForKey = nil;
	
	NS_DURING
		
		primitiveValueForKey = [super primitiveValueForKey:key];
				
	NS_HANDLER
				
		primitiveValueForKey = nil;
		
	NS_ENDHANDLER	
	
	return primitiveValueForKey;
}

- (NSMutableSet *)mutableSetValueForKey:(NSString *)key
{	
	NSMutableSet * mutableSetValueForKey = nil;
	
	NS_DURING
				
		mutableSetValueForKey = [super mutableSetValueForKey:key];
				
	NS_HANDLER
		
		mutableSetValueForKey = nil;
	
	NS_ENDHANDLER	
	
	return mutableSetValueForKey;
}

- (NSMutableSet *)mutableSetValueForKeyPath:(NSString *)key
{	
	NSMutableSet * mutableSetValueForKeyPath = nil;
	
	NS_DURING
		
		mutableSetValueForKeyPath = [super mutableSetValueForKeyPath:key];
		
	NS_HANDLER
				
		mutableSetValueForKeyPath = nil;
		
	NS_ENDHANDLER	
	
	return mutableSetValueForKeyPath;
}

- (NSNumber *)nextAutoIncrementedValueForKey:(NSString *)key
{
	NSNumber * nextValue = nil;
		
	NSPersistentStoreCoordinator * storeCoordinator = [[self managedObjectContext] persistentStoreCoordinator];
	NSURL * storeUrl = [[NSApp delegate] persistentStoreURL];

	id persistentStore = [storeCoordinator persistentStoreForURL:storeUrl];
	
	NSString * nextUnusedKey = [NSString stringWithFormat:@"NextUnused%@", [key stringByCapitalizingFirstCharacter]];
	NSString * entityName = [[self entity] name];
	
	NSMutableDictionary * metadata = nil;
	NSMutableDictionary * entityDictionary = nil;
	
	if ( persistentStore )
	{
		metadata = [NSMutableDictionary dictionaryWithDictionary:[storeCoordinator metadataForPersistentStore:persistentStore]];
		entityDictionary = [NSMutableDictionary dictionaryWithDictionary:[metadata objectForKey:entityName]];
		
		if ( nil == entityDictionary )
		{
			entityDictionary = [NSMutableDictionary dictionary];
		}
		
		// ...
		
		nextValue = [entityDictionary objectForKey:nextUnusedKey];
		
		if ( nil == nextValue )
		{
			nextValue = [self maxExistingValueForKey:key];
		}
		
		nextValue = [NSNumber numberWithInt:([nextValue intValue] + 1)];
		
		// ...
		
		[entityDictionary setObject:nextValue forKey:nextUnusedKey];
		[metadata setObject:entityDictionary forKey:entityName];
		[storeCoordinator setMetadata:metadata forPersistentStore:persistentStore];
	}
	else
	{
		nextValue = [NSNumber numberWithInt:[[self maxExistingValueForKey:key] intValue] + 1];
	}
	
	return nextValue;
}

- (NSNumber *)maxExistingValueForKey:(NSString *)key
{
	NSNumber * maxValue = nil;
	
	NSManagedObjectContext * moc = [self managedObjectContext];
	NSEntityDescription * entityDescription = [self entity];
	
	NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
	NSSortDescriptor * sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:key ascending:NO] autorelease];

	[request setEntity:entityDescription];    	
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];

	NSArray * results = [moc executeFetchRequest:request error:nil];
	
	if ( [results count] > 0 )
	{
		maxValue = [[results objectAtIndex:0] valueForKey:key];
	}
	else
	{
		maxValue = [NSNumber numberWithInt:0];
	}
	
	return maxValue;
}


#pragma mark -
#pragma mark DERIVED VALUES

- (void)computeDerivedValues {
}

#pragma mark -
#pragma mark KVO

- (void)beginKeyValueObserving {
}

- (void)stopKeyValueObserving {
}

#pragma mark -
#pragma mark MISC

- (void)awakeFromFetch {
	[super awakeFromFetch];

	shouldComputeDerivedValues = YES;
	
	[self computeDerivedValues];
}

- (void)awakeFromInsert {
	[super awakeFromInsert];

	shouldComputeDerivedValues = YES;	
	
	[self setDefaultValues];
	[self computeDerivedValues];
}

- (void)didTurnIntoFault {
	[super didTurnIntoFault];
}

- (void)setDefaultValues {
}

@end
