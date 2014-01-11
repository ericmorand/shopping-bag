//
//  FKMultipleValuesProxy.h
//  ShoppingBag
//
//  Created by Eric on 03/07/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKMultipleValuesProxy : NSObject
{
	NSMutableArray *	objectsArray;
}

- (void)addObject:(id)anObject;

@end
