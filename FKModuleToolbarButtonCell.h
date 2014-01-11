//
//  FKModuleToolbarButtonCell.h
//  Shopping Bag
//
//  Created by Eric on 11/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FKModuleToolbarButtonCell : NSButtonCell {
	NSString *				firstLine;
	NSString *				secondLine;
	
	NSRect					imageRect;
	NSRect					titleRect;
	
	float					maxLineWidth;
	float					horizontalMargin;
	
	FKModuleToolbar *		toolbar; // Weak reference	
	FKModuleToolbarItem *	toolbarItem; // Weak reference
}

@property (nonatomic, retain) NSString * firstLine;
@property (nonatomic, retain) NSString * secondLine;
@property float maxLineWidth;
@property float	horizontalMargin;
@property (assign) FKModuleToolbar * toolbar;
@property (assign) FKModuleToolbarItem * toolbarItem;

@property (readonly) BOOL usesCustomDrawing;

- (void)calculateLayout;
- (NSImage *)imageToDrawInView:(NSView *)controlView;

@end
