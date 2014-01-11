//
//  NSObject_FKAdditions.h
//  FKKit
//
//  Created by Eric on 07/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSObject (FKAdditions)

- (void)propagateValue:(id)value forBinding:(NSString*)binding;

@end
