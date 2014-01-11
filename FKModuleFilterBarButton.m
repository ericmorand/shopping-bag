//
//  FKModulePlateToolbarButton.m
//  FKKit
//
//  Created by Alt on 19/07/06.
//  Copyright 2006 Eric Morand. All rights reserved.
//

#import "FKModuleFilterBarButton.h"
#import "FKModuleFilterBarButtonCell.h"

@interface FKModuleFilterBarButton (Private)

- (NSDictionary *)titleStringAttributes;

@end

@implementation FKModuleFilterBarButton

+ (Class)cellClass {return [FKModuleFilterBarButtonCell class];}

- (id)initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	
	if (nil != self) {
		[self setBezelStyle:NSRecessedBezelStyle];
		[self setShowsBorderOnlyWhileMouseInside:YES];
		[self setButtonType:NSPushOnPushOffButton];
		[[self cell] setControlSize:NSRegularControlSize];
		[self setFont:[NSFont boldSystemFontOfSize:12.0]];
	}
	
	return self;
}

#pragma mark -
#pragma mark LAYOUT

- (void)sizeToFit {
	[self setFrameSize:[[self cell] cellSize]];
}

#pragma mark -
#pragma mark SETTERS

- (void)setRepresentedObject:(id)anObject {
	[[self cell] setRepresentedObject:anObject];
}

@end