//
//  NSDecimalNumber_FKAdditions.h
//  FK
//
//  Created by Eric on 28/02/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSDecimalNumber (FKAdditions)

+ (NSDecimalNumber *)hundred;
- (NSDecimalNumber *)opposite;

- (NSDecimalNumber *)rateFrom:(NSDecimalNumber *)decimalNumber;
- (NSDecimalNumber *)decimalNumberByAddingRate:(NSDecimalNumber *)rate;
- (NSDecimalNumber *)decimalNumberByRemovingRate:(NSDecimalNumber *)rate;
- (NSDecimalNumber *)decimalNumberBySubtractingRate:(NSDecimalNumber *)rate;

- (BOOL)isEqualToZero;
- (BOOL)isPositive;
- (BOOL)isNegative;

@end
