//
//  NSRectFunctions_FKAdditions.h
//  FKKit
//
//  Created by Eric on 12/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import <Cocoa/Cocoa.h>


static inline NSRect NSBigRect()
{
	return NSMakeRect(0.0, 0.0, 10000.0, 10000.0);
}
