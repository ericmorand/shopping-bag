//
//  NSString_FKAdditions.h
//  FKKit
//
//  Created by Eric on 21/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSString (FKAdditions)

- (NSString *)stringByCapitalizingFirstCharacter;
- (NSString *)stringByLowercasingFirstCharacter;

- (NSComparisonResult)numericCompare:(NSString *)aString;

@end
