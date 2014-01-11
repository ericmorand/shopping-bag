// 
//  Address.m
//  ShoppingBag
//
//  Created by Eric on 24/05/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "Address.h"


@implementation Address 

@dynamic name;
@dynamic line1;
@dynamic line2;
@dynamic zipCode;
@dynamic city; 
@dynamic country;

+ (NSSet *)keyPathsForValuesAffectingZipCodeCity {
	return [NSSet setWithObjects:@"zipCode", @"city", nil];
}

+ (NSSet *)keyPathsForValuesAffectingShortDescription {
	return [NSSet setWithObjects:@"line1", @"line2", @"zipCodeCity", nil];
}

#pragma mark -
#pragma mark GETTERS

- (NSString *)zipCodeCity {
	NSMutableString * result = [NSMutableString string];
	
	if ([self.zipCode length] > 0) {
		[result appendFormat:@"%@", self.zipCode];
	}
	
	if ([self.city length] > 0) {
		if ([result length] > 0) {
			[result appendString:@" "];
		}
		
		[result appendFormat:@"%@", self.city];
	}
	
	return [NSString stringWithString:result];
}

- (NSString *)shortDescription {
	NSMutableString * result = [NSMutableString string];
	
	if ([self.line1 length] > 0) {
		[result appendFormat:@"%@", self.line1];
	}
	
	if ([self.zipCodeCity length] > 0) {
		if ([result length] > 0) {
			[result appendString:@" -"];
		}
		
		[result appendFormat:@" %@", self.zipCodeCity];
	}
		
	return [NSString stringWithString:result];
}

#pragma mark -
#pragma mark VALIDATIONS

- (BOOL)validateName: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

- (BOOL)validateLine1:(id *)valueRef error:(NSError **)outError 
{
    return YES;
}

- (BOOL)validateLine2: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

- (BOOL)validateZipCode: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

- (BOOL)validateCity: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

- (BOOL)validateCountry: (id *)valueRef error:(NSError **)outError 
{
    // Insert custom validation logic here.
    return YES;
}

@end
