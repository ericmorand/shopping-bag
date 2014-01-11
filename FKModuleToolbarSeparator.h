//
//  FKModuleToolbarSeparator.h
//  FKKit
//
//  Created by Alt on 20/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKModuleToolbarSeparator : NSView
{
	FKModuleToolbar *		toolbar; // Weak reference	
	FKModuleToolbarItem *	toolbarItem; // Weak reference
}

- (void)setToolbar:(FKModuleToolbar *)aToolbar;
- (void)setToolbarItem:(FKModuleToolbarItem *)anItem;

@property (assign,setter=setToolbar:) FKModuleToolbar *		toolbar;
@property (assign,setter=setToolbarItem:) FKModuleToolbarItem *	toolbarItem;
@end
