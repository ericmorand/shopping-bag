//
//  FKModuleToolbarItem.h
//  FKKit
//
//  Created by Alt on 19/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * FKModuleToolbarDoneItemIdentifier;
extern NSString * FKModuleToolbarNavigationItemIdentifier;
extern NSString * FKModuleToolbarSeparatorItemIdentifier;
extern NSString * FKModuleToolbarFlexibleSpaceItemIdentifier;


@interface FKModuleToolbarItem : NSObject {
	FKModuleToolbar *			toolbar; // Weak reference
	NSString *					itemIdentifier;
	NSString *					label;
	id							target;
	SEL							action;	
	BOOL						isSelected;
	id							view;
	NSInteger					toolbarAreaIndex;
	NSInteger					tag;
	NSImage *					image;
	NSImage *					alternateImage;
	BOOL						isEnabled;
	BOOL						shouldDrawLabel;
}

@property (assign) FKModuleToolbar * toolbar;
@property (nonatomic, retain) NSString * itemIdentifier;
@property (nonatomic, retain) NSString * label;
@property (assign) id target;
@property SEL action;
@property (setter=setSelected:) BOOL isSelected;
@property (nonatomic, retain) id view;
@property NSInteger	toolbarAreaIndex;
@property NSInteger	tag;
@property (nonatomic, copy) NSImage * image;
@property (nonatomic, copy) NSImage * alternateImage;
@property (setter=setEnabled:) BOOL isEnabled;
@property BOOL shouldDrawLabel;

- (id)initWithItemIdentifier:(NSString *)aString;
- (void)update;

@end

@protocol FKValidatedModuleToolbarItem <NSValidatedUserInterfaceItem>

- (BOOL)validateModuleToolbarItem:(FKModuleToolbarItem *)theItem;

@end
