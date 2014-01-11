//
//  FKManagedObject.h
//  FKKit
//
//  Created by Eric on 17/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKManagedObject : NSManagedObject {
	BOOL shouldComputeDerivedValues;
}

+ (NSArray *)indexedValuesKeys;
+ (NSArray *)uniqueValuesKeys;

- (NSNumber *)nextAutoIncrementedValueForKey:(NSString *)key;
- (NSNumber *)maxExistingValueForKey:(NSString *)key;

- (void)setDefaultValues;
- (void)computeDerivedValues;
- (void)beginKeyValueObserving;
- (void)stopKeyValueObserving;

@end