//
//  NSAlert_FKAdditions.h
//  FKKit
//
//  Created by Eric on 29/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSAlert (FKAdditions)

- (NSPanel *)panel;

- (void)setDontWarnMessage:(NSString *)aString;


@end
