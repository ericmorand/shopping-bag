//
//  FKModuleToolbarButton.h
//  FKKit
//
//  Created by Alt on 19/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKModuleToolbarButton : NSButton {
	BOOL					mouseOver;
}

@property (readonly) FKModuleToolbar * toolbar;
@property (readonly) FKModuleToolbarItem * toolbarItem;

- (FKModuleToolbar *)toolbar;
- (FKModuleToolbarItem *)toolbarItem;
- (BOOL)mouseOver;

- (BOOL)isSelected;

- (void)setToolbar:(FKModuleToolbar *)aToolbar;
- (void)setToolbarItem:(FKModuleToolbarItem *)anItem;
- (void)setMouseOver:(BOOL)flag;

@property (getter=mouseOver,setter=setMouseOver:) BOOL					mouseOver;

@end
