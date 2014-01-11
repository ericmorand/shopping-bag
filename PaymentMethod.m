// 
//  PaymentMethod.m
//  ShoppingBag
//
//  Created by Eric on 13/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "PaymentMethod.h"


@implementation PaymentMethod 

+ (NSArray *)indexedValuesKeys {return [NSArray arrayWithObjects:@"name", nil];}
+ (NSArray *)uniqueValuesKeys {return [NSArray arrayWithObjects:@"name", nil];}

@dynamic name;

#pragma mark -
#pragma mark GETTERS

- (NSImage *)icon {
	return [NSImage imageNamed:@"PaymentMethods"];
}

#pragma mark -
#pragma mark DEFAULT VALUES

- (void)setDefaultValues {
	self.name = [self uniqueName];
}

- (NSString *)uniqueName {
	NSString * defaultName = NSLocalizedString(@"PaymentMethod", nil);
	NSString * uniqueName = defaultName;
	
//	unsigned index = 0;
//	
//	FKMOCIndexesManager * defaultIndexesManager = [FKMOCIndexesManager defaultManager];
//	
//	while ( ![defaultIndexesManager validateValue:&uniqueName forIndexedKey:@"name" ofObject:self] ) {	
//		index++;
//		
//		uniqueName = [defaultName stringByAppendingFormat:@" (%d)", index];
//	}
//	
	return uniqueName;
}

@end
