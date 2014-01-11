//
//  FKArrayController.m
//  FKKit
//
//  Created by Eric on 18/10/09.
//  Copyright 2009 Alt Informatique. All rights reserved.
//

#import "FKManagedArrayController.h"


@implementation FKManagedArrayController

@synthesize selectedObject;

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (nil != self) {
		[self addObserver:self forKeyPath:@"selection" options:0 context:nil];
	}
		 
	return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[super observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context];
	
	if ([keyPath isEqualToString:@"selection"]) {
		if ([[self selectedObjects] count] > 0) {
			self.selectedObject = [[self selectedObjects] objectAtIndex:0];
		}
		else {
			self.selectedObject = nil;
		}
	}
}

- (void)setSelectedObject:(FKManagedObject *)value {
	if (value != selectedObject) {
		//NSLog(@"setSelectedObject = %@ - stopKeyValueObserving", selectedObject);
		[selectedObject stopKeyValueObserving];
		[selectedObject release];
		selectedObject = [value retain];
		[selectedObject beginKeyValueObserving];
		//NSLog(@"setSelectedObject = %@ - beginKeyValueObserving", selectedObject);
	}
}

- (void)addObject:(id)object {
	[super addObject:object];
	
	[self performSelector:@selector(rearrangeObjects) withObject:nil afterDelay:0.0];
}

@end
