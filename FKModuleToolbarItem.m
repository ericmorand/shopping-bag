//
//  FKModuleToolbarItem.m
//  FKKit
//
//  Created by Alt on 19/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleToolbarItem.h"
#import "FKModuleToolbarButton.h"

NSString * FKModuleToolbarDoneItemIdentifier = @"FKModuleToolbarDoneItemIdentifier";
NSString * FKModuleToolbarNavigationItemIdentifier = @"FKModuleToolbarNavigationItemIdentifier";
NSString * FKModuleToolbarSeparatorItemIdentifier = @"FKModuleToolbarSeparatorItemIdentifier";
NSString * FKModuleToolbarFlexibleSpaceItemIdentifier = @"FKModuleToolbarFlexibleSpaceItemIdentifier";

@interface FKModuleToolbarItem (Private)

@end

@implementation FKModuleToolbarItem

@synthesize toolbar;
@synthesize itemIdentifier;
@synthesize label;
@synthesize target;
@synthesize action;
@synthesize isSelected;
@synthesize view;
@synthesize toolbarAreaIndex;
@synthesize tag;
@synthesize image;
@synthesize alternateImage;
@synthesize isEnabled;
@synthesize shouldDrawLabel;

- (id)initWithItemIdentifier:(NSString *)aString
{
	self = [super init];
	
	if ( self )
	{
		self.itemIdentifier = aString;
		self.shouldDrawLabel = NO;
	}
	
	return self;
}

- (void)dealloc
{
	self.toolbar = nil;
	self.itemIdentifier = nil;
	self.label = nil;
	self.target = nil;
	self.action = nil;
	self.view = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark GETTERS

- (id)view {
	if (nil == view) {
		id aButton = [[[[toolbar buttonClass] alloc] initWithFrame:NSZeroRect] autorelease];
		
		[aButton setToolbar:toolbar];
		[aButton setToolbarItem:self];
		[aButton setTarget:self];
		[aButton setAction:@selector(buttonAction:)];
		[aButton setTitle:[self label]];
		[aButton setImage:[self image]];
		[aButton setAlternateImage:[self alternateImage]];
		[aButton sizeToFit];
		
		NSRect buttonFrame = [aButton frame];
		
		buttonFrame.size.height = [toolbar itemHeight];
		
		[aButton setFrame:buttonFrame];
		
		self.view = aButton;
	}
	
	return view;
}

#pragma mark -
#pragma mark SETTERS

- (void)setToolbar:(FKModuleToolbar *)aToolbar {
	if (aToolbar != toolbar) {
		toolbar = aToolbar;
		
		if ([view isKindOfClass:[FKModuleToolbarButton class]]) {
			[(FKModuleToolbarButton *)view setToolbar:toolbar];
		}
	}
}

- (void)setLabel:(NSString *)aString
{
	if ( ![aString isEqualToString:label] )
	{
		[label release];
		label = [aString retain];
		
		[view setTitle:label];
		[toolbar tile];
	}
}

- (void)setImage:(NSImage *)anImage {
	if (anImage != image) {
		[image release];
		image = [anImage copy];
		
		if ([view respondsToSelector:@selector(setImage:)]) {
			[view setImage:anImage];
			[toolbar tile];
		}
	}
}

- (void)setEnabled:(BOOL)flag {
	isEnabled = flag;
				
	[view setEnabled:flag];
}

#pragma mark -
#pragma mark ACTIONS

- (void)buttonAction:(id)sender
{
	[toolbar toolbarItemClicked:self];
}

#pragma mark -
#pragma mark VALIDATIONS

- (void)update {
	id validator = [NSApp targetForAction:[self action] to:[self target] from:self];
	
	if (nil != validator) {
		if (![validator respondsToSelector:[self action]]) {
			self.isEnabled = NO;
		}
		else if ([validator respondsToSelector:@selector(validateModuleToolbarItem:)]) {
			self.isEnabled = [validator validateModuleToolbarItem:self];
		}
	}
	else {
		self.isEnabled = YES;
	}
}

@end
