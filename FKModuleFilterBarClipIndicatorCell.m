//
//  FKModulePlateToolbarClipIndicatorCell.m
//  Shopping Bag
//
//  Created by Eric on 11/06/07.
//  Copyright 2007 Eric Morand. All rights reserved.
//

#import "FKModuleFilterBarClipIndicatorCell.h"
#import "FKModuleFilterBarClipIndicator.h"


@implementation FKModuleFilterBarClipIndicatorCell

@synthesize bezelCell;

- (id)init {
	self = [super init];
    
	if (nil != self) {
		horizontalMargin = 10.0;
		
		self.bezelCell = [[[NSButtonCell alloc] init] autorelease];
		
		[bezelCell setBezelStyle:NSRecessedBezelStyle];
		[bezelCell setButtonType:NSPushOnPushOffButton];
		[bezelCell setShowsBorderOnlyWhileMouseInside:YES];
		[bezelCell setControlSize:NSRegularControlSize];
		[bezelCell setTitle:@">>"];
	}
	
    return self;
}

- (NSInteger)state {
	for (FKModuleToolbarItem * anItem in self.clippedItems) {		
		if ([anItem isSelected]) {
			return NSOnState;
		}
	}
	
	return NSOffState;
}

- (NSSize)cellSize {
	return [bezelCell cellSize];
}

#pragma mark -
#pragma mark DRAWING

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	[bezelCell setState:[self state]];
			
	if ([self state] == NSOnState) {
		[bezelCell drawBezelWithFrame:cellFrame inView:controlView];
	}
		
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
