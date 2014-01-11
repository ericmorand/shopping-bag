// 
//  Provider.m
//  ShoppingBag
//
//  Created by Eric on 09/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "Provider.h"

#import "Address.h"
#import "PaymentMethod.h"
#import "ProviderProduct.h"

@interface Provider (Private)

- (NSString *)uniqueName;

@end

@implementation Provider 

@dynamic phoneNumber;
@dynamic notes;
@dynamic faxNumber;
@dynamic emailAddress;
@dynamic iconData;
@dynamic name;
@dynamic icon;
@dynamic providerProducts;
@dynamic paymentMethod;
@dynamic addresses;

+ (NSArray *)indexedValuesKeys {return [NSArray arrayWithObjects:@"name", nil];}

#pragma mark -
#pragma mark GETTERS

- (NSImage *)icon {
//	  [self willAccessValueForKey:@"icon"];
//    NSImage * icon = [self primitiveValueForKey:@"icon"];
//    [self didAccessValueForKey:@"icon"];
//	
//    if ( icon == nil )
//	{
//        NSData * iconData = [self valueForKey:@"iconData"];
//		
//        if ( iconData != nil )
//		{
//            icon = [NSKeyedUnarchiver unarchiveObjectWithData:iconData];
//			
//            [self setPrimitiveValue:icon forKey:@"icon"];
//        }
//    }
//	
//    return icon;
	
	return [NSImage imageNamed:@"Providers"];
}

- (NSArray *)products {
	NSMutableArray * products = [NSMutableArray array];
	
	NSMutableSet * providerProductsSet = [self mutableSetValueForKey:@"providerProducts"];
	ProviderProduct * aProviderProduct = nil;
	
	for ( aProviderProduct in providerProductsSet ) {
		[products addObject:[aProviderProduct product]];
	}
	
	return products;
}

#pragma mark -
#pragma mark DEFAULT VALUES

- (void)setDefaultValues {
	[self setName:[self uniqueName]];
	[self setIcon:[NSImage imageNamed:@"NSApplicationIcon"]];
}

- (NSString *)uniqueName {
	NSString * defaultName = NSLocalizedString(@"NewProvider", nil);
	NSString * uniqueName = defaultName;
	
//	unsigned index = 0;
//	
//	FKMOCIndexesManager * defaultIndexesManager = [FKMOCIndexesManager defaultManager];
//	
//	while ( ![defaultIndexesManager validateValue:&uniqueName forIndexedKey:@"name" ofObject:self] )
//	{		
//		index++;
//		
//		uniqueName = [defaultName stringByAppendingFormat:@" (%d)", index];
//	}
	
	return uniqueName;
}

#pragma mark -
#pragma mark MISC

- (void)willSave {
    NSImage * icon = [self primitiveValueForKey:@"icon"];
	
	id tmpValue = nil;
	
    if ( icon != nil )
	{
        tmpValue = [NSKeyedArchiver archivedDataWithRootObject:icon];
    }
	
	[self setPrimitiveValue:tmpValue forKey:@"iconData"];
	
    [super willSave];
}

@end
