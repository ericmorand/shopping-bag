//
//  NSDate_FKAdditions.h
//  FKKit
//
//  Created by Eric on 15/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSDate (FKAdditions)

- (NSDate *)firstSecond;
- (NSDate *)lastSecond;

+ (NSDate *)yesterday;

@end
