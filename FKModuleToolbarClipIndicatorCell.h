//
//  FKModuleToolbarClipIndicatorCell.h
//  FKKit
//
//  Created by alt on 02/10/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKModuleToolbarClipIndicatorCell : NSPopUpButtonCell {
	NSArray *				clippedItems;
	float					horizontalMargin;
	FKModuleToolbar *		toolbar;
	FKModuleToolbarItem *	toolbarItem;
}

@property (nonatomic, retain) NSArray * clippedItems;
@property float horizontalMargin;
@property (assign) FKModuleToolbar * toolbar;
@property (assign) FKModuleToolbarItem * toolbarItem;

@property (readonly) NSColor * foreColor;
@property (readonly) NSShadow * shadow;

- (void)menuItemClicked:(id)sender;
- (void)drawChevronsWithFrame:(NSRect)chevronsFrame inView:(NSView *)controlView;

@end
